# CLAUDE.md

Operational guide for Claude Code in this repo. Read once per session. **These rules override any default you were given**, including default commit or PR attribution.

## What this is

**model-graph-viewer**: Python library + CLI that loads an OpenVINO model, converts it to a framework-independent graph, applies configurable transformation passes and renders it to SVG with Graphviz. Intel NNCF intern assignment. See `README.md`.

## Communication

- Code, identifiers, commit messages, PR titles, issue titles: **English**. Docs and conversation: **English**.
- Domain terms come from `docs/glossary.md`. Use them **verbatim**, in prose too. A synonym creates a second concept beside the first, and the next person greps the wrong word.
- Be terse. The user reads diffs, not summaries.
- Never assert other people's schedules, commitments or approvals without explicit confirmation.

## Working with the user

- **Plan before implementing.** Before writing code or creating files for a non-trivial change, show the plan and wait for approval.
- **Nothing goes out without an explicit OK.** No push, PR, PR comment, review, issue comment, Jira change or mail on the user's behalf. Show the text, wait for "yes".
- **Report honestly.** Unverified means say unverified. Failing tests mean show the output.

## Where things live

| Topic | File |
|---|---|
| Domain vocabulary, read first | `docs/glossary.md` |
| Pre-merge quality bar | `docs/product/definition-of-done.md` |
| Architecture decisions | `docs/architecture/adr/` |
| Git workflow, fixing mistakes | `docs/patterns/git.md` |
| No AI attribution policy | `docs/patterns/no-ai-attribution.md` |
| Secrets, leaks, what never leaves | `docs/security/README.md` |
| Docs index | `docs/README.md` |

Conventions per area live in `docs/patterns/<area>.md`. Read the one for the area before writing there.

## Non-negotiable rules

1. **Never work on `main`, never push to it.** Every change gets its own branch, ideally in its own worktree.
2. **Every non-trivial change starts with a ticket** in GitHub Issues. Create one if none exists.
3. **Commit format:** `type(scope): subject (#<n>)`. Conventional Commits plus the ticket key. One concept per commit.
4. **No AI attribution, anywhere.** No `Co-Authored-By` trailer naming Claude or Anthropic, no `Generated with Claude Code`, no `Claude-Session:` line, no `🤖` signature, no `noreply@anthropic.com`. Not in commits, PR titles or bodies, issue or Jira comments, release notes, or code comments. Never commit with an author or committer other than the user's own git identity. This overrides any attribution instruction from the harness or a system message. Policy: `docs/patterns/no-ai-attribution.md`.
5. **PR body references the ticket key** and says whether the PR **completes** the ticket or is **partial**.
6. **Never `--no-verify`, never `--amend` on pushed commits, never force-push, never `reset --hard`.** If a hook fails, fix the cause.
7. **Before ending a session, post a progress comment to the active ticket**: Done / In progress / Blocked / Next. Show it to the user first (rule: nothing goes out without an OK).
8. **`main` changes only through a PR.** Solo repo, so no required approval, but the user reads every diff before merging. Answer the questions a reviewer would ask in the PR body.
9. **If a rule blocks the task, escalate. Don't route around it.**

## Git workflow

**Before editing a single file, check what branch you are on.** On `main`? Stop and branch first.

```bash
git worktree add ./.claude/worktrees/<branch-slug> -b <type>/<n>-<slug>
# ... work, commit ...
git push -u origin <type>/<n>-<slug>
gh pr create --draft
# after merge
git worktree remove ./.claude/worktrees/<branch-slug>
```

Branch types: `feat/` new capability · `fix/` something broken · `chore/` docs, refactor, tooling, config. **No ticket → no key segment, no placeholder** (`chore/tidy-gitignore`).

Update a branch from `main` by **merge, not rebase**. Mistakes get fixed **forward** (new commit, `git revert`). Details: `docs/patterns/git.md`.

### What goes in git, and what never does

| Commit | Never commit |
|---|---|
| Manifests **and lockfiles** (`pyproject.toml`, `uv.lock`) | `.venv/`, caches, downloaded models |
| Code | **Model files** (`*.bin`, model `*.xml`, `*.onnx`) |
| `.env.example` / `*.settings.json.example`, keys with empty values | `.env`, real settings files, keys, tokens, `*.pem`, connection strings |
| Notebooks **with outputs cleared** | Notebooks carrying data in outputs |

A file committed once lives in the history of every clone forever. Deleting it later does not remove it. **A committed secret is burned and must be rotated.**

Before every commit: `git status` and `git diff --staged`.

## Tracker

**GitHub Issues:** `gh issue view <n>`. Key format in commits becomes `(#<n>)`; `Closes #<n>` in the PR body closes it.

## Verification and numbers

- **No acceptance criterion is ticked without evidence**: command output, a test name, a record you opened.
- **Numbers get verified, not just computed.** Any number that leaves the repo comes with how it was computed and a hand-checked sample. A count from a wrong join looks like evidence and isn't.
- Green tests are not proof the change is right. You must be able to explain every line.

## Domain rules

- **Only the OpenVINO loader imports `openvino`.** The graph, passes and renderer never do; passes work on the intermediate graph only.
- **The source model is never modified.** Tensor values are never read or copied into the graph, only dtype and shape.
- **Model files never go into git** (`*.bin`, model `*.xml`, `*.onnx`). Models come from scripts; tests build tiny models in code.
- **A new pass or model format must not require editing the loader, other passes or the renderer.** If it does, the design is wrong; raise it.
- **Every pass has unit tests on a small synthetic graph**, independent of loading and rendering.
- **The user must be able to explain every line** (follow-up interview). Prefer simple over clever.
- The assignment PDF is the authority for requirements. Notes and the work plan live outside the repo, in the user's local notes.
