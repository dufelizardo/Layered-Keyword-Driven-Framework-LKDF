# LKDF Implementation — Step by Step for AI Agents

> **Portability note:** like `ARCHITECTURE.md`, this file is meant to work when copied into any project. It assumes you've already read `ARCHITECTURE.md`. Steps reference "the project's own conventions" rather than a specific repository's paths — if you're working inside a repository that also ships `doc/06_exemples.md` or similar, use that to find your nearest concrete example.

Do not start writing POM/FLOW/SCENARIO/TEST files before completing steps 0–3. The single biggest source of architectural drift in AI-assisted LKDF work is skipping straight to implementation before the shape of the change is decided.

## Step 0 — Locate or create the target example

Find the self-contained example directory this change belongs to (or create one, following the same top-level shape as any existing example: `src/{pom,flow,scenario}/`, `src/resource/{schema,data_driven}/`, a test directory). Examples never import from each other — if two examples need the same logic, duplicate it rather than reaching across.

If you're creating a new example from scratch, its scaffolding is part of the deliverable, not an afterthought — set these up alongside the first operation, not after:

- **A results/output directory owned by the example** (e.g. `results/`), so running its tests never writes report files into whatever directory the command happened to be invoked from. **Add the tool's report/log files, that results directory, and any build artifact directory (e.g. `node_modules/`) to the project's `.gitignore`** at the same time you create them — not as a follow-up fix. A report file (`log.html`, `output.xml`, `report.html`, a coverage folder, ...) landing in the project root instead of the example's own directory, and then getting committed, is a real, recurring mistake — catch it at creation time.
- **A self-locating run script** that resolves its own directory rather than assuming the caller's working directory, forwards extra arguments to the underlying test runner, and points the runner's output at the example's own results directory:

  ```bash
  #!/usr/bin/env bash
  # Runs this example's suite with all reports written to its own results/ folder,
  # instead of wherever the command happens to be invoked from.
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  robot --outputdir "$here/results" "$@" "$here/test"
  ```

  Provide the equivalent for any other shell your project's users need (e.g. a `.ps1` for Windows PowerShell), and adapt the runner invocation to whatever tool the example actually uses.
