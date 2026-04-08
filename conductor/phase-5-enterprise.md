# Implementation Plan: Phase 5 - Enterprise Verification & Workflow [COMPLETED]

This plan outlines the final enterprise-grade features for the EcoPulse demo, including workflow orchestration and localization.

## Objective

Prove that EcoPulse can handle complex business processes and global requirements using Liferay's core engine services.

## Key Files & Context

- **Workflow**: `client-extensions/ecopulse-batch/batch/workflow-definition.batch-engine-data.json`
- **Objects**: `GreenInitiative` and `EnergySector`
- **Localization**: `site-initializer/documents/group/veridian-manifesto_*.txt`

## Implementation Steps

### 1. Machine Approver Workflow

1. Define a "Machine Approver" workflow in the batch engine format.
2. Use a `workflowAction` client extension (`ecopulse-workflow-action`) to simulate automated validation.
3. Bind the workflow to the `GreenInitiative` Object via the batch import.

### 2. Global Identity (Localization)

1. Localize the **Veridian Manifesto** into German, Spanish, and French.
2. Update the `ObjectDefinition` batch files to include localized labels for all fields and plurals.

### 3. Site Initializer Refinement

1. Ensure the `ecopulse-site-initializer` correctly wires the theme, fragments, and localized assets into a single "Veridian EcoPulse" site.
2. Configure the initializer to target the `L_GUEST` site for a seamless "out-of-the-box" experience.

## Verification & Testing

1. **Workflow Test**: Submit a `GreenInitiative` and verify it triggers the automated "Machine Review" step.
2. **Language Test**: Switch the Liferay portal language and verify the manifesto and object fields translate correctly.
3. **Build Validation**: Run a full `./gradlew build` to ensure the final v1.0.0 snapshot is consistent.
