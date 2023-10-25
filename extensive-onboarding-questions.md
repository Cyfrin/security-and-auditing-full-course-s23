# Protocol Security Review Questions

## Basic Info

| Protocol Name                                |     |
| -------------------------------------------- | --- |
| Website                                      |     |
| Link To Documentation                        |     |
| Key Point of Contact (Name, Email, Telegram) |     |
| Link to Whitepaper, if any (optional)        |     |

## Code Details

| Link to Repo to be audited                              |     |
| ------------------------------------------------------- | --- |
| Commit hash                                             |     |
| Number of Contracts in Scope                            |     |
| Total SLOC for contracts in scope                       |     |
| Complexity Score                                        |     |
| How many external protocols does the code interact with |     |
| Overall test coverage for code under audit              |     |

### In Scope Contracts                                                    

*You could run `tree ./src/ | sed 's/└/#/g; s/──/--/g; s/├/#/g; s/│ /|/g; s/│/|/g'` to get a nice output that works with pandoc for all files in `./src/`*

```
*Place in-scope contracts in here.*
```

## Protocol Details

Tell us a little bit about your protocol.

| Current Status                                                      |     |
| ------------------------------------------------------------------- | --- |
| Is the project a fork of the existing protocol                      |     |
| Specify protocol (only if Yes for prev question)                    |     |
| Does the project use rollups?                                       |     |
| Will the protocol be multi-chain?                                   |     |
| Specify chain(s) on which protocol is/ would be deployed            |     |
| Does the protocol use external oracles?                             |     |
| Does the protocol use external AMMs?                                |     |
| Does the protocol use zero-knowledge proofs?                        |     |
| Which ERC20 tokens do you expect to interact with smart contracts   |     |
| Which ERC721 tokens do you expect to interact with smart contracts? |     |
| Are ERC777 tokens expected to interact with protocol?               |     |
| Are there any off-chain processes (keeper bots etc.)                |     |
| If yes to the above, please explain                                 |     |

## Protocol Risks

Tell us what you consider acceptable risks. We will ignore evaluating some risks based on this feedback.

| Should we evaluate risks related to centralization?                          |     |
| ---------------------------------------------------------------------------- | --- |
| Should we evaluate the risks of rogue protocol admin capturing user funds?   |     |
| Should we evaluate risks related to deflationary/ inflationary ERC20 tokens? |     |
| Should we evaluate risks due to fee-on-transfer tokens?                      |     |
| Should we evaluate risks due to rebasing tokens?                             |     |
| Should we evaluate risks due to the pausing of any external contracts?       |     |
| Should we evaluate risks associated with external oracles (if they exist)?   |     |
| Should we evaluate risks related to blacklisted users for specific tokens?   |     |
| Is the code expected to comply with any specific EIPs?                       |     |
| If yes for the above, please share the EIPs                                  |     |

## Known Issues

Protocol devs are already aware of & working on the following issues and/or consider them acceptable risks.

| Issue #1 |     |
| -------- | --- |

## Previous Audits and Reports

Please share existing audit reports.

| How many previous audits | X   |
| ------------------------ | --- |
| Link to Audit Report(s)  |     |

## Resources

Resources that can help us understand protocol better.

### Flow Charts / Design Docs

- 

### Explainer Videos

- …

### Articles / Blogs

- …

## The Rekt Test

1. Do you have all actors, roles, and privileges documented?
2. Do you keep documentation of all the external services, contracts, and oracles you rely on?
3. Do you have a written and tested incident response plan?
4. Do you document the best ways to attack your system?
5. Do you perform identity verification and background checks on all employees?
6. Do you have a team member with security defined in their role?
7. Do you require hardware security keys for production systems?
8. Does your key management system require multiple humans and physical steps?
9. Do you define key invariants for your system and test them on every commit?
10. Do you use the best automated tools to discover security issues in your code?
11. Do you undergo external audits and maintain a vulnerability disclosure or bug bounty program?
12. Have you considered and mitigated avenues for abusing users of your system?

## Post Deployment Planning

1. Are you planning on using a bug bounty program? Which one/where?
2. What is your monitoring solution? What are you monitoring for?
3. Who is your incident response team? 