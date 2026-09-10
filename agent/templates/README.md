# LKDF Templates

Fill-in-the-blank starting points, not prose. `agent/ARCHITECTURE.md` and `agent/IMPLEMENTATION.md` tell you the rules and the steps; these files are what you actually copy, rename, and edit. Every placeholder is written `<<LIKE_THIS>>` — replace every one before you consider a file done, and delete any pattern variant inside a template that doesn't apply to your operation.

> **Portability note:** same as the rest of `agent/` — copy this whole directory into any project and it stands on its own.

## Which template for which situation

| You're building... | Use |
| --- | --- |
| The shared session/auth resource for an API | `common/api_session.resource.template` |
| The shared browser-session resource for a UI flow | `common/ui_session.resource.template` |
| The generic schema-validation FLOW helper | `common/schema_validation.flow.resource.template` |
| An API operation's POM (pick the one matching pattern inside) | `api/pom.resource.template` |
| An API operation's FLOW | `api/flow.resource.template` |
| An API operation's SCENARIO | `api/scenario.resource.template` |
| An API operation's TEST suite | `api/test_suite.robot.template` |
| A UI story's POM (page object) | `ui/pom.resource.template` |
| A UI story's FLOW | `ui/flow.resource.template` |
| A UI story's SCENARIO | `ui/scenario.resource.template` |
| A UI story's TEST suite | `ui/test_suite.robot.template` |
| The data-driven negative-case value resource for an operation | `data_driven/data_driven.resource.template` |
| Recording a real discrepancy found during live verification (`agent/IMPLEMENTATION.md` Step 2) | `KNOWN_ISSUES.md.template` |

## Non-negotiable when filling one of these in

- Keep the physical layout from `agent/ARCHITECTURE.md` §1.1: `src/<layer>/<resource-group>/<operation>/<operation>_<layer>.resource`, mirrored across all four layers.
- Keep the `# ══...` separator convention (§1.1 "Formatting") exactly as it appears in the template — don't strip it out because it looks decorative; it's there for consistency with every other file in the project.
- Keep the `CT-00N - US-0NN: Validate <Operation> - <scenario>` test case naming and the suite's `Metadata` block (§1.1 "TEST") — this is what makes a test traceable back to its requirement, not optional flavor.
- Give the SCENARIO keyword a name that cannot collide with the POM keyword it eventually reaches under your tool's name-resolution rules (`agent/ARCHITECTURE.md` §3) — the templates already do this correctly; if you rename either keyword, re-check the pair.
- Delete every pattern variant and comment block you didn't use — a finished file should contain only what the operation actually needs, no leftover template scaffolding.
