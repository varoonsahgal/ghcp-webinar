# 🏦 Ledgerly Payments — the Agent Squad demo

A deliberately buggy **legacy Java 17 payments service**. All 4 unit tests pass,
yet the nightly batch quietly loses money. A squad of Copilot agents finds the bugs,
proves them with failing tests, and fixes them, all inside guardrails.

```text
=== Ledgerly Payments - nightly batch ===
1. Invoice 100.00 USD in 3 installments: [33.33, 33.33, 33.33]
   Total we will collect:                 99.99            ← a penny vanished
2. Interest on 1,000,000 @ 5% for 90 days: 0.0              ← integer division
3. Trade on Thu 2026-10-08 settles on Sun 2026-10-11        ← banks are closed on Sunday
4. Payments received: 3, after de-duplication: 3            ← equals() without hashCode()
[FX] key=DEMO-ONLY-… account=4400-1234-5678-9012 …          ← secret + PII in logs
```

## What's inside

| Path | Copilot feature | What it does |
|---|---|---|
| `.github/copilot-instructions.md` | Always-on instructions | Build commands and team conventions |
| `.github/agents/tech-lead.agent.md` | **Custom agent (coordinator)** | Runs subagents in parallel, then fixes code. Has an agent-scoped `Stop` hook and two handoffs |
| `.github/agents/bug-hunter.agent.md` and the other workers | **Subagents** | Read-only specialists (`user-invocable: false`) |
| `.github/agents/code-reviewer.agent.md` | Handoff target | Independent review. `disable-model-invocation: true`, so only a human can start it |
| `.github/skills/money-handling/` | **Agent skill** | Banking money rules, plus a script and a reference file loaded only when needed |
| `.github/skills/junit5-tests/` | **Agent skill** | Red-green testing conventions |
| `.github/hooks/audit.json` | **Hooks** | Logs every prompt, tool call and subagent to `.github/hooks/logs/`, and injects context |
| `.github/hooks/guardrails.json` | **Hooks** | Blocks `rm -rf`, `git push`, deploys, and edits to the hooks themselves |
| `.github/hooks/scripts/quality-gate.*` | **Agent-scoped hook** | The Tech Lead can't finish while `mvn test` is red |

## Run it

```bash
mvn -q test                                                   # green (that's the problem)
mvn -q compile && java -cp target/classes com.ledgerly.payments.App
```

## Demo it

```bash
scripts/setup-demo.sh        # once: git init + tag the baseline
scripts/watch-timeline.sh    # in a side terminal: live agent timeline from the hooks
scripts/reset-demo.sh        # between runs
```

Then in VS Code Chat, set **Session Target → Local**, pick the **Tech Lead** agent, and send:

> Get the nightly batch audit-ready.

Windows users: use the `.ps1` versions of the scripts. The hooks pick the right one automatically.
