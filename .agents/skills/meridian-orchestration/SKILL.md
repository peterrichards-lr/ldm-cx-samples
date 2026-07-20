---
name: meridian-orchestration
description: Activate this skill whenever developing fragments, search blueprints, collections, or object relationships.
---
# Liferay Meridian (Low-Code) Standards

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

# Advanced Orchestration & Discovery (Phase 2)

To move beyond static content, the demo environment utilizes Liferay's advanced discovery and relationship features.

### Search Blueprints

- **Discovery Experiences**: Store Search Blueprints in `site-initializer/search/blueprints/[blueprint-name].json`.
- **Purpose**: Use these to create targeted search results (e.g., boosting high-impact initiatives) without modifying the global search index.

### Asset List Entries (Collections)

- **Dynamic Data Sets**: Store Collections in `site-initializer/asset-list-entries/[erc].json`.
- **Filtering**: Use dynamic queries to filter Objects (e.g., filtering `GreenInitiative` by `impactLevel > 5`).
- **Synergy**: Link these collections to fragments (like sliders or grids) within layout definitions.

### Object Relationships

- **Inter-connected Data**: Define relationships between Liferay Objects in `ecopulse-batch/batch/object-definition.batch-engine-data.json`.
- **Naming**: Use descriptive relationship names (e.g., `sectorInitiatives`) and ensure both sides of the relationship are clearly defined in the JSON.

### Display Page Templates

- **Automated Pages**: Use `site-initializer/display-page-templates/` to define layouts for Liferay Objects.
- **Dynamic Wiring**: Templates must map Object fields to fragment slots (e.g., mapping `Energy Sector: name` to a heading fragment).

<!-- markdownlint-disable MD049 -->
---
*Last Updated: 2026-07-20* | *Last Reviewed: 2026-07-20*