- **A `README.md`** for the example, following a consistent shape across every example in the project: a one-line description of what it targets (with docs/spec/host links if it's an API), a "Coverage" section (a table mapping each operation to its suite id and path), a "Structure" section (the directory tree), and a "Running" section (the exact commands, including a syntax-only/dry-run variant if the tool supports one).

## Step 0.5 — For a large story or spec, cut a representative first slice

Not every story is one operation. When you're handed something large — a full API spec with a dozen-plus operations, a multi-page UI flow — do not try to build all of it in one pass, and do not pick the first few operations arbitrarily either.

Instead:
1. Enumerate the distinct *request/interaction shapes* present in the whole thing — e.g. for an API: a plain GET, a GET with query/pagination params, a POST/PUT with a nested body, a batch/array operation, a file upload; for a UI flow: a simple form, a multi-step wizard, a table with pagination, a file upload.
2. Pick the smallest set of operations/screens that covers every distinct shape at least once — not the largest set, not an arbitrary prefix. The goal is proving the pattern generalizes across every shape the story actually contains, with the least redundant work.
3. Say out loud (to the user, in the implementation plan) which shapes you're covering and why, and that the rest is deferred — don't silently build a partial slice and imply it's complete.
4. Build the slice fully (Steps 1–7 for each operation in it) before returning to ask whether to continue with the rest.

This is a scoping heuristic, not a hard rule — if the user has already told you the exact scope, use that instead.

## Step 1 — Assign or reuse a suite ID

Suite IDs (`US-0NN` or whatever convention the project uses) are typically **global across the whole project**, not reset per example — check the highest ID already in use anywhere in the project and continue from there, don't restart at 1 for a new example.

Reuse an existing ID (don't increment) only when you are porting the *identical business requirement* to a second tool — e.g. the same "get resource by id" story implemented once in Robot Framework and once in Playwright keeps the same ID in both places, because it's the same requirement being re-proven in a second tool, not a new requirement.

## Step 2 — Verify before you assert

If the system under test is reachable, confirm real behavior (status codes, response shape, edge cases) with a direct call (`curl`, a REPL, whatever's fastest) *before* writing the FLOW assertion for it. Documentation — including an OpenAPI/Swagger spec — describes intent, not always actual behavior; treat any discrepancy you find as a real finding worth recording, not something to silently paper over.

If the system is genuinely unreachable from your environment (an internal/corporate-only host, for instance), you cannot skip this step by assuming the docs are correct — instead, explicitly mark every assertion in that example as spec-derived and unverified, both in a code comment near the relevant keyword and in the example's own README. Never let an unverified assertion read as if it were confirmed.

**When verification turns up a real discrepancy** between the spec/design and what the live system actually does, that is a finding, not a nuisance to route around. Record it in the example's own `KNOWN_ISSUES.md` (create one if it doesn't exist yet — see `agent/templates/KNOWN_ISSUES.md.template`): what the spec says, what you observed, the exact repro (the `curl` command or steps), and what your suite does about it (work around it in the request construction while still asserting the documented contract — never "fix" the assertion to match the buggy behavior). An example with no real findings simply doesn't get this file; don't create an empty one just to have it.

## Step 3 — Identify and scope scenarios

For the operation at hand, list every status/outcome the spec documents, then for each one ask: *is there an input that deterministically and unambiguously triggers this, that I can actually construct?*

- If yes — it's a real test case. Ground its input in the spec's own constraints (enum lists, min/max, required fields) rather than an arbitrary guess.
- If no — because two documented outcomes are indistinguishable without live access, or the only way to trigger it is a guess about undocumented behavior — skip it, and say why in a comment (see `ARCHITECTURE.md` §5, "scope negative cases to what's actually verifiable").
- Infrastructure/auth-layer outcomes (rate limiting, server errors, auth failures) generally aren't worth a dedicated test case unless there's a real, deliberate way to trigger them from a test.

Only after this step do you have your actual scenario list — this is what goes in the implementation plan from `AGENTS.md` §2 (if this project has one) before you write any code.

## Step 4 — Implement bottom-up: POM → FLOW → SCENARIO → TEST

Always in this order — each layer depends on the one below it existing first, and building top-down invites guessing at an interface that doesn't exist yet.

1. **POM.** One keyword/function per raw operation. It takes already-built inputs (body, params, headers) and returns the raw response. No assertions. If you're tempted to add a conditional here, that conditional belongs in FLOW.
2. **FLOW.** One keyword/function per scenario from Step 3, each: builds whatever the request needs (pulling negative-case values from the project's data-driven resource, not inline literals), calls the POM keyword, asserts the status/outcome, and — for success-shaped responses — validates the response against a schema. Then one dispatcher per operation that routes a `scenario` argument to the right per-scenario keyword.
3. **SCENARIO.** One keyword/function per operation. A single line that calls the FLOW dispatcher and returns its result. If you write more than that, something belongs in FLOW instead. Before naming it, check it doesn't collide with the POM keyword name under your tool's name-resolution rules (`ARCHITECTURE.md` §3).
4. **TEST.** One suite per operation, one case per scenario, calling the SCENARIO keyword with the scenario name plus whatever data the case needs. No logic.

## Step 5 — Seed data instead of hardcoding fragile ids

If a scenario needs a guaranteed-valid identifier (a "get by id" or "delete by id" case) and the system's data can change out from under you (a shared server, a reset environment), don't hardcode an id you observed once. Have the FLOW call the relevant create-operation's FLOW first to obtain a fresh, guaranteed-valid one.

## Step 6 — Self-check before calling it done

Walk back through what you wrote against `ARCHITECTURE.md` §1's table and §2's Four Prohibitions:
- Any assertion in POM? Move it to FLOW.
- Any direct HTTP/driver/DB call in FLOW? Move it to POM.
- Any HTTP call, or business logic, in SCENARIO? It shouldn't be there at all — move it to FLOW/POM and make SCENARIO a pass-through again.
- Any `if`/loop/assertion in TEST? Move it to FLOW.
- Does any SCENARIO keyword/function name collide with a POM one under your tool's resolution rules?
- Does every negative case trace back to a real, justified input (Step 3), or did one sneak in as a guess?

## Step 7 — Hand off

Follow the project's own commit/ownership conventions (see that project's `AGENTS.md` if one exists). As a safe default absent other instructions: don't commit on the user's behalf — stage changes if appropriate and hand them a plain-text commit message to run themselves.
