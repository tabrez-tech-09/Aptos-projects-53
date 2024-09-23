module SkillValidation::Platform {

    use aptos_framework::signer;
    use aptos_framework::vector;

    struct ValidationResult has store, key {
        user: address,
        passed: bool,
    }

    struct Challenge has store, key {
        issuer: address,
        description: vector<u8>,
        validation_results: vector<ValidationResult>,
    }

    // Function to issue a new challenge
    public fun issue_challenge(account: &signer, description: vector<u8>) {
        let issuer = signer::address_of(account);
        let challenge = Challenge {
            issuer,
            description,
            validation_results: vector::empty(),
        };
        move_to(account, challenge);
    }

    // Function to validate a user's completion of a challenge
    public fun validate_challenge(challenge_owner: address, user: address, passed: bool) acquires Challenge {
        let challenge = borrow_global_mut<Challenge>(challenge_owner);

        // Create a validation result record
        let result = ValidationResult { user, passed };

        // Record the validation result
        vector::push_back(&mut challenge.validation_results, result);
    }
}
