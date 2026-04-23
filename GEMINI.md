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
- **LDM Validation**: All Deployments with a `loadBalancer` must include an explicit `ports` array with `external: true` matching the `targetPort`.
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
- **Fragments**: Must be in `site-initializer/fragment-collections/[collection-erc]/[fragment-erc]/`.
- **Journal Articles**: Must be in `site-initializer/journal-articles/`. Each article consists of a `[name].json` (metadata) and `[name].xml` (content).
- **Layouts**: Must be in `site-initializer/layouts/[order]_[name]/`. Use `page.json` for content pages.
- **Navigation Menus**: Must be in `site-initializer/navigation-menus/group/`.
- **Taxonomy Vocabularies**: Must be in `site-initializer/taxonomy-vocabularies/group/`. Categories should be in a subfolder matching the vocabulary's filename.
- **Style Books**: Each entity-specific site initializer must provide its own unique Style Book folder in `site-initializer/style-books/[brand-erc]-style-book/`.

### Metadata & IDs

- **ERC & Article ID**: Always provide both `externalReferenceCode` and `articleId` in journal articles to prevent `DuplicateArticleIdException`.
- **Versioning**: If a site initialization fails or hangs, increment the site's `externalReferenceCode` (e.g., `ecopulse-site-v9`) and the extension's `id` in `LCP.json` to force a clean start.
- **Page Metadata**: Use `page.json` instead of `page-definition.json` for content pages, and always include `name_i18n` for localization.

### Content Formatting

- **Journal Content**: Must be wrapped in Liferay DDM XML format inside the `.xml` file (e.g., `<root><dynamic-element name="content" type="text_area"><dynamic-content language-id="en_US"><![CDATA[...]]></dynamic-content></dynamic-element></root>`).
- **Asset References**: Use the ERC token syntax: `src="[$DL_FILE_ENTRY_EXTERNAL_REFERENCE_CODE:filename.png$]"`.

## 7. Theme & Brand Development (Clay & SASS)

### Brand Separation Architecture

- **Shared Core**: All shared SASS logic, component styles, and Clay variables reside in `client-extensions/common-theme-assets/src/css/`.
- **Syncing**: Because the Liferay CSS builder requires all imported SASS files to be in the local `src/css` directory, any changes to the shared core must be copied to both `ecopulse-brand/src/css/` and `veridian-brand/src/css/` before building.
- **Entity Themes**: `ecopulse-brand` and `veridian-brand` are **themeCSS** extensions that provide the specific branding variables and core components for their respective entities.

### Branding Enforcement

- **Variables**: Use semantic mappings (`$brand-primary`, `$brand-secondary`) in `_core.scss` to ensure component styles automatically adapt to the active brand.
- **Explicit Styles**: Component-specific overrides (e.g., `.ecopulse-card`, `.btn-brand`) should be defined in the shared core but use CSS variables for color values.

## 9. Liferay Meridian (Low-Code) Standards

To ensure fragments and site content are modular and maintainable, all site initializers must follow the Meridian "Low-Code" patterns.

### Fragment Collection Structure

- **Standard Path**: Fragments MUST be placed in `site-initializer/fragments/group/[collection-erc]/[fragment-erc]/`.
- **Packaging**: Each fragment must contain `fragment.json` (metadata), `index.html` (structure), and `index.css` (style).
- **Clay Integration**: Prefer Clay CSS utility classes (e.g., `container-fluid`, `mb-5`, `btn-primary`) over custom CSS to ensure native look-and-feel.

### Site Orchestration & Wiring

- **Asset Referencing**: Use the DDM token syntax for all document references in Journal Articles: `src="[$DL_FILE_ENTRY_EXTERNAL_REFERENCE_CODE:filename.png$]"`.
- **Style Book Alignment**: Every brand-specific site initializer must provide its own unique Style Book in `site-initializer/style-books/[brand-erc]-style-book/`.
- **ERC Consistency**: All fragments and collections must use the brand-specific prefix (e.g., `ecopulse-`, `veridian-`) for their `externalReferenceCode`.

### Synergy

- Site initializers should explicitly link to the corresponding `themeCSS` and `themeFavicon` extensions in `site-initializer.json` using their ERCs.

## 10. Advanced Orchestration & Discovery (Phase 2)

To move beyond static content, the demo environment utilizes Liferay's advanced discovery and relationship features.

### Search Blueprints

- **Discovery Experiences**: Store Search Blueprints in `site-initializer/search/blueprints/[blueprint-name].json`.
- **Purpose**: Use these to create targeted search results (e.g., boosting high-impact initiatives) without modifying the global search index.

### Object Relationships

- **Inter-connected Data**: Define relationships between Liferay Objects in `ecopulse-batch/batch/object-definition.batch-engine-data.json`.
- **Naming**: Use descriptive relationship names (e.g., `sectorInitiatives`) and ensure both sides of the relationship are clearly defined in the JSON.

### Display Page Templates

- **Automated Pages**: Use `site-initializer/display-page-templates/` to define layouts for Liferay Objects.
- **Dynamic Wiring**: Templates must map Object fields to fragment slots (e.g., mapping `Energy Sector: name` to a heading fragment).
