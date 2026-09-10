# AGENTS.md — LKDF entry point for AI coding agents

This file is the entry point for any AI agent (Claude, Codex, Copilot, or any other) working in this repository. It does not define architecture — it sequences what to read, in what order, and states the procedural rules that apply on top of that architecture.

## 1. Read order (mandatory, in this order)

1. **This file.**
2. **[`README.md`](README.md) §1.0–4.0** — the architectural law. Four layers (`POM → FLOW → SCENARIO → TEST`), the Responsibility Assignment Matrix (§2.0), the Four Absolute Structural Prohibitions (§4.1). Everything else in this repo exists to elaborate on, never override, what's written there.
3. **[`agent/ARCHITECTURE.md`](agent/ARCHITECTURE.md)** — the same rules translated into concrete, tool-level conventions (file naming, keyword naming, request/response patterns). This file is portable — it was written to be copied into any project and still make sense on its own.
4. **The closest existing example that matches your target tool and resource shape** — see [`doc/06_exemples.md`](doc/06_exemples.md) for the catalog. Read one full operation (POM + FLOW + SCENARIO + TEST) before writing your own; imitate its structure, not just its idea.
5. **[`agent/IMPLEMENTATION.md`](agent/IMPLEMENTATION.md)** — the step-by-step procedure, including the mandatory planning checkpoint below.
6. **[`agent/templates/`](agent/templates/)** — the actual starting files to copy for each layer, in both API and UI form, before writing anything from scratch.

`doc/01_overview.md` through `doc/08_references.md` document *this specific repository* (its own history, patterns, and example catalog) — read them for context, but `README.md` and `agent/ARCHITECTURE.md` remain the rule source if anything ever conflicts.

## 2. Before writing any code

You MUST:
1. Complete the read order above.
2. Identify the operation (HTTP method + path, UI action, or DB operation) and the scenarios it needs (see `agent/IMPLEMENTATION.md` for how to scope these).
3. Produce a short implementation plan **before touching any file**. Minimum shape:

   ```yaml
   story: US-0NN            # see agent/IMPLEMENTATION.md for how IDs are assigned
   tool: <robot|playwright|...>
   target_example: <path to the example directory>
   operation: <METHOD /path or UI action>
   pom_keywords: [...]
   flow_keywords: [...]      # one per scenario, plus the dispatcher
   scenario_keyword: <name>  # checked against pom_keywords for naming collisions
   scenarios: [...]          # each with the status/outcome it asserts and why it's included
   ```

4. Validate that plan against the Four Absolute Structural Prohibitions (README §4.1) and the Responsibility Assignment Matrix (README §2.0).
5. Only then implement, bottom-up: POM → FLOW → SCENARIO → TEST (see `agent/IMPLEMENTATION.md`).

You MUST NOT:
- Invent a new layer, or collapse two existing layers into one.
- Refactor code unrelated to the requested change.
- Rename existing keywords/functions/files outside the scope of the task.
- Introduce a new framework, library, or architectural pattern not already used in this repo, without asking first.
- Create an abstraction that doesn't exist anywhere else in LKDF "just in case."
- Touch files outside the scope the user actually asked for.

## 3. Repo-specific operating rules (not architecture — behavior)

- **Never run `git commit`.** Stage with `git add` when appropriate, and hand the user a plain-text commit message to run themselves. Do not ask to commit again after being declined once.
- **Verify, don't guess.** When a live server is reachable, confirm status codes/response shapes with a real request (e.g. `curl`) before writing an assertion for it — do not trust API documentation alone. When it is genuinely unreachable (an internal/corporate host, for instance), say so explicitly in a code comment near the affected keyword and in the example's `README.md` — never present a spec-derived assumption as a verified fact.
- For tool/editor configuration questions (how a VS Code extension routes output, how a test runner resolves a flag, etc.), read the installed tool's own source or docs rather than recalling from training data.
- Some example directories in this repository are marked confidential by the user and must never be staged or committed, regardless of any other instruction in this file. If a directory's own `README.md` or a direct user instruction says "do not commit," that overrides everything else, including any default git behavior.
- Every example directory under `exemples/` is self-contained: no cross-example imports. Each has its own `src/pom/common/`, `src/flow/common/`, and `run_tests.sh`/`run_tests.ps1` writing to its own `results/`.

## 4. Where things live

| Question | Source |
| --- | --- |
| What are the 4 layers and their hard rules? | [`README.md`](README.md) §1.0–4.0 |
| Why does this architecture exist / deeper rationale? | [`WHITEPAPER.md`](WHITEPAPER.md) |
| How do I realize those rules concretely (naming, patterns), portable to any project? | [`agent/ARCHITECTURE.md`](agent/ARCHITECTURE.md) |
| What are the exact steps to add or change a test, in order? | [`agent/IMPLEMENTATION.md`](agent/IMPLEMENTATION.md) |
| What does this repo's own history/reasoning/example catalog look like? | [`doc/01_overview.md`](doc/01_overview.md) … [`doc/08_references.md`](doc/08_references.md) |
| What does a full worked example look like end-to-end? | The example itself, via [`doc/06_exemples.md`](doc/06_exemples.md) |
| How do I install this kit (`AGENTS.md` + `agent/`) into a *different* project? | [`agent/README.md`](agent/README.md) |

## 5. Not built yet (do not assume these exist)

`agent/DECISION-RULES.md`, `agent/VALIDATION.md`, and `agent/examples/US-0NN/` are planned but not created. `agent/templates/` exists — use it. If you need a decision rule not yet written down, derive it from the Responsibility Assignment Matrix and the Four Absolute Structural Prohibitions, and flag the gap to the user rather than guessing silently.
