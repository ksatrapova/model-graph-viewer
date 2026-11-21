#!/usr/bin/env bash
# PreToolUse guard (Bash and PowerShell tools): block any command that would credit Claude/Anthropic in
# git history or in text published to GitHub/Jira. Exit 2 = block; stderr goes back
# to Claude as the reason. Policy: docs/patterns/no-ai-attribution.md
#
# Covers: git commit / merge / tag / notes, gh pr|issue|release create|edit|comment|review,
# including text passed via -F/--file/--body-file. Also blocks committing under a
# non-user identity (--author, -c user.*, GIT_AUTHOR_*/GIT_COMMITTER_* env).

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
[ -z "$cmd" ] && exit 0

# Only inspect commands that write history or publish text.
# Read-only commands (git log, gh pr list/view) pass even if they search for the markers.
writes='git[[:space:]]+(commit|merge|tag|notes|revert|cherry-pick)'
writes+='|gh[[:space:]]+(pr|issue|release)[[:space:]]+(create|edit|comment|review|merge)'
writes+='|gh[[:space:]]+api.*(-X|--method)[[:space:]]*(POST|PATCH|PUT)'
writes+='|GIT_(AUTHOR|COMMITTER)_'
if ! printf '%s' "$cmd" | grep -qiE "$writes"; then
  exit 0
fi

markers='co-authored-by:.*(claude|anthropic)|noreply@anthropic\.com|generated (with|by) \[?claude|claude\.ai/code|claude\.com/claude-code|claude-session:|🤖'

block() {
  echo "BLOCKED by no-ai-attribution: $1" >&2
  echo "CLAUDE.md rule 4: no AI attribution in commits, PRs, issues or comments; the author is always the user. Remove it and retry. See docs/patterns/no-ai-attribution.md" >&2
  exit 2
}

# 1) Markers inline in the command (-m "...", heredoc, --body "...").
if printf '%s' "$cmd" | grep -qiE "$markers"; then
  block "the command text credits Claude/Anthropic."
fi

# 2) Markers inside a file passed as the message/body.
for f in $(printf '%s' "$cmd" | grep -oE '(-F|--file|--body-file|--notes-file)[= ]+[^ ;&|]+' | sed -E 's/^(-F|--file|--body-file|--notes-file)[= ]+//; s/^["'\'']//; s/["'\'']$//'); do
  if [ -f "$f" ] && grep -qiE "$markers" "$f"; then
    block "message file '$f' credits Claude/Anthropic."
  fi
done

# 3) Committing under someone else's identity.
if printf '%s' "$cmd" | grep -qiE -- '--author[= ]|-c[[:space:]]+user\.(name|email)|GIT_(AUTHOR|COMMITTER)_(NAME|EMAIL)[[:space:]]*='; then
  block "overriding the commit author/committer is not allowed; commits are authored by the user's own git identity."
fi

exit 0
