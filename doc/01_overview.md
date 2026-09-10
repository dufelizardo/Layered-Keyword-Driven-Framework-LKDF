# 01 — Overview

## What LKDF is

The Layered Keyword-Driven Framework (LKDF) is a reference architecture for test automation that splits every automated check into four decoupled layers — `TEST`, `SCENARIO`, `FLOW`, and `POM` — connected by a strict downward-only dependency rule. Data provisioning, journey structure, business logic, and technical execution each live in their own layer, so a change in one (a new selector, a new business rule, a new data variation) never forces a change in the others. The goal is to replace the geometric maintenance cost of ad hoc test scripts with an asymptotically linear one.

## How this repository is organized

At the top level:

- **`README.md`** / **`WHITEPAPER.md`** — the architecture itself and its deeper rationale (academic grounding, cost model, ROI case). `README-pt.md` and `WHITEPAPER-pt.md` are their Portuguese translations.
- **`AGENTS.md`** + **`agent/`** — the operational contract for AI coding agents working in any LKDF project. `agent/ARCHITECTURE.md` and `agent/IMPLEMENTATION.md` are written to be portable: copy them into a different repository and they still stand on their own.
- **`doc/01_overview.md`** through **`doc/08_references.md`** — this repository's own documentation, including the file you're reading now.
- **`exemples/`** — the actual built examples, one subdirectory per tool (`exemple_robot_framework/`, `exemple_playwright/`), each holding one or more self-contained, independently runnable example implementations.

## Authority chain

Five kinds of files talk about "the architecture" in this repository, and they are not five competing opinions — they form one chain:

1. **`README.md` is architectural law.** Every rule LKDF enforces traces back to it. If any other document in this repository ever appears to say something different, `README.md` wins.
2. **`agent/ARCHITECTURE.md` and `agent/IMPLEMENTATION.md` are the portable operational realization of that law** — the same rules translated into concrete, tool-level conventions and a step-by-step recipe, written so they can be lifted into a project that has never heard of this repository and still make sense.
3. **The `doc/0N_*.md` files — including this one — document this repository specifically.** They record its own history, its own example catalog, and the patterns actually observed in its own example code. They never invent a new rule; they only cite or elaborate what `README.md` already states or what the example code already does.

Treat that as a strict precedence order when reading, not five independent sources to reconcile yourself.

## Proven twice

LKDF did not start as working code — it started as an architectural methodology, described first in `README.md` and `WHITEPAPER.md`. This repository exists to prove that methodology holds up in practice, and it has now done so along two different axes:

- **Across increasingly complex API surfaces.** The first example, `petstore_api_v_2`, implements all 20 documented operations of the classic Swagger Petstore v2 demo API. A second example, `petstore_api_v_3_1`, repeats the exercise against the real OpenAPI 3.1 Petstore reference server, including three confirmed live-server bugs the suite works around rather than papers over.
- **Across a tool change.** The `viacep` example exists twice — once in Robot Framework, once in Playwright/TypeScript — implementing the identical two operations under the identical suite IDs (`US-025`/`US-026`). The only layer that had to change was `POM`; `SCENARIO` and `FLOW` carried over unchanged, which is the architecture's central claim made concrete.

See `doc/06_exemples.md` for the full example catalog, including what each one covers and how to run it.

## Where to go next

| Looking for... | Go to |
| --- | --- |
| Architecture rules (the four layers, the prohibitions) | [`README.md`](../README.md) |
| Deep rationale (academic grounding, cost model) | [`WHITEPAPER.md`](../WHITEPAPER.md) |
| How an AI agent should operate in this repo | [`AGENTS.md`](../AGENTS.md) |
| The example catalog | [`doc/06_exemples.md`](06_exemples.md) |
