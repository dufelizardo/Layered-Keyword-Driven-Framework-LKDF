# 08 — References

An index of everything this repository points to, internal and external. See [`doc/01_overview.md`](01_overview.md) for how these sources relate to each other (the authority chain).

## Internal — architecture & governance

- [`README.md`](../README.md) — the architectural law: the four layers, the Responsibility Assignment Matrix, the Four Absolute Structural Prohibitions.
- [`README-pt.md`](../README-pt.md) — Portuguese translation of the above.
- [`WHITEPAPER.md`](../WHITEPAPER.md) — the deep rationale behind the architecture.
- [`WHITEPAPER-pt.md`](../WHITEPAPER-pt.md) — Portuguese translation of the above.
- [`AGENTS.md`](../AGENTS.md) — entry point and operating rules for AI coding agents in this repository.
- [`agent/ARCHITECTURE.md`](../agent/ARCHITECTURE.md) — the portable, tool-level realization of the architecture rules.
- [`agent/IMPLEMENTATION.md`](../agent/IMPLEMENTATION.md) — the portable, step-by-step implementation recipe.
- [`doc/07_governance.md`](07_governance.md) — contribution and behavioral rules for this repository.

## Internal — this repository's own documentation

- [`doc/01_overview.md`](01_overview.md) — repo-specific orientation: how this repository is organized and the authority chain between its documents.
- [`doc/02_layers.md`](02_layers.md) — how the four layers realize in this repo's actual code.
- [`doc/03_constraints.md`](03_constraints.md) — the Four Absolute Structural Prohibitions as actually enforced in this repo's examples, plus two additional constraints discovered in practice (keyword-name collisions, scoping negative cases).
- [`doc/04_runtime_model.md`](04_runtime_model.md) — how a request/response moves through the four layers at runtime.
- [`doc/05_patterns.md`](05_patterns.md) — consolidated implementation patterns used across examples.
- [`doc/06_exemples.md`](06_exemples.md) — the catalog of the public examples: what each one covers, its suite IDs, and how to run it.
- [`doc/07_governance.md`](07_governance.md) — contribution and AI-agent behavioral rules for this repo.

## External — target APIs used by the public examples

- **Swagger Petstore v2** — [`https://petstore.swagger.io/#/`](https://petstore.swagger.io/#/), spec at [`https://petstore.swagger.io/v2/swagger.json`](https://petstore.swagger.io/v2/swagger.json). Target of `petstore_api_v_2`.
- **Swagger Petstore OpenAPI 3.1 reference** — [`https://petstore31.swagger.io/#/`](https://petstore31.swagger.io/#/), spec at [`https://petstore31.swagger.io/api/v31/openapi.json`](https://petstore31.swagger.io/api/v31/openapi.json). Target of `petstore_api_v_3_1`.
- **ViaCEP** — [`https://viacep.com.br/`](https://viacep.com.br/). No published OpenAPI spec; the example's own README notes its schemas were derived from ViaCEP's documentation and confirmed live via `curl`. Target of both `viacep` examples (Robot Framework and Playwright).

## External — tooling

- [Robot Framework](https://robotframework.org/) — the keyword-driven test automation framework used by the Robot Framework examples.
- RequestsLibrary — the Robot Framework HTTP library used throughout the Robot examples' `POM` layer.
- [Playwright](https://playwright.dev/) — the browser/API automation framework used by the Playwright/TypeScript example.
