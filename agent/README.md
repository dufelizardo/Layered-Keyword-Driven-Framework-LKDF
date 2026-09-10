# Installing this kit in another project

This folder (`agent/`), together with `AGENTS.md` at the repo root, is a portable operational contract for AI coding agents following the LKDF (Layered Keyword-Driven Framework) methodology. This page is for a human setting it up in a *different* project — not for the agent doing implementation work once it's installed (that's `AGENTS.md`'s job).

## 1. What to copy

From this repository, copy exactly two things into the target project's root:

- `AGENTS.md`
- `agent/` (the whole directory, including `agent/templates/`)

Do **not** copy `README.md`, `WHITEPAPER.md`, or `doc/*.md` — those document this specific repository (its own history, example catalog, contribution rules), not the portable methodology. Everything the target project needs is already self-contained in the two items above.

If the target project already has an `AGENTS.md` with its own content, don't overwrite it — merge: keep the project's existing rules, and add a pointer to the copied `agent/ARCHITECTURE.md`/`agent/IMPLEMENTATION.md` for anything LKDF-specific.

## 2. Make each AI tool actually read it

No single file is read automatically by every AI coding tool today — each one has its own convention, and this landscape changes quickly enough that it's worth verifying against each tool's current docs rather than trusting the table below blindly (the same "verify, don't guess" rule `AGENTS.md` asks of implementation work applies here too).

| Tool | What it looks for |
| --- | --- |
| Claude Code | `CLAUDE.md` at project root |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Cursor | `.cursor/rules/*.mdc` (or `.cursorrules` in older versions) |
| Others (Codex and similar) | Increasingly `AGENTS.md` directly |

**Strategy: one source of truth, thin pointer files everywhere else.** Don't copy LKDF content into each tool's own file — that creates N copies that drift out of sync the moment one gets edited. Instead, make each tool-specific file a one-line pointer back to `AGENTS.md`:

```markdown
Before implementing anything in this project, read AGENTS.md at the project root and follow the read
order and rules it describes.
```

Drop that same line (adjusted to the tool's expected format) into `CLAUDE.md`, `.github/copilot-instructions.md`, and `.cursor/rules/agents.mdc` (Cursor's `.mdc` files typically support an `alwaysApply` frontmatter flag to guarantee the rule is always loaded — check Cursor's current docs for the exact syntax, since rule formats change between versions).

## 3. First real use

Once installed, the agent's own starting point is `AGENTS.md` §1 (Read order) — this file's job stops here.
