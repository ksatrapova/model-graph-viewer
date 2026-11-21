# Definition of Done

The bar every change meets before it reaches the default branch. Quality lives **in the ticket and in the verification**, not in chat.

A change is done when **every item below holds**, not when it "looks done".

## Checklist

- [ ] **Every acceptance criterion of the ticket is met**, and the PR body says **how it was verified**: command output, a test, a number with how it was computed, a record you opened. **Nothing ticked without evidence.**
- [ ] **Numbers are verified, not just computed.** Any number leaving the repo comes with a hand-checked sample.
- [ ] **Glossary terms used verbatim** in code, commits and prose.
- [ ] **No data and no secrets in git.**
- [ ] **No AI attribution**: no `Co-Authored-By` naming Claude/Anthropic, no "Generated with Claude Code", no `Claude-Session` line, every commit authored by the person. The `no-ai-attribution` check is green.
- [ ] **Commits are atomic and ticket-linked**: `type(scope): subject (KEY-n)`, one concept each.
- [ ] **CI-equivalent checks pass locally** (build, test, format/lint).
- [ ] **Docs updated** where behaviour changed.
- [ ] **PR body references the ticket** and says completes / partial.
- [ ] **Progress comment** on the ticket: Done / In progress / Blocked / Next.

## A person reads the PR

The reviewer will ask: *Why this value? What if it's empty? How many does it affect? Where does it come from?* **Answer in the PR body before they ask.** If you can't, write that in *Review notes*.

**A PR its author can't explain isn't done.** Green tests are not proof.

## When a criterion can't be verified

Don't tick it. Find a way to verify it, or write in the PR **exactly why not and what risk stays open**.

## Relationship to the ticket

A change is only as good as its ticket. Vague criteria give vague verification. Invest in the ticket first; the rest is mechanical.
