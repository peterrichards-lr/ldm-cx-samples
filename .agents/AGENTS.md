# Project Automation Rules (Routing Index)

This file is a routing index for skills that are **specific to this repo's EcoPulse/Veridian sample assets** — brand/theme conventions, site-initializer structure, Liferay Cloud (`LCP.json`) packaging, Meridian low-code orchestration, and this repo's own build/release mechanics. It layers on top of, and does not replace, the general Liferay-workspace rules in [`../.claude/CLAUDE.md`](../.claude/CLAUDE.md) / [`../.gemini/GEMINI.md`](../.gemini/GEMINI.md) — see "Relationship to the general Liferay rules" below.

This file serves as a routing index to prevent cognitive overload. Before executing complex tasks, review the relevant `SKILL.md` from the list below:

- **[Liferay Cloud Standards](./skills/liferay-cloud/SKILL.md)**
  _Activate this skill whenever modifying LCP.json files, configuring Docker deployments, or tuning memory for Liferay Cloud._

- **[EcoPulse Brand & Theme Development](./skills/ecopulse-brand/SKILL.md)**
  _Activate this skill whenever working on UI components, SASS styles, Clay CSS, or brand consistency._

- **[Site Initializer & Orchestration](./skills/site-initializer/SKILL.md)**
  _Activate this skill whenever modifying site initializers, adding documents, or configuring Liferay 7.4 site structures._

- **[Meridian Low-Code & Advanced Orchestration](./skills/meridian-orchestration/SKILL.md)**
  _Activate this skill whenever developing fragments, search blueprints, collections, or object relationships._

- **[Development Workflow](./skills/development-workflow/SKILL.md)**
  _Activate this skill whenever packaging extensions, running builds, or verifying pre-commit hooks._

- **[Release Management](./skills/release-management/SKILL.md)**
  _Activate this skill whenever a PR is merging to `main`, or you need to explain/adjust how `.ldmp` releases are cut._

## Relationship to the general Liferay rules (`.claude/CLAUDE.md` / `.gemini/GEMINI.md`)

These are two coexisting, non-overlapping systems, not competing ones — despite an earlier commit describing this file as a "migration" away from the general rules, it never was one, and the general rule files were never meant to be pruned:

- **General Liferay workspace rules** (`.claude/CLAUDE.md`, `.gemini/GEMINI.md`, and their mirrors in `.cursor/`, `.windsurf/`, `.github/`, sourced from `.workspace-rules/`) apply to _any_ Liferay workspace: environment/version detection, MCP server config, generic Client Extension / Fragment / Object guidance. **These win** for questions about Liferay platform fundamentals.
- **This file and its skills** apply to _this repo's_ sample assets specifically: EcoPulse/Veridian branding, this repo's site-initializer/LCP.json/Meridian conventions, and this repo's own build and release mechanics. **These win** for anything under `client-extensions/`, `fragments/`, or this repo's CI/release process.

Neither file needs to reference specific line numbers of the other, but if the two ever give contradictory guidance on the same concrete question, that's a bug — file it as `tech-debt`, don't silently pick one. (See [#12](https://github.com/peterrichards-lr/ldm-cx-samples/issues/12).)

## Active Documentation Maintenance Rule

After implementing any code change, the agent MUST review the project documentation to determine if updates are needed:

1. **Review and Update**: If a code change requires documentation updates, the agent must update the relevant document(s) AND update both the _Last Updated_ and _Last Reviewed_ timestamp footer at the bottom of the document. A single code change may require updates to multiple documents.
2. **Review Only**: If a document was reviewed in relation to a change but no content updates were necessary, the agent MUST still update the _Last Reviewed_ timestamp footer to reflect the review.
3. **New Documentation**: If no documentation exists around the implemented change, and it makes logical sense to document it, the agent MUST create a new document (with timestamp footers) unless the information can be appropriately added as a new section to an existing document.

<!-- markdownlint-disable MD049 -->

---

_Last Updated: 2026-08-06_ | _Last Reviewed: 2026-08-06_
