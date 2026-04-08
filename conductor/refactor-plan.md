# Implementation Plan: EcoPulse Refactor & Workspace Branding

This plan outlines the refactoring of the `ldm-cx-samples` workspace into the **EcoPulse Smart City Demo**. This workspace serves as the source-of-truth for sample assets used by the **Liferay Docker Manager (LDM)**.

## Objective

Align all client extensions, fragments, and documentation with the "Veridian Shift" EcoPulse theme.

## Key Files & Context

- **LDM Repo**: [liferay-docker-manager](https://github.com/peterrichards-lr/liferay-docker-manager)
- **EcoPulse Branding**: Emerald Green (`#00C853`), Tech Navy (`#1A237E`), Innovation Blue (`#00B0FF`).

## Implementation Steps

### 1. Rename Client Extension Folders

Rename the following directories in `client-extensions/`:

- `01-liferay-sample-batch` -> `ecopulse-batch`
- `02-liferay-sample-etc-node` -> `ecopulse-microservice`
- `03-liferay-sample-theme-css-4` -> `ecopulse-theme`
- `04-liferay-sample-theme-spritemap-2` -> `ecopulse-spritemap`
- `05-liferay-sample-theme-favicon` -> `ecopulse-favicon`
- `06-liferay-sample-custom-element-6` -> `ecopulse-grid-map`
- `07-liferay-sample-etc-node` -> `ecopulse-headless-auth`
- `08-liferay-sample-site-initializer` -> `ecopulse-site-initializer`
- `09-liferay-sample-object-action` -> `ecopulse-object-action`
- `10-liferay-sample-workflow-action` -> `ecopulse-workflow-action`

### 2. Update Client Extension Metadata

For each renamed folder, update `client-extension.yaml`:

- Update `name` to use "EcoPulse" prefix (e.g., `EcoPulse Theme`).
- Update `externalReferenceCode` to match the new folder name.
- Update any internal references (e.g., in `01` batch files or `02` node configs) to the new ERCs.

### 3. EcoPulse Object Definition (`GreenInitiative`)

In `ecopulse-batch/batch/object-definition.batch-engine-data.json`:

- Rename `Sample` object to `GreenInitiative`.
- Add fields: `Title` (Text), `Description` (Text), `ImpactLevel` (Integer), `Category` (Select).

### 4. Branding & Icons

- Update `ecopulse-theme` variables to Veridian palette.
- Replace `ecopulse-spritemap` SVGs with `leaf`, `bolt`, `map-marker`.
- Update `ecopulse-favicon` with Veridian logo assets from `assets/`.

### 5. Update Workspace Documentation

- Rewrite `README.md` to focus on EcoPulse and its link to LDM.
- Update `conductor/index.md`.

## Verification & Testing

1. **Build**: Run `./gradlew clean build`.
2. **Deploy**: Verify all 8 extensions deploy as `ecopulse-*`.
3. **Objects**: Verify `GreenInitiative` object is created via Batch.
4. **README**: Ensure all links to LDM are correct.
