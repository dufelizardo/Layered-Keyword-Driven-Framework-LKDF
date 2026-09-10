# 07 — Governance

This page covers this repository's contribution and behavioral rules — who checks what, before a change counts as done, and how people and AI agents are expected to behave while making it. It is not architecture; for the structural rules themselves see [`README.md`](../README.md) and [`doc/03_constraints.md`](03_constraints.md).

## Change review discipline

[`README.md`](../README.md) §2.0 states the rule plainly: "To maintain design integrity during peer Code Reviews, every code change must match the following matrix constraints exactly," referring to the Responsibility Assignment Matrix that follows it. In practice, that means any change to this repository — whether written by a human or an AI agent — is expected to be checked, before it's considered done, against two things together:

1. The Responsibility Assignment Matrix (`README.md` §2.0): does the change put the right kind of code in the right layer, and does it stay inside that layer's "Admissible Change Trigger" rather than reaching into another layer's territory?
2. The Four Absolute Structural Prohibitions (`README.md` §4.1, elaborated with this repo's own examples in [`doc/03_constraints.md`](03_constraints.md)): does the change respect the strict downward dependency, keep SCENARIO from calling POM directly, keep FLOW off the driver/HTTP client, and keep TEST free of control flow and assertions?

A change that reads correctly line-by-line but violates either of these has not passed review here — the matrix and the prohibitions are the actual pass/fail bar, not a general sense that the code looks fine.

## AI agent governance

This repository maintains a dedicated, portable operational contract for AI agents: [`AGENTS.md`](../AGENTS.md) at the repo root, plus [`agent/ARCHITECTURE.md`](../agent/ARCHITECTURE.md) and `agent/IMPLEMENTATION.md`. These three files are written to be copied into other projects and remain usable on their own, independent of this specific repository's history or example catalog.

In summary — see `AGENTS.md` for the authoritative, complete version rather than treating this as a substitute — an agent working here must read the architecture (`README.md`, then `agent/ARCHITECTURE.md`, then a matching existing example) before writing any code, and produce a short implementation plan before touching any file. The contract also carries a "must not" list: no inventing a new layer or collapsing existing ones, no unrelated refactors, no renaming outside the task's scope, no new framework or library without asking first, no abstraction absent from LKDF "just in case," and no touching files outside the requested scope.

## Version control discipline

This is a real, currently-enforced rule, not a suggestion: **an AI agent never runs `git commit` on the user's behalf.** An agent may stage changes with `git add` when appropriate, but its job stops at handing the user a plain-text commit message to run themselves — the user commits their own work. An agent that is declined once does not ask again in the same session.

## Verification discipline

Also real and currently enforced: a claim about live API or tool behavior must be verified directly — a `curl` against a reachable server, or reading an installed tool's actual source or configuration — rather than assumed from documentation or recalled from training data. When live verification is genuinely impossible for a given example (an unreachable internal or corporate host, for instance), that limitation must be stated explicitly, in two places: a code comment near the affected assertion, and the example's own `README.md`. A spec-derived assumption must never be presented as a verified fact.

## Confidentiality

Some example directories in this repository are marked by their owner as internal or confidential and must never be staged or committed, under any circumstances, regardless of any other instruction. Which directories those are is intentionally out of scope for this page; the standing rule is that a directory's own marking, or a direct instruction from the user, overrides default git behavior unconditionally.

---

For the step-by-step "how do I actually implement a change" procedure, see [`agent/IMPLEMENTATION.md`](../agent/IMPLEMENTATION.md).
