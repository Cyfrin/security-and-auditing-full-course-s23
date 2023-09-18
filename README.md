# Smart Contract Security, Auditing, and Assembly - Full Course

*Made with love by [Cyfrin](https://www.cyfrin.io/) & [The Red Guild](https://theredguild.org/)*

# Prerequisites

An intermediate understanding of solidity. You don't need to be a pro, but you should be familiar with:
- Blockchain basics (transactions, blocks, decentralization, etc)
- Running a smart contract test suite (hardhat, foundry, truffle, etc)
- Solidity basics (variables, functions, structs, etc)

Here are some resources to get you up to speed:
- [Foundry](https://www.youtube.com/watch?v=umepbfKp5rI)
- [Speed Run Ethereum](https://speedrunethereum.com/)

# Outcome 
- Have the skills to be an auditor 
- Speak, interact, and contribute to the web3 security community
- Compete in web3 competitive audits 
- Compete in web3 bug bounties
- Start a career as an independent auditor

# Curriculum

# Lesson 0: Welcome to the Course
  - Why Security?
    - Show some big hacks (rekt.news)
    - Show some big bounties 
    - Show competitive audits
    - Show private audits
    - Why web3 is so important
  - Best Practices

# Lesson 1: Review (Don't skip)
  - Prereqs & Environemnt
  - Solidity & Smart Contracts
  - Foundry
    - chisel
    - cast
    - mainnet-fork
  - AI Helpers (ChatGPT)
  - Forums & Resources
  - ERC20s
  - NFTs (ERC721s)
  - Fallback & Recieve
  - Encoding, Call, & Staticcall
  - Delegatecall & Proxies
  - storage
  - tx.origin vs tx.sender
  - selfdestruct

# Lesson 2: What is a smart contract audit (Security Review)?
  - What is a security review/smart contract audit?
    - People say "audit" -> security review 
    - Their is no silver bullet to auditing
  - Usually 2 phases
    - Initial Review 
    - Mitigation Review
  - [Smart Contract Life Cycle](https://aws.amazon.com/what-is/sdlc/)
    - 1. Plan & Design
    - 2. Develop & Test
    - 3. Smart Contract Audit & Post Deploy Planning
    - 4. Deploy 
    - 5. Monitor & Maintain
  - [Top Smart Contract Auditors (Subjective!)](https://patrickalphac.medium.com/top-7-smart-contract-auditors-bec7bd70dd9f)
  - Tooling
    - Static Analysis
    - Fuzzing / Invariant Tests
    - Formal Verification
    - AI
  - Audit Readiness
    - [Simple Security Checklist](https://github.com/nascentxyz/simple-security-toolkit)
      - Test suite with code coverage
      - Fuzzing, Static Analysis 
      - Natspec (especially for external/public functions)
    - [The Rekt Test](https://blog.trailofbits.com/2023/08/14/can-you-pass-the-rekt-test/)
  - Always learning 

📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝

📝 Exercise: Sign up for one Web3 security newsletter!
- [Solodit (not a newsletter, but has constant updates of new hacks)](https://solodit.xyz/)
- [rekt](https://rekt.news/)
- [Blockchain Threat Intelligence](https://newsletter.blockthreat.io/)
- [Week In Ethereum](https://weekinethereumnews.com/)
- [Consensys Dilligence Newsletter](https://consensys.io/diligence/newsletter/)
- [Officer CIA](https://officercia.mirror.xyz/)

📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝

# Lesson 3: Your first audit | PasswordStore Audit 
Feel free to look ahead and try to find the bugs on the codebase yourself, or get familiar with the protocol first. 

- Security Review > Audit 
  - (have a t-shirt that says "not-audits") 
- We will do "The Tincho" 
  - Read docs
  - Note taking in-code
  - Small -> Large
  - [His ENS Audit](https://www.youtube.com/watch?app=desktop&v=A-T9F0anN1E)
- Exploits
  - Missing `onlyowner`  
      - Access Controls
        - Unprotected sensitive functions
        - Role misconfiguration
        - Privilege escalation
    - Write finding 
    - Mitigation 
  - Storing a secret (private data is not private) 
    - Write finding 
    - Write PoC 
    - Mitigation 
- Writing the Report 
  - Severity Classification 
  - Basic Markdown Report 

🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚

🥚 Exercise: [Sign up for CodeHawks!](https://www.codehawks.com/) 🥚

🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚

# Lesson 4: Manual & Static Analysis | NFT Raffle Audit
We will do case studies for several kinds of bugs to show you how real these are, and how every bug on this list has been exploited in the wild. We will not do case studies for them all, but we will give you details on them. 
- Tooling: 
  - Static Analysis 
  - Solidity Metrics (audit estimation) 
  - [Solidity Visual Developer](https://marketplace.visualstudio.com/items?itemName=tintinweb.solidity-visual-auditor)
- Exploits 
  - Reentrancy 
    - Case Study: DAO Hack 
    - Pattern: FREI-CEII 
  - Bad RNG 
    - Case Study: Meebits 
  - Over/Underflow 
  - DoS 
  - Centralization 
    - Silent Upgrades
    - Case Study: [Oasis](https://medium.com/@observer1/uk-court-ordered-oasis-to-exploit-own-security-flaw-to-recover-120k-weth-stolen-in-wormhole-hack-fcadc439ca9d)
- Writing the report
  - Report writing tooling


🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀

🧑‍🚀 Exercise: [1st Ethernaut Challenge](https://ethernaut.openzeppelin.com/) 🧑‍🚀 

🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀

# Lesson 5: Invariants | XXX Audit
Stateful fuzzing, fuzzing, invariants, FREI-PI/CEII
- Tooling
  - Forge Fuzzing, Stateful Fuzzing, Invariants
    - Echidna, Hypothesis
  - Solodit 
- Exploits
  - Weird ERC20s 
    - [Token integration checklist](https://secure-contracts.com/development-guidelines/token_integration.html)
    - [Weird ERC20 List](https://github.com/d-xo/weird-erc20)
  - Flash Loans
    - Case Study: [Alpha Homora](https://twitter.com/stellaxyz_/status/1360535699368251394)
  - Precompiles: ercrecover
    - Case Study: [Polygon](https://www.youtube.com/watch?v=sgHHbWvWj9A)
  - Oracles 
- Design Patterns:
  - call over transfer
  - pull over push  
  - emergency stop

💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰

💰 Exercize: [1st Damn Vulnerable DeFi Challenge (Tincho!)](https://www.damnvulnerabledefi.xyz/)

💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰

# Lesson 6: Miners & Chains | XXX Audit
We will do "the Hans'" 
- Tooling
  - AI 
  - Tenderly
- Exploits:
  - `block.timestamp` is bad
  - Introduction to MEV
    - [Toxic MEV](https://collective.flashbots.net/t/on-the-toxicity-classification-of-mev-transactions/521)
      - Frontrunning
      - Sandwich Attacks
    - non-toxic
      - Backrunning 
    - MEV Protection
      - Design 
      - [Flashbots Protect](https://docs.flashbots.net/flashbots-protect/overview)
      - [MEVBlocker](https://mevblocker.io/)
      - [Securerpc](https://securerpc.com/)
  - Opcode Support 
    - Case study: [zkSync](https://medium.com/coinmonks/gemstoneido-contract-stuck-with-921-eth-an-analysis-of-why-transfer-does-not-work-on-zksync-era-d5a01807227d)

🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅

🦅 Exercise: [1st CodeHawks Competitive Audit](https://codehawks.com) 🦅

🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅

# Lesson 7: Wallet & Key Management
  - Wallet types
    - Custodial Wallets
    - "Hot" Wallets
      - Metamask
      - Frame
    - "Cold" Wallets
      - Lattice 
      - Trezor
    - Multi-sig (Yes - Set it up)
      - 1 of 1, or x of y
      - Case Study: [Vulcan](https://rekt.news/vulcan-forged-rekt/)
  - Safety (depends on threat vector)
    - Store the private key, not the secret phrase
      - Paper wallet
      - "brain" wallet
      - Encrypted file 
    - Rotate keys
    - [Physical security](https://github.com/jlopp/physical-bitcoin-attacks/blob/master/README.md)
    - Social recovery
  - [Wallets](https://walletcompare.xyz/)
  - Verify Metamask transactions
    - Foundry's cast
    - [Joinfire](https://app.joinfire.xyz/)

🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐

🔐 Exercise: [Set up your Safe!](https://safe.global/) 🔐

🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐

# Lesson 8: EVM Assembly & Opcodes | Yul & Huff
- [EVM Opcodes](https://evm.codes/)
- Introduction to Yul
- Introduction to Huff
  - [huff docs](https://huff.sh/)
- Forge debugger
- Tenderly Debugger

# Lesson 9: Formal Verification & Symbolic Execution
- [Introduction to FV & SE](https://www.youtube.com/watch?v=izpoxfTSaFs)
- Z3 Solution with AI
- Solidity SMT Checker

🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥

🎥 Exercise: [Watch this awesome video](https://www.youtube.com/watch?v=Wm3t8Fuiy1E) 🎥

🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥

# Lesson 10: Essential DeFi Knowledge
- [Defi-minimal](https://github.com/smartcontractkit/defi-minimal)
- AMMs 
  - Uniswap 
- Stablecoins 
  - DAI 
- Borrow & Lending 
  - Aave 
- Oracles 
  - Chainlink 

🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙

🪙 Exersize: [Audit this!](https://github.com/Cyfrin/2023-07-foundry-defi-stablecoin) 🪙

🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙

# Lesson 10: Plan your post deployment
- Bug Bounty
  - Immunefi
  - HackerOne
- Incident response
  - Seal 911 
  - Warroom practice
  - Whitehat vs Blackhat
  - [Responsible Disclosure](https://cheatsheetseries.owasp.org/cheatsheets/Vulnerability_Disclosure_Cheat_Sheet.html)
- Monitoring 
  - Your own
  - Forta
  - [Pessimistic Spotter](https://spotter.pessimistic.io/#form)
  - [OZ Defender](https://defender.openzeppelin.com/#/sentinel)
- Blockchain sleuthing
  - [Metadoc](https://blocksec.com/metadock)
  - [Phalcon](https://phalcon.xyz/)
  - [Dune analytics](https://dune.com/browse/dashboards)
- [More tools](https://github.com/OffcierCia/On-Chain-Investigations-Tools-List)

# Thank you 

## Sponsors 
- [CodeHawks](https://codehawks.com)
- [Solodit](https://solodit.xyz/)

## Lecturers
- [Patrick Collins](https://twitter.com/PatrickAlphaC)
- [Tincho](https://twitter.com/tinchoabbate)
- [Josselin Feist](https://twitter.com/Montyly)
- [Trust](https://www.trust-security.xyz/)

## More Security Stuff
- https://scsfg.io/
- https://github.com/OffcierCia/Crypto-OpSec-SelfGuard-RoadMap
