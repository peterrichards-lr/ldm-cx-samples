---
name: development-workflow
description: Activate this skill whenever packaging extensions, running builds, or verifying pre-commit hooks.
---
# Development Workflow

- **Linting**: Prettier is enforced via Husky pre-commit hooks.
- **Packaging**: Use `./gradlew clean build` to generate the LDM-ready ZIPs in `dist/` folders.
- **Verification**: Always check the generated `build/liferay-client-extension-build/LCP.json` to ensure source overrides were applied correctly.

<!-- markdownlint-disable MD049 -->
---
*Last Updated: 2026-07-20* | *Last Reviewed: 2026-07-20*
