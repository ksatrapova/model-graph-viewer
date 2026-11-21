# Security

**If a boundary below blocks a task, escalate. Don't route around it.**

## Hard boundaries

- Model weights and downloaded models never go into git; they come from public sources via scripts.
- No tokens (e.g. Hugging Face) in code, config or logs; environment variables only.

## Secrets

This project needs no secrets. If one is ever needed (e.g. a Hugging Face token to download a model), it comes from an environment variable or a gitignored `.env`; a `.env.example` with empty values is what gets committed.

## Data

- Model files and downloaded weights never go into git. Scripts reproduce them.
- Test models are tiny and built in code.

## Review questions for every PR

- Does anything new leave our boundary (dependency, endpoint, telemetry sink)?
- Did a secret or customer data get in (config, fixture, test, log, comment, commit message)?
- Did a permission widen?
- Does a new error path leak internals (stack traces, SQL, connection strings, record content)?

## After a leak

1. **A committed secret is burned.** Rotate it **now**. Deleting the commit doesn't help: it lives in every clone.
2. Tell the repo owner and whoever owns the secret.
3. Check where else it was used and what it could access during the exposure.
4. Only then decide, together, whether to rewrite history. Never alone, never as the first step.
