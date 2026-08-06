# Template Reference

This repo's AI-agent governance files (`.agents/AGENTS.md`, `.gemini/gemini.md`, `.claude/`) were established independently and have no automated relationship to any other repo. `ai-agent-template` (https://github.com/peterrichards-lr/ai-agent-template) is maintained as the shared "lessons learned" reference for AI-agent rules across the Liferay tooling repos, but nothing here pulls updates from it automatically. This file is a manual checkpoint so drift gets tracked deliberately instead of silently.

**Reference repo**: <https://github.com/peterrichards-lr/ai-agent-template>
**Reference version at last check**: `v1.2.0` (origin/main @ `83b1cf2`, 2026-08-01)
**Last checked**: 2026-08-05

## Known drift as of this check

- [#11](https://github.com/peterrichards-lr/ldm-cx-samples/issues/11) — a bulk commit stamped fresh "Last Reviewed" footers onto ~19 unrelated files bundled with an unrelated fix, plus accidentally committed debug artifacts. `ai-agent-template` fixed the underlying cause of this class of bug in its PR #16 (append-only timestamp injection instead of rewrite-on-touch).
- [#12](https://github.com/peterrichards-lr/ldm-cx-samples/issues/12) — `.agents/AGENTS.md` (modular) and `.gemini/gemini.md` + `.claude/CLAUDE.md` (monolithic, never pruned) are two non-reconciled instruction systems despite a commit claiming to "migrate" from one to the other.

## Skills available in the reference repo (for comparison; not all apply here)

`coding-standards`, `documentation`, `github-workflow`, `human-in-the-loop`, `multi-agent-orchestration`, `reflection-and-planning`, `release-management`, `rule-adherence`, `tool-use-react`, `unit-testing`

## How to use this file

Before writing a new agent rule here, check whether `ai-agent-template` already documents a corrected/newer version of the same rule (its `documentation` and `rule-adherence` skills are directly relevant to the drift found above). If you find and fix a real process bug in this repo, consider whether the same lesson belongs in `ai-agent-template` too, so future repos don't inherit the same bug.

Update the "Last checked" date and the drift list above whenever this comparison is repeated.

---

_Last Updated: 2026-08-05_ | _Last Reviewed: 2026-08-05_
