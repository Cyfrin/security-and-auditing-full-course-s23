pragma solidity ^0.4.24;

contract Example {
    struct EIP712Domain {
        string name;
        string version;
        uint256 chainId;
        address verifyingContract;
    }

    struct Person {
        string name;
        address wallet;
    }

    struct Mail {
        Person from;
        Person to;
        string contents;
    }

    bytes32 constant EIP712DOMAIN_TYPEHASH =
        keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");

    bytes32 constant PERSON_TYPEHASH = keccak256("Person(string name,address wallet)");

    bytes32 constant MAIL_TYPEHASH =
        keccak256("Mail(Person from,Person to,string contents)Person(string name,address wallet)");

    bytes32 DOMAIN_SEPARATOR;

    constructor() public {
        DOMAIN_SEPARATOR = hash(
            EIP712Domain({
                name: "Ether Mail",
                version: "1",
                chainId: 1,
                // verifyingContract: this
                verifyingContract: 0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC
            })
        );
    }

    function hash(EIP712Domain eip712Domain) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                EIP712DOMAIN_TYPEHASH,
                keccak256(bytes(eip712Domain.name)),
                keccak256(bytes(eip712Domain.version)),
                eip712Domain.chainId,
                eip712Domain.verifyingContract
            )
        );
    }

    function hash(Person person) internal pure returns (bytes32) {
        return keccak256(abi.encode(PERSON_TYPEHASH, keccak256(bytes(person.name)), person.wallet));
    }

    function hash(Mail mail) internal pure returns (bytes32) {
        return keccak256(abi.encode(MAIL_TYPEHASH, hash(mail.from), hash(mail.to), keccak256(bytes(mail.contents))));
    }

    function verify(Mail mail, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
        // Note: we need to use `encodePacked` here instead of `encode`.
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash(mail)));
        
        // Enhanced signature validation
        // 1. Check for valid v parameter (27 or 28 for Ethereum)
        if (v != 27 && v != 28) {
            return false;
        }
        
        // 2. Check for valid r and s parameters (must be non-zero and within valid range)
        if (r == 0 || s == 0) {
            return false;
        }
        
        // 3. Check s value is in lower half of curve order (prevents signature malleability)
        // secp256k1 curve order n = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141
        bytes32 maxS = 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0;
        if (s > maxS) {
            return false;
        }
        
        // 4. Perform ecrecover with additional safety checks
        address signer = ecrecover(digest, v, r, s);
        
        // 5. Ensure signer is not zero address and matches expected sender
        if (signer == address(0)) {
            return false;
        }
        
        // 6. Ensure the expected sender is not zero address
        if (mail.from.wallet == address(0)) {
            return false;
        }
        
        return signer == mail.from.wallet;
    }

    /**
     * @dev Alternative secure signature verification using bytes signature
     * @param mail The mail struct to verify
     * @param signature The signature bytes (65 bytes: r + s + v)
     * @return bool indicating if signature is valid
     */
    function verifySignature(Mail mail, bytes signature) internal view returns (bool) {
        if (signature.length != 65) {
            return false;
        }
        
        bytes32 r;
        bytes32 s;
        uint8 v;
        
        // Extract r, s, v from signature
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
        
        // Adjust v if necessary (some wallets use 0/1 instead of 27/28)
        if (v < 27) {
            v += 27;
        }
        
        return verify(mail, v, r, s);
    }

    function test() public view returns (bool) {
        // Example signed message
        Mail memory mail = Mail({
            from: Person({name: "Cow", wallet: 0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826}),
            to: Person({name: "Bob", wallet: 0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB}),
            contents: "Hello, Bob!"
        });

        uint8 v = 28;
        bytes32 r = 0x4355c47d63924e8a72e509b65029052eb6c299d53a04e167c5775fd466751c9d;
        bytes32 s = 0x07299936d304c153f6443dfa05f40ff007d72911b6f72307f996231605b91562;

        assert(DOMAIN_SEPARATOR == 0xf2cee375fa42b42143804025fc449deafd50cc031ca257e0b194a650a912090f);
        assert(hash(mail) == 0xc52c0ee5d84264471806290a3f2c4cecfc5490626bf912d01f240d7a274b371e);
        assert(verify(mail, v, r, s));
        return true;
    }
}
