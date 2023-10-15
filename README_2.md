QUESTIONS:
1. Should L4 H-3 `### [H-3] Integer overflow of `PuppyRaffle::totalFees` loses fees` be a medium? 


<p style="color: red; font-weight: bold">>>>>>  gd2md-html alert:  ERRORs: 0; WARNINGs: 1; ALERTS: 1.</p>
<ul style="color: red; font-weight: bold"><li>See top comment block for details on ERRORs and WARNINGs. <li>In the converted Markdown or HTML, search for inline alerts that start with >>>>>  gd2md-html alert:  for specific instances that need correction.</ul>

<p style="color: red; font-weight: bold">Links to alert messages:</p><a href="#gdcalert1">alert1</a>

<p style="color: red; font-weight: bold">>>>>> PLEASE check and correct alert issues and delete this message and the inline alerts.<hr></p>

# **Smart Contract Security, Auditing, and Assembly**

_Made with love by [Cyfrin](https://www.cyfrin.io/) & [The Red Guild](https://theredguild.org/)_

# **Prerequisites**

An intermediate understanding of solidity. You don't need to be a pro, but you should be familiar with:

* Blockchain basics (transactions, blocks, decentralization, etc)
* Running a smart contract test suite (hardhat, foundry, truffle, etc)
* Solidity basics (variables, functions, structs, etc)

Here are some resources to get you up to speed:

* [Full Foundry Course](https://www.youtube.com/watch?v=umepbfKp5rI)
* [Foundry](https://www.youtube.com/watch?v=umepbfKp5rI)
* [Speed Run Ethereum](https://speedrunethereum.com/)


# Outcome

* Have the foundational skills to become a professional smart contract auditor
* Speak, interact, and contribute to the web3 security community
* Compete in web3 competitive audits
* Compete in web3 bug bounties
* Start a career as an independent auditor

# Curriculum

# **Lesson 0: Welcome to the Course**



* Why Security?
    * Show some big hacks (rekt.news)
        * [$1B in 2023](https://www.theblock.co/post/248550/web3-losses-exceed-1-billion-in-2023-base-exploits) (so far)
        * Web3 vs Web2 hacks. Web2 is mostly PII theft, where Web3 hacks result in irrevocable losses of funds.
        * Bad actors in the space. Lone wolf hackers vs. well funded, persistent nation state actors (e.g. NK).
    * Show some big bounties
    * Career opportunities
        * Top 1% Developer
        * Private Audits
        * Competitive Audits
        * Bug Bounties
        * Future: 
            * Incident Responders
            * On-chain investigators
            * More…
    * Why Web3 is so important
        * Rebuild trust in the ecosystem.
        * Wild West image to the outsiders
* Best Practices for this course


# **Lesson 1: Review (Don't skip)**



* Prereqs & Environment
* Solidity & Smart Contracts
* Foundry
    * chisel
    * cast
    * mainnet-forking
* AI Helpers (ChatGPT)
* Forums & Resources
* ERC20s
* NFTs (ERC721s)
* Fallback & Receive
* Encoding, Call, & Staticcall
* Delegatecall & Proxies
* storage
* tx.origin vs msg.sender
* Selfdestruct (to be removed in an upcoming fork)


# **Lesson 2: What is a smart contract audit (Security Review)?**



* What is a security review/smart contract audit?
    * People say "audit" -> security review
    * There is no silver bullet to auditing, and they have limitations 
* 3 phases
    * Initial Review 
        * 0. Scoping
        * 1. Reconnaissance
        * 2. Vulnerability identification 
        * 3. Reporting 
    * Protocol fixes
        * 1. Fixes issues
        * 2. Retests and adds tests
    * Mitigation Review
        * 1. Reconnaissance
        * 2. Vulnerability identification 
        * 3. Reporting 
* [Smart Contract Development Life Cycle](https://aws.amazon.com/what-is/sdlc/) 
        * Plan & Design 
        * Develop & Test
        * Smart Contract Audit & Post Deploy Planning
            * [Is this just one step?](https://owasp.org/www-project-developer-guide/draft/04-foundations/02-secure-development)
        * Deploy
        * Monitor & Maintain
* [Top Smart Contract Auditors (Subjective!)](https://patrickalphac.medium.com/top-7-smart-contract-auditors-bec7bd70dd9f)
* Tooling
    * Static Analysis
    * Fuzzing / Invariant Tests
    * Formal Verification
    * AI
    * [Tooling vs Humans](https://github.com/ZhangZhuoSJTU/Web3Bugs)
* Audit Readiness
    * [Simple Security Checklist](https://github.com/nascentxyz/simple-security-toolkit)
        * Test suite with code coverage
        * Fuzzing, Static Analysis
        * Natspec (especially for external/public functions)
    * [The Rekt Test](https://blog.trailofbits.com/2023/08/14/can-you-pass-the-rekt-test/)
        * ”Code maturity” is important! 
* Always learning
* Top attack vectors (intro)
* 

<p id="gdcalert1" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image1.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert2">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image1.png "image_tooltip")


📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝

📝 Exercise: Sign up for one security/web3 newsletter!



* [Blockchain Threat Intelligence](https://newsletter.blockthreat.io?r=2mgsm7) (Referral link)
* Cyfrin newsletter?
* [Solodit (not a newsletter, but has constant updates of new hacks)](https://solodit.xyz/)
* [rekt](https://rekt.news/)
* [Week In Ethereum](https://weekinethereumnews.com/)
* [Consensys Diligence Newsletter](https://consensys.io/diligence/newsletter/)
* [Officer CIA](https://officercia.mirror.xyz/)

📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝


# **Lesson 3: Your first audit | PasswordStore Audit**

Feel free to look ahead and try to find the bugs on the codebase yourself, or get familiar with the protocol first.



* Security Review > Audit
    * (have a t-shirt that says "not-audits")
* We will do "The Tincho"
    * Read docs
    * Note taking in-code
    * Small -> Large
    * Tincho’s[ ENS Review](https://www.youtube.com/watch?app=desktop&v=A-T9F0anN1E)
* Exploits
    * Missing `onlyowner`
        * Access Controls
            * Unprotected sensitive functions
            * Role misconfiguration
            * Privilege escalation
        * Write finding
        * Write PoC
        * Mitigation
    * Storing a secret (private data is not private)
        * Write finding
        * Write PoC (Also for missing `onlyOwner`)
        * Mitigation
* Writing the Report
    * Severity Classification
    * Basic Markdown Report

🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚

🥚 Exercises: 



1. [Sign up for CodeHawks!](https://www.codehawks.com/) 
2. [Tweet about your first audit!](https://twitter.com/intent/tweet?text=Just%20completed%20my%20first%20audit%20from%20%23web3education%20and%20signed%20up%20for%20@codehawks%21)

🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚🥚


# **Lesson 4: Manual & Static Analysis | Cute NFT Audit**

We will do case studies for several kinds of bugs to show you how real these are, and how every bug on this list has been exploited in the wild. We will not do case studies for them all, but we will give you details on them.



* Tooling:
    * Static Analysis
    * Solidity Metrics (audit estimation)
    * [Solidity Visual Developer](https://marketplace.visualstudio.com/items?itemName=tintinweb.solidity-visual-auditor)
* Exploits
    * Reentrancy
        * Case Study: DAO Hack
        * [Still plagues us today](https://github.com/pcaversaccio/reentrancy-attacks)
        * Pattern: CEII ( FREI-PI soon!)
    * Bad RNG
        * Case Study: Meebits
    * Arithmetic issues
        * Rounding errors
        * Under/Overflow
    * DoS
    * Handling of ETH
        * [Stuck ETH without a way to withdraw ](https://gist.github.com/tinchoabbate/99fbf7cbce47eb7c463212fd13f21149)
        * Misuse of transfer vs send 
        * Case study: [Sushiswap Miso](https://samczsun.com/two-rights-might-make-a-wrong/)
    * Code Maturity 
* Writing the report
    * Report writing tooling

🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀

🧑‍🚀 Exercises:



1. [Ethernaut Challenge](https://ethernaut.openzeppelin.com/)s (1, 9, and 10) 🧑‍🚀
2. Sign up for [Solodit](https://solodit.xyz/)

🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀🧑‍🚀


# **Lesson 5: Invariants | XXX Audit**

Stateful fuzzing, fuzzing, invariants, FREI-PI/CEII



* Tooling
    * Forge Fuzzing, Stateful Fuzzing, Invariants
        * Echidna, Hypothesis
    * Solodit
* Exploits
    * Weird ERC20s
        * [Token integration checklist](https://secure-contracts.com/development-guidelines/token_integration.html)
        * [Weird ERC20 List](https://github.com/d-xo/weird-erc20)
        * Rebase & fee-on-transfer
        * ERC777 reentrancy callbacks
    * Flash Loans
        * Case Study: [Alpha Homora](https://twitter.com/stellaxyz_/status/1360535699368251394)
    * Precompiles: ercrecover
        * Case Study: [Polygon](https://www.youtube.com/watch?v=sgHHbWvWj9A)
    * Oracles
    * Case Study: 
        * Uniswap
        * [Euler](https://www.youtube.com/watch?v=vleHZqDc48M) 
* Design Patterns:
    * call over transfer
    * pull over push
    * emergency stop
    * FREI-PI

💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰

💰 Exercises: 



1. [Damn Vulnerable DeFi Challenge](https://www.damnvulnerabledefi.xyz/)s 1, 2, and 4
2. Write a tweet thread about an [interesting finding from Solodit](https://solodit.xyz/)

💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰


# **Lesson 6: Upgrades & Storage | XXX Audit **

We look at a minimal project with an upgrade storage collision issue.  



* Tooling
    * [Upgradehub](https://upgradehub.xyz/)
* Exploits
    * Failure to initialize 
        * Case Study: [I accidentally killed it](https://github.com/openethereum/parity-ethereum/issues/6995)
    * Storage collision
    * Centralization
        * Silent Upgrades
        * Case Study: [Oasis](https://medium.com/@observer1/uk-court-ordered-oasis-to-exploit-own-security-flaw-to-recover-120k-weth-stolen-in-wormhole-hack-fcadc439ca9d)
* Metamorphic upgrades
    * Case Study: TORN Governance 

📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦

📦 Exercises:



1. [YAcademy Proxy ](https://proxies.yacademy.dev/)
2. Tweet about how YOU feel about upgradeable smart contracts 

📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦


# **Lesson 7: Miners & Chains | XXX Audit**

We will do "the Hans'"



* Tooling
    * AI
    * Tenderly
* Exploits:
    * `block.timestamp` is bad
    * Introduction to MEV
        * [Toxic MEV](https://collective.flashbots.net/t/on-the-toxicity-classification-of-mev-transactions/521)
            * Frontrunning
            * Sandwich Attacks
        * non-toxic
            * Backrunning
        * MEV Protection
            * Design
            * [Flashbots Protect](https://docs.flashbots.net/flashbots-protect/overview)
            * [MEVBlocker](https://mevblocker.io/)
            * [Securerpc](https://securerpc.com/)
    * Opcode Support
        * Case study: [zkSync](https://medium.com/coinmonks/gemstoneido-contract-stuck-with-921-eth-an-analysis-of-why-transfer-does-not-work-on-zksync-era-d5a01807227d)

🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅

🦅 Exercises: 



1. [1st CodeHawks Competitive Audit](https://codehawks.com/) 
2. Write a blog or tweet on your experience!
3. Read [these tips](https://github.com/0xJuancito/multichain-auditor) for auditing multi-chain protocols 
4. More attacks:
    1. [Signature Replay](https://solodit.xyz/issues/router-signatures-can-be-replayed-when-executing-messages-on-the-destination-domain-spearbit-connext-pdf)
    2. [Merkle tree signature issues](https://solodit.xyz/issues/m-14-merkle-tree-related-contracts-vulnerable-to-cross-chain-replay-attacks-code4rena-factorydao-factorydao-contest-git)
    3. [Polygon Double Spend](https://medium.com/immunefi/polygon-double-spend-bug-fix-postmortem-2m-bounty-5a1db09db7f1)
    4. [Nomad Bridge Hack](https://medium.com/immunefi/hack-analysis-nomad-bridge-august-2022-5aa63d53814a)

🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅

🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅

🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅

🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅🦅


# **Lesson 8: Wallet & Key Management**



* Wallet types
    * Custodial Wallets
    * "Hot" Wallets
        * Metamask
        * Frame
    * "Cold" Wallets
        * Lattice
        * Trezor
    * Multi-sig (Yes - Set it up)
        * 1 of 1, or x of y
        * Case Study: [Vulcan](https://rekt.news/vulcan-forged-rekt/)
        * [Future: Account Abstraction](https://ethereum.org/en/roadmap/account-abstraction/)
* Safety (depends on threat vector)
    * Store the private key, not the secret phrase
        * Paper wallet
        * "brain" wallet
        * Encrypted file
    * Rotate keys
    * [Physical security](https://github.com/jlopp/physical-bitcoin-attacks/blob/master/README.md)
    * Social recovery
* [Wallets](https://walletcompare.xyz/)
* Verify Metamask transactions
    * Foundry's cast
    * [Joinfire](https://app.joinfire.xyz/)

🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐

🔐 Exercises: 



1. [Set up your Safe!](https://safe.global/) 

🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐


# **Lesson 9: EVM Assembly & Opcodes | Yul & Huff**



* [EVM Opcodes](https://evm.codes/)
* Introduction to Yul
    * Security considerations (compiler doesn’t keep you safe anymore!)
* Introduction to Huff
    * [huff docs](https://huff.sh/)
* Forge debugger
* Tenderly Debugger
* Decompilers
    * [Dedaub](https://library.dedaub.com/ethereum/address/0x6b175474e89094c44da98b954eedeac495271d0f/decompiled)
    * [Heimdall](https://github.com/Jon-Becker/heimdall-rs)


# **Lesson 10: Formal Verification & Symbolic Execution**



* [Introduction to FV & SE](https://www.youtube.com/watch?v=izpoxfTSaFs)
* Z3 Solution with AI
* Solidity SMT Checker

🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥

🎥 Exercise: [Watch this awesome video](https://www.youtube.com/watch?v=Wm3t8Fuiy1E) 🎥

🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥🎥


# **Lesson 11: Essential DeFi Knowledge**



* [Defi-minimal](https://github.com/smartcontractkit/defi-minimal)
* AMMs
    * Uniswap
    * Curve
* Stablecoins
    * DAI
* Borrow & Lending
    * Aave
    * Compound 
* Oracles
    * Chainlink
    * TWAPs

🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙

🪙 Exercise: [Audit this!](https://github.com/Cyfrin/2023-07-foundry-defi-stablecoin) 🪙

🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙🪙


# **Lesson 12: Post-deployment**

[Watch this video from DeFi security summit](https://www.youtube.com/watch?feature=shared&v=jSpvDhuaCgc)



* Bug Bounty
    * Immunefi
    * HackerOne
* Incident response
    * Seal 911
    * Warroom practice
    * Whitehat vs Blackhat
    * [Responsible Disclosure](https://cheatsheetseries.owasp.org/cheatsheets/Vulnerability_Disclosure_Cheat_Sheet.html)
* Monitoring
    * Your own
    * Forta
    * [Pessimistic Spotter](https://spotter.pessimistic.io/#form)
    * [OZ Defender](https://defender.openzeppelin.com/#/sentinel)
* Blockchain sleuthing
    * [Metadoc](https://blocksec.com/metadock)
    * [Phalcon ](https://phalcon.xyz/)
    * [OpenChain](https://openchain.xyz/)
    * [Dune analytics](https://dune.com/browse/dashboards)
* What do you do if you find a live issue?
    * Check for a bug bounty 
        * If yes -> Submit, and you’re done
        * If no -> Continue
    * Reach out for help (privately!)
        * Seal 911 (Or other emergency web3 paths)
        * Connect with the team
    * Come up with a plan to fix
        * If they want to fix -> hooray! Do that
        * If they ignore it… You have a few options
            * Give them 45 - 90 days to fix it, and say you will publicly disclose the information if they do not fix it 
            * Attempt a rescue yourself (Ideally, you never reach here)
* White/No/Black Hat Case Studies 
    * Nohats
        * Balancer
        * Vyper
    * Whitehats
        * Astaria
        * ParaSpace 
    * Blackhats
        * Euler
        * Many more


# **Thank you**


## **Sponsors**



* [CodeHawks](https://codehawks.com/)
* [Solodit](https://solodit.xyz/)
* The Red Guild


## **Lecturers**



* [Patrick Collins](https://twitter.com/PatrickAlphaC)
* [Tincho](https://twitter.com/tinchoabbate)
* [Josselin Feist](https://twitter.com/Montyly)
* [Trust](https://www.trust-security.xyz/)

Special thanks



* [hansfriese](https://twitter.com/hansfriese) 
* [carlitox477](https://twitter.com/carlitox477)
* [0Kage](https://twitter.com/hansfriese)
* [giovannidisiena](https://twitter.com/giovannidisiena).eth
* [Alex](https://twitter.com/alexroan) Roan 
* [Peter Kacherginsky](https://twitter.com/_iphelix) 


## **More Security Stuff**

* [https://scsfg.io/](https://scsfg.io/)
* [https://github.com/OffcierCia/Crypto-OpSec-SelfGuard-RoadMap](https://github.com/OffcierCia/Crypto-OpSec-SelfGuard-RoadMap)
* [https://github.com/transmissions11/solcurity](https://github.com/transmissions11/solcurity)
* [https://github.com/OpenCoreCH/smart-contract-auditing-heuristics](https://github.com/OpenCoreCH/smart-contract-auditing-heuristics)
* https://twitter.com/Permissionless/status/1702054516458156126