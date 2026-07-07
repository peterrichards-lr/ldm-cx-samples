# ⚡ Quick Start

To use the EcoPulse samples in your Liferay Docker Manager workspace, you can boot the environment directly using the `ldm` CLI:

```bash
ldm quickstart ecopulse-demo
```

Alternatively, if you already have an LDM workspace and want to sync these client extensions into it:

1. Copy the `client-extensions` directory from this repository into your workspace's `client-extensions/` directory.
2. Run `ldm rebuild --client-extensions`.
3. Wait for the deploy to complete.
