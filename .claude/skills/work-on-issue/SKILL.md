---
name: work-on-issue
description: |
  Take ONE ticket from open to PR in a single pass, with zero clarifying questions.
  The ticket is the contract: everything the work needs must already be written there.
  Reads the ticket, branches, implements against the acceptance criteria, verifies each
  one with evidence, prepares the PR and a progress comment.

  Triggers: "work on <KEY>-N", "implement issue N", "do <KEY>-N", "udělej <KEY>-N",
  or any phrasing naming a single ticket to be taken from open to PR.

  Does NOT trigger for: planning ("plan/scope <KEY>-N"; use the ticket-scoper agent),
  questions about a ticket, multi-ticket requests, or work with no ticket.
---

# Work On Issue

Take one ticket from open to PR. **No clarifying questions in chat.** Requirements discussed in chat evaporate; the next person gets a different answer. So the ticket is the only source of truth, and every gap goes back **into the ticket**.

## Hard rules

1. **Decide from the ticket, or stop.** If a decision isn't answerable from the ticket, its acceptance criteria or the repo docs, take the *Underspecified ticket* path.
2. **Obey every non-negotiable in `CLAUDE.md`**: no work on the default branch, branch naming, atomic ticket-linked commits, **no AI attribution**, no `--no-verify` / `--amend` / force-push.
3. **Nothing goes out without the user's OK.** Pushing, opening the PR and posting comments are shown to the user first, then done on "yes".
4. **A human reviews the PR.** You prepare work a reviewer can check; you are not the gate.

## Procedure

Make a todo per step and work them in order.

### 1. Read the ticket

Use the tracker named in `CLAUDE.md` → *Tracker* (Jira via Atlassian MCP, or `gh issue view <n> --json number,title,body,labels,comments`).

Extract: what to build, acceptance criteria, terms, dependencies. **Read `docs/glossary.md` first.** Then what `CLAUDE.md` → *Where things live* points at.

### 2. Gate: is it executable?

Only if **all** hold:
- There is an **Acceptance criteria** section with at least one criterion.
- **Every criterion is measurable**: checkable by running something, by a number, or by opening a named record. "Works well" is not.
- No criterion depends on an unmade decision (a threshold with no value, a field with no name).

Otherwise → *Underspecified ticket*.

### 3. Blockers

If the ticket is blocked by an open ticket, stop. Draft a comment saying which one and tell the user in one line.

### 4. Branch

```bash
git worktree add ./.claude/worktrees/<slug> -b <feat|fix|chore>/<KEY>-<n>-<slug>
```

### 5. Implement

- Follow `docs/patterns/<area>.md` for the area you touch and `docs/patterns/git.md`.
- **Glossary terms verbatim**, in code, commits and prose.
- One concept per commit: `type(scope): subject (<KEY>-<n>)`. **No `Co-Authored-By`, no "Generated with" footer, no `Claude-Session` line.**
- Delegate broad searches to subagents to keep context lean.
- If a rule blocks the task, escalate. Don't route around it.

### 6. Verify every acceptance criterion

For each criterion, get **evidence**: command output, a test name, a number with how it was computed, a record you opened. Numbers get a hand-checked sample. **No criterion is claimed without evidence.** Run the `dod-verifier` agent.

### 7. PR (after the user's OK)

Show the user the PR title and body first. Then:

```bash
git push -u origin <branch>
gh pr create --draft --title "<type(scope): subject (KEY-n)>" --body-file <file>
```

Body follows `.github/PULL_REQUEST_TEMPLATE.md`: each criterion with its verification, numbers with how they were checked, the ticket key and **completes / partial**. **No AI attribution in the body.**

The reviewer will ask *why this value, what if it's empty, how many does it affect, where does this come from*. **Answer in the body before they ask.** If you can't, say so in *Review notes*.

### 8. Progress comment (after the user's OK)

Done / In progress (exactly where) / Blocked / Next, plus the PR link.

### 9. Report

What shipped, the PR URL, and any criterion that couldn't be verified, with why. **Don't claim done for anything unverified.**

## Underspecified ticket

1. Draft **one** ticket comment listing exactly what's missing: absent or unmeasurable criteria, unmade decisions, needed inputs (values, names, sources). Specific enough that answering it makes the ticket executable.
2. Show it to the user; post on "yes".
3. Stop. No branch, no code. Tell the user in one line to re-run once the ticket is updated.
