# ⚡ Quick Start

## Run the EcoPulse samples with LDM

You don't need to clone this repository to try the samples. [Liferay Docker Manager (LDM)](https://github.com/peterrichards-lr/liferay-docker-manager) downloads the latest `ldm-cx-samples.ldmp` release and deploys its client extensions for you:

```bash
ldm run ecopulse-demo --samples --host-name ecopulse.local
```

- `--samples` seeds the new project with the client extensions from this repository's latest release.
- `--samples` requires a virtual hostname other than `localhost`. If you omit `--host-name`, LDM prompts for one (or fails when run non-interactively).

When the stack is up, open the hostname you chose in a browser.

## Work on the samples locally

To change the client extensions and try your changes in LDM:

1. Clone this repository and build it with `blade gw build`.
2. Link the workspace to an LDM project:

    ```bash
    ldm link /path/to/ldm-cx-samples ecopulse-dev --host-name ecopulse.local
    ```

3. After each change, rebuild and redeploy:

    ```bash
    blade gw build
    ldm deploy ecopulse-dev
    ```

Run `ldm <command> --help` to see every option.

<!-- markdownlint-disable MD049 -->
---
*Last Updated: 2026-11-23* | *Last Reviewed: 2026-11-23*
