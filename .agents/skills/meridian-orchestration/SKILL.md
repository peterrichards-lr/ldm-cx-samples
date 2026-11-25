---
name: meridian-orchestration
description: Activate this skill whenever developing fragments, search blueprints, collections, or object relationships.
---

# Liferay Meridian (Low-Code) Standards

To ensure fragments and site content are modular and maintainable, all site initializers must follow the Meridian "Low-Code" patterns.

### Fragment Collection Structure

- **Standard Path**: Fragments MUST be placed in `site-initializer/fragments/group/[collection-erc]/[fragment-erc]/`.
- **Packaging**: Each fragment must contain `fragment.json` (metadata), `index.html` (structure), and `index.css` (style). `fragment.json` points at them with `htmlPath`/`cssPath`/`jsPath`, and at `configuration.json` with `configurationPath`: without it the configuration is ignored. Inline `html`/`css`/`js` keys and `externalReferenceCode` are not read (the key is the folder name).
- **FreeMarker**: use `${configuration.<name>}` (escape with `htmlUtil.escape`); `[configuration.<name>]` is literal text.
- **Clay Integration**: Prefer Clay CSS utility classes (e.g., `container-fluid`, `mb-5`, `btn-primary`) over custom CSS to ensure native look-and-feel.

### Site Orchestration & Wiring

- **Asset Referencing**: Use the DDM token syntax for all document references in Journal Articles: `src="[$DOCUMENT_URL:/site-initializer/documents/group/filename.png$]"`.
- **Style Book Alignment**: Every brand-specific site initializer must provide its own unique Style Book in `site-initializer/style-books/[brand-erc]-style-book/`.
- **ERC Consistency**: All fragments and collections must use the brand-specific prefix (e.g., `ecopulse-`, `veridian-`) for their `externalReferenceCode`.

### Synergy

- Brand theme CSS, favicon and spritemap are attached through each site's **master page**, not `site-initializer.json` (see the Site Initializer skill). `site-initializer.json` is descriptive metadata only.

# Advanced Orchestration & Discovery (Phase 2)

To move beyond static content, the demo environment uses Liferay's discovery and relationship features. Every path below is one Liferay reads on DXP 2026.q1; the Site Initializer skill explains how they were verified, and the E2E Boot Test checks each one.

### Objects and Relationships

- **Definitions**: `ecopulse-batch/batch/01-object-definition.batch-engine-data.json` (company-scoped `EnergySector`, `GreenInitiative`).
- **Relationships**: their own file, `02-object-relationship.batch-engine-data.json`, with `objectDefinitionExternalReferenceCode1` (the "one" side, also the `externalReferenceCode` parameter) and `objectDefinitionExternalReferenceCode2`. `targetEnergySector` puts the sector on each initiative.
- **Entries**: `ecopulse-site-initializer/site-initializer/object-entries/NN-<name>.json` (`objectDefinitionName` + `object-entries`), not the batch: at first boot a batch reaches its entries before Liferay has registered the new objects' permissions. Reference related entries by ERC: `r_targetEnergySector_c_energySectorERC`.
- Number batch files (`01-`, `02-`, …): they import in that order.

### Search Blueprints

- **Location**: `ecopulse-batch/batch/04-sxp-blueprint.batch-engine-data.json` (`com.liferay.search.experiences.rest.dto.v1_0.SXPBlueprint`). Site initializers cannot import blueprints on standard DXP.
- **Configuration**: `configuration.queryConfiguration.queryEntries[].clauses[].query` is Elasticsearch JSON. Object fields are nested: `nestedFieldArray.fieldName` / `nestedFieldArray.value_integer`.
- **Purpose**: targeted search results (e.g., boosting initiatives with `impactLevel` ≥ 75) without changing the index.

### Asset Lists (Collections)

- **Location**: `site-initializer/asset-list-entries.json`, an array of `{ title, externalReferenceCode, assetTagNames, unicodeProperties }`; the list key is the title, lower-cased and hyphenated.
- **Filtering**: dynamic lists filter by asset type, tags and categories, not by field values. "High impact" initiatives are tagged `high-impact` (`keywords` on the entry). Use `[$OBJECT_DEFINITION_CLASS_NAME:<Object>$]` for an object's type.
- **Scope**: company-scoped object entries live in the Global site, which an initializer cannot add to a list's scope, so the lists start empty until an editor adds Global to their scope.
- **Fragments**: a `collectionSelector` configuration provides `collectionObjectList` (see `impact-slider`). Its default in `configuration.json` can name an asset list by ERC, but `configuration.json` gets no placeholders. To use an object's own collection provider (which covers company-scoped entries), set it on the fragment instance in `page-definition.json`: `fragmentConfig.collection` = `{ "key": "[$OBJECT_DEFINITION_CLASS_NAME:<Object>$]", "itemType": <same>, "title": "...", "type": "com.liferay.info.list.provider.item.selector.criterion.InfoListProviderItemSelectorReturnType" }`. A collection selector passes no filters to a provider, so filter in the template (the slider's `minimumImpactLevel`).

### Display Page Templates

- **Location**: `site-initializer/layout-page-templates/display-page-templates/<key>/display-page-template.json` (`contentType.className`: `[$OBJECT_DEFINITION_CLASS_NAME:<Object>$]`) + `page-definition.json`.
- **Dynamic Wiring**: map object fields onto fragment **editables**: `{ "id": "<editable id>", "value": { "text": { "mapping": { "fieldKey": "ObjectField_<field>", "itemReference": { "contextSource": "DisplayPageItem" } } } } }`. `${configuration.*}` values cannot be mapped.

<!-- markdownlint-disable MD049 -->

---

_Last Updated: 2026-11-25_ | _Last Reviewed: 2026-11-25_
