# Git: how work moves through this repo

The non-negotiables live in [`CLAUDE.md`](../../CLAUDE.md). This file is the *how*: the lifecycle around them, and what to do when something has already gone wrong.

## Before you touch anything

- ✅ **Check which branch you're on** (`git status`). On the default branch? Stop and branch first.
- ✅ **Have a ticket** for anything non-trivial. Branch, commits and PR all point at it.
- ✅ **Your git identity is you**: `git config user.name` / `user.email`.
- ❌ Don't work on the default branch and don't push to it.

## Lifecycle

```bash
# 1. ticket exists
# 2. branch in its own worktree
git worktree add ./.claude/worktrees/<slug> -b <type>/<KEY>-<n>-<slug>
# 3. work, commit as you go
# 4. push and open a draft PR
git push -u origin <type>/<KEY>-<n>-<slug>
gh pr create --draft
# 5. after merge
git worktree remove ./.claude/worktrees/<slug>
```

`git worktree list` is the honest answer to "what am I in the middle of".

## Branches

- `<type>/<KEY>-<n>-<short-summary>`: `feat/` new capability · `fix/` broken · `chore/` docs, refactor, tooling, config.
- No ticket → no key, never a placeholder: `chore/tidy-gitignore`.
- ❌ Don't switch branches with uncommitted changes; they get dragged along.
- ❌ Don't let a branch live for weeks.

## Commit messages

```
type(scope): what it does, imperative mood (KEY-123)
```

| type | when |
|---|---|
| `feat` | new functionality |
| `fix` | bug fix |
| `docs` | documentation only |
| `refactor` | same behaviour, different code |
| `test` | tests only |
| `chore` | deps, config, cleanup |
| `ci` | pipelines |

- ✅ The subject says what changes and why it matters. The body says **why** and how it was verified.
- ❌ No "fix stuff", "wip", "changes".
- ❌ **No AI attribution**: no `Co-Authored-By: Claude`, no `Generated with Claude Code`, no `Claude-Session:`. See [no-ai-attribution.md](no-ai-attribution.md).

## One commit = one concept

- If the subject needs "and", it's two commits.
- **Revert test:** reverting it should undo only that one thing.
- Reformatting stays separate from behaviour changes.
- A dependency change goes in **with its lockfile**.

## What never goes into git

Customer data, secrets, `.env`, real settings files, notebooks with outputs, build output. Full table in `CLAUDE.md`. A file committed once lives in every clone forever.

Before every commit: `git status` + `git diff --staged`.

## Updating a branch

**Merge, don't rebase:** `git merge origin/<default-branch>`. Rebasing a pushed branch needs a force-push, which is banned. Resolve conflicts in one commit and say in the PR what you resolved.

## When something goes wrong: fix forward

| Situation | What to do |
|---|---|
| Bad last commit, not pushed | `git reset --soft HEAD~1`, recommit |
| Already pushed | new commit on top; `git revert <sha>` if the change was wrong |
| Bad commit message | leave it, mention it in the PR |
| AI attribution got in | see [no-ai-attribution.md](no-ai-attribution.md#if-it-already-happened) |
| **Secret committed** | **stop and escalate; rotate the key.** See [security](../security/README.md#after-a-leak) |

## Banned

`--amend` on pushed commits · force-push · `--no-verify` · `reset --hard` · rebasing pushed branches · bare `git stash` with worktrees (the stash is shared across them; use a WIP commit).

## Pull request

- Draft while it's moving. Title in commit format.
- Body: what, why, how verified, ticket key, completes/partial. No AI attribution.
- Run what CI runs before pushing.
- After merge: remove the worktree, close the ticket.

## Checklist before a commit

1. [ ] not on the default branch
2. [ ] `git diff --staged`: no data, no secrets
3. [ ] one concept, no "and"
4. [ ] `type(scope): subject (KEY-n)`, no attribution lines
5. [ ] lockfile with the dependency
6. [ ] build/tests pass locally
