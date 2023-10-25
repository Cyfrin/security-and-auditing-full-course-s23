# Minimal Smart Contract Security Review Onboarding

# Table of Contents

- [Minimal Smart Contract Security Review Onboarding](#minimal-smart-contract-security-review-onboarding)
- [Table of Contents](#table-of-contents)
- [About the project / Documentation](#about-the-project--documentation)
- [Stats](#stats)
- [Setup](#setup)
  - [Requirements](#requirements)
  - [Testing](#testing)
- [Security Review Scope](#security-review-scope)
  - [Commit Hash](#commit-hash)
  - [Repo URL](#repo-url)
  - [In scope vs out of scope contracts](#in-scope-vs-out-of-scope-contracts)
  - [Compatibilities](#compatibilities)
- [Roles](#roles)
- [Known Issues](#known-issues)

# About the project / Documentation

*Summary of the project. The more documentation, the better.*

# Stats

*Use something like solidity metrics or cloc to get these.*

- nSLOC: XX
- Complexity Score: XX
- Security Review Timeline: Date -> Date

# Setup

## Requirements

*What tools are needed to setup the codebase & test suite?*

Example:
```bash
forge init
forge install OpenZeppelin/openzeppelin-contracts --no-commit
forge install vectorized/solady --no-commit
forge build
```

## Testing

*How to run tests. How to see test coverage.*

Example:
```bash
forge test
```

# Security Review Scope

*The specific details of the security review. Nail down exactly what the protocol is planning on deploying, and how they plan on deploying it.*

## Commit Hash
## Repo URL
## In scope vs out of scope contracts
## Compatibilities

- Solc Version: XXX
- Chain(s) to deploy contract to: 
  - XXX (ie: ETH)
  - XXX (ie: Arbitrum)
- Tokens:
  - XXX (ie: ERC20s)
    - XXX (ie: LINK: <address>)
    - XXX (ie: USDC: <address>)
  - XXX (ie: ERC721s)
    - XXX (ie: CryptoKitties: <address>)
  - *List expected ERC20s and other specific tokens. If a protocol is expected to work with multiple or any tokens of a certain standard, you could do something like "All ERC20s". Or an ordered list like "USDC: <USDC Address>" etc*

# Roles

*What are the different actors of the system? What are their powers? What should/shouldn't they do?*

Example:
​
```
Actors:
    Buyer: The purchaser of services, in this scenario, a project purchasing an audit.
    Seller: The seller of services, in this scenario, an auditor willing to audit a project.
    Arbiter: An impartial, trusted actor who can resolve disputes between the Buyer and Seller.
    The Arbiter is only compensated the arbiterFee amount if a dispute occurs.
```

# Known Issues

*List any issues that the protocol team is aware of and will not be acknowledging/fixing.*
