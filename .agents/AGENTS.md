# Project Automation Rules (Routing Index)

All development, issue backlog prioritization, release workflows, and deployments MUST strictly follow the modular skills defined in this project.

This file serves as a routing index to prevent cognitive overload. Before executing complex tasks, review the relevant `SKILL.md` from the list below:

- **[Liferay Cloud Standards](./skills/liferay-cloud/SKILL.md)**
  *Activate this skill whenever modifying LCP.json files, configuring Docker deployments, or tuning memory for Liferay Cloud.*

- **[EcoPulse Brand & Theme Development](./skills/ecopulse-brand/SKILL.md)**
  *Activate this skill whenever working on UI components, SASS styles, Clay CSS, or brand consistency.*

- **[Site Initializer & Orchestration](./skills/site-initializer/SKILL.md)**
  *Activate this skill whenever modifying site initializers, adding documents, or configuring Liferay 7.4 site structures.*

- **[Meridian Low-Code & Advanced Orchestration](./skills/meridian-orchestration/SKILL.md)**
  *Activate this skill whenever developing fragments, search blueprints, collections, or object relationships.*

- **[Development Workflow](./skills/development-workflow/SKILL.md)**
  *Activate this skill whenever packaging extensions, running builds, or verifying pre-commit hooks.*

## Active Documentation Maintenance Rule

After implementing any code change, the agent MUST review the project documentation to determine if updates are needed:
1. **Review and Update**: If a code change requires documentation updates, the agent must update the relevant document(s) AND update both the *Last Updated* and *Last Reviewed* timestamp footer at the bottom of the document. A single code change may require updates to multiple documents.
2. **Review Only**: If a document was reviewed in relation to a change but no content updates were necessary, the agent MUST still update the *Last Reviewed* timestamp footer to reflect the review.
3. **New Documentation**: If no documentation exists around the implemented change, and it makes logical sense to document it, the agent MUST create a new document (with timestamp footers) unless the information can be appropriately added as a new section to an existing document.

<!-- markdownlint-disable MD049 -->
---
*Last Updated: 2026-07-20* | *Last Reviewed: 2026-07-20*
