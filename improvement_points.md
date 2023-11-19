# Improvement notes

Some improvement notes on how to teach security and auditing in future curriculums. 


## Audit / Bug Walkthroughs
1. Potentially try a new setup for doing audit walkthroughs.
   1. Option A: Intro Bugs -> find in walkthrough 
      1. First, go through a list of bugs
         1. Introduce bug names 
         2. Show diagrams of them
         3. Show a demo of them in remix
         4. Write out a PoC of them in foundry (classic video stuff)
         5. Case studies on real-world examples of the bug 
      2. Then, go through a walkthrough of the audit, and say "we are ONLY going to be looking for these class of bugs"
         1. Walk into bug during manual review/fuzz testing/etc
         2. Do PoC in foundry
         3. Write report 
   2. Option B: Find bugs as you come across them (the current implementation, sort of)

I think we should try Option A. Then, after each section, give students a DIFFERENT codebase for them to find the bugs in. Ideally these codebases can be made into first flights later. 