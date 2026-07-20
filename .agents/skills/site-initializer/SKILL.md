---
name: site-initializer
description: Activate this skill whenever modifying site initializers, adding documents, or configuring Liferay 7.4 site structures.
---
# Site Orchestration

The `ecopulse-site-initializer` is the source-of-truth for the demo's initial state.

- **Documents**: High-res assets must be placed in `site-initializer/documents/group/`.
- **Wiring**: The `site-initializer.json` must explicitly link to the `ecopulse-theme`, `ecopulse-favicon`, and `ecopulse-spritemap` ERCs.

# Site Initializer (Liferay 7.4) Standards

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

<!-- markdownlint-disable MD049 -->
---
*Last Updated: 2026-07-20* | *Last Reviewed: 2026-07-20*
