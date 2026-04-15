# EcoPulse Workspace: Engineering Standards & Learnings

This file tracks the foundational patterns and "Learnings" discovered during the development of the EcoPulse Smart City demo.

## 1. Liferay Cloud (LCP.json) Standards

To ensure compatibility with the **Liferay Docker Manager (LDM)** and real Liferay Cloud environments, all `LCP.json` files must be **explicit**.

### Kind & Scaling

- **Jobs**: Use for `batch` and `siteInitializer`. Set `kind: "Job"`.
- **Deployments**: Use for all other extensions. Set `kind: "Deployment"`.
- **Scaling**: For sample assets, always default to `scale: 1`.

### Port Mapping

- **Frontend (Caddy)**: `targetPort: 80`.
- Backend (Node.js): `targetPort: 3001-3004`.
  _Note: Ensure the Dockerfile EXPOSE matches the LCP targetPort._

### Memory Management

- **Target**: 50MB (Hard-gate).
- **Learning**: Liferay Gradle plugins default Jobs to 300MB. We must explicitly override this in the root of the extension folder to keep the demo environment lean.

## 2. EcoPulse Brand Consistency

All assets and UI components must align with the **Veridian Shift** visual identity.

### Palette

- **Emerald Green (`#00C853`)**: Vitality, Energy, Success.
- **Tech Navy (`#1A237E`)**: Trust, Infrastructure, Reliability.
- **Innovation Blue (`#00B0FF`)**: Data, Real-time Metrics, Future.

### Metadata (ERC)

- Always use the `ecopulse-` prefix for folder names and `externalReferenceCode`.
- Names should be professional and descriptive (e.g., `EcoPulse Energy Grid Monitor`).

## 3. Site Orchestration

The `ecopulse-site-initializer` is the source-of-truth for the demo's initial state.

- **Documents**: High-res assets must be placed in `site-initializer/documents/group/`.
- **Wiring**: The `site-initializer.json` must explicitly link to the `ecopulse-theme`, `ecopulse-favicon`, and `ecopulse-spritemap` ERCs.

## 4. Development Workflow

- **Linting**: Prettier is enforced via Husky pre-commit hooks.
- **Packaging**: Use `./gradlew clean build` to generate the LDM-ready ZIPs in `dist/` folders.
- **Verification**: Always check the generated `build/liferay-client-extension-build/LCP.json` to ensure source overrides were applied correctly.

## 6. Site Initializer (Liferay 7.4) Standards

To ensure reliable site initialization and avoid common deployment failures:

### Directory Structure (Strict)

- **Documents**: Must be in `site-initializer/documents/group/`.
- **Fragments**: Must be in `site-initializer/fragments/group/[collection-erc]/[fragment-erc]/`.
- **Journal Articles**: Must be in `site-initializer/journal-articles/`. Each article consists of a `[name].json` (metadata) and `[name].xml` (content).
- **Layouts**: Must be in `site-initializer/layouts/[order]_[name]/`. Use `page.json` for content pages.

### Metadata & IDs

- **ERC & Article ID**: Always provide both `externalReferenceCode` and `articleId` in journal articles to prevent `DuplicateArticleIdException`.
- **Versioning**: If a site initialization fails or hangs, increment the site's `externalReferenceCode` (e.g., `ecopulse-site-v9`) and the extension's `id` in `LCP.json` to force a clean start.
- **Page Metadata**: Use `page.json` instead of `page-definition.json` for content pages, and always include `name_i18n` for localization.

### Content Formatting

- **Journal Content**: Must be wrapped in Liferay DDM XML format inside the `.xml` file (e.g., `<root><dynamic-element name="content" type="text_area"><dynamic-content language-id="en_US"><![CDATA[...]]></dynamic-content></dynamic-element></root>`).
- **Asset References**: Use the ERC token syntax: `src="[$DL_FILE_ENTRY_EXTERNAL_REFERENCE_CODE:filename.png$]"`.

## 7. Theme Development (Clay & SASS)

- **Branding Enforcement**: When overriding Clay variables in `_clay_variables.scss`, remove the `!default` flag to ensure they explicitly override Liferay defaults.
- **Source Files**: Always provide `clay.scss` and `main.scss` in `src/css/` to let the Liferay Gradle plugin handle assembly. Do not use manual `assemble` blocks in `client-extension.yaml` for CSS files.
- **Explicit Styles**: Add explicit CSS overrides in `main.scss` for common elements like `.btn-primary` and `.btn-secondary` to guarantee branding consistency across all fragments.

## 8. OSGi & LCP Dependency Management

- **Require-Bundle Conflicts**: Do not list other client extensions in the `dependencies` array of `LCP.json` for Site Initializers or Themes. This can trigger incorrect `Require-Bundle` headers in the generated OSGi manifest, leading to unresolved requirement errors.
- **Manual Deployment**: If `blade gw deploy` fails to update a client extension, manually copy the generated ZIP from `dist/` to `bundles/osgi/client-extensions/` and check the logs for "STOPPED" and "STARTED" confirmation.
