# EcoPulse / Veridian Samples — AI Agent Context

> This is the **single source of truth** for any AI coding agent working on this repository. Provider-specific files (`CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`, `.cursor/rules/agents.mdc`, `.windsurf/rules/agents.md`) only redirect here. **Do not duplicate context in those files.** Put new always-on rules in this file, and task-specific guidance in a skill under `.agents/skills/`.

## Project identity

- **What**: the EcoPulse "Smart City" and City of Veridian sample assets (client extensions, fragments, site initializers) bundled with [Liferay Docker Manager (LDM)](https://github.com/peterrichards-lr/liferay-docker-manager).
- **Consumers**: LDM downloads this repo's `releases/latest/download/ldm-cx-samples.ldmp` for `ldm run --samples`, so every release reaches LDM users. See the Release Management skill before tagging.
- **Stack**: Liferay Workspace (`gradle.properties` → `liferay.workspace.product`), built with `blade gw build`.

## Liferay workspace fundamentals (always apply)

Before answering technical questions, you MUST establish the environment context

- Scan for `gradle.properties` in the root directory
- Identify the value of `liferay.workspace.product`

Based on the version identified above, apply the following logic

- If Version < 7.4: Focus on traditional OSGi module development
- If Version >= 7.4 or a Quarterly Release (Q): Steer users towards modern Liferay best practices like Client Extensions, Fragments, and Objects
    - Only suggest traditional OSGi modules if Client Extensions cannot fulfill the requirements
    - Validate any code for Client Extensions before providing it to the user
    - Reference the documentation in `liferay-learn` to understand the different types of Client Extensions available and their purposes
- Ensure all suggested Gradle dependencies align with the `target.platform.version` defined in the project workspace

The authoritative source for Liferay documentation is the [liferay-learn](https://github.com/liferay/liferay-learn) repository. Use these key paths to retrieve documentation for all aspects of development within this workspace.

Examples:

| Topic                            | Path in liferay-learn                                                                                                  |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Client Extensions Overview       | `docs/dxp/latest/en/liferay-development/client-extensions.md`                                                          |
| Custom Element Client Extensions | `docs/dxp/latest/en/liferay-development/customizing-liferays-look-and-feel/using-a-custom-element-client-extension.md` |
| Objects                          | `docs/dxp/latest/en/liferay-development/objects.md`                                                                    |
| Fragments                        | `docs/dxp/latest/en/site-building/developer-guide/developing-page-fragments.md`                                        |

When you need documentation not listed above, use `web_search` to query GitHub for specific liferay-learn content (e.g., `site:github.com/liferay/liferay-learn [topic]`).

- Use [liferay-portal](https://github.com/liferay/liferay-portal) to understand architectural patterns and see latest source code, note that the code might be slightly ahead of the release version used in this workspace.
- **Client Extension Samples:** Reference working examples at `https://github.com/liferay/liferay-portal/tree/master/workspaces/liferay-sample-workspace/client-extensions`
    - Use these samples as templates when generating new client extensions
    - Check sample `client-extension.yaml` files for valid property configurations

- **Logs:** `bundles/tomcat/logs/`
- **Configs/Properties:** `configs/common/` (source) or `configs/[env]/` (environment-specific)
    - Steer fresh user to use `local` environment
- **Licenses:** `configs/[env]/deploy/` (environment-specific)
- **OSGi Configs:**
    - **Source:** `configs/[env]/osgi/configs/` (e.g., `configs/local/osgi/configs/`)
    - **Runtime:** `bundles/osgi/configs/` (deployed configurations)
- **Modules:** `modules/`
- **Client Extensions:** `client-extensions/`

- **Blade:** Steer users towards `blade` as the cli tool when possible. Use `blade gw` for Gradle tasks (view available options with `blade gw tasks`). Custom code can be deployed to the running server with `blade gw deploy`. Avoid direct usage of `gradlew`.

Liferay DXP has an MCP server, available on 2025.Q4 and later. Use this as the default tool for querying content, managing objects, and executing actions within the portal. Older DXP versions have OpenAPI endpoints.

The MCP server is behind a feature flag. Add the following to `configs/local/portal-ext.properties` before starting the server:

```properties
feature.flag.LPD-63311=true
```

| Setting              | Value                                |
| -------------------- | ------------------------------------ |
| URL                  | `http://localhost:8080/o/mcp/sse`    |
| Transport            | HTTP Server Sent Events (SSE)        |
| Authorization Header | `Basic dGVzdEBsaWZlcmF5LmNvbTp0ZXN0` |

The default credentials (`test@liferay.com:test`) are base64-encoded in the header. Update if using different credentials.

Once connected, the AI can use Liferay-provided tools to:

- Query and manage Liferay Objects
- Retrieve site and page information
- Interact with the content management system
- Execute headless API operations

## Skills

Read the relevant `SKILL.md` before starting work. **Workspace** skills cover any Liferay workspace; **Repo** skills cover this repo's own assets, build and release.

| Scope     | Skill                                                                                 | Use when                                                                                 |
| --------- | ------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Workspace | [Workspace Setup](./.agents/skills/workspace-setup/SKILL.md)                          | A user is new to Liferay Workspace or needs to init/start the local server               |
| Workspace | [Guided Client Extension](./.agents/skills/guided-client-extension/SKILL.md)          | A guided walkthrough of creating a client extension (batch Object + custom-element form) |
| Repo      | [Liferay Cloud Standards](./.agents/skills/liferay-cloud/SKILL.md)                    | Modifying `LCP.json`, Docker deployments, or Liferay Cloud memory tuning                 |
| Repo      | [EcoPulse Brand & Theme](./.agents/skills/ecopulse-brand/SKILL.md)                    | UI components, SASS, Clay CSS, brand consistency                                         |
| Repo      | [Site Initializer & Orchestration](./.agents/skills/site-initializer/SKILL.md)        | Site initializers, documents, site structures                                            |
| Repo      | [Meridian Low-Code & Orchestration](./.agents/skills/meridian-orchestration/SKILL.md) | Fragments, search blueprints, collections, object relationships                          |
| Repo      | [Development Workflow](./.agents/skills/development-workflow/SKILL.md)                | Packaging extensions, running builds, pre-commit hooks                                   |
| Repo      | [Release Management](./.agents/skills/release-management/SKILL.md)                    | Cutting a release (`v*` tag), merging to `main`, how the `.ldmp` is built                |

`.claude/skills` is a symlink to `.agents/skills`, so Claude Code discovers these skills natively.

## Precedence

The workspace fundamentals above win on Liferay platform questions. The Repo skills win for anything under `client-extensions/` or `fragments/`, and for this repo's CI and release process. If the two ever give contradictory guidance on the same concrete question, that's a bug: file it as `tech-debt` rather than silently picking one.

## Active Documentation Maintenance Rule

After implementing any code change, the agent MUST review the project documentation to determine if updates are needed:

1. **Review and Update**: If a code change requires documentation updates, the agent must update the relevant document(s) AND update both the _Last Updated_ and _Last Reviewed_ timestamp footer at the bottom of the document. A single code change may require updates to multiple documents.
2. **Review Only**: If a document was reviewed in relation to a change but no content updates were necessary, the agent MUST still update the _Last Reviewed_ timestamp footer to reflect the review.
3. **New Documentation**: If no documentation exists around the implemented change, and it makes logical sense to document it, the agent MUST create a new document (with timestamp footers) unless the information can be appropriately added as a new section to an existing document.

<!-- markdownlint-disable MD049 -->

---

_Last Updated: 2026-11-23_ | _Last Reviewed: 2026-11-23_
