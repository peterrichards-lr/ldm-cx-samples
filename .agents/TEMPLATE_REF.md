# Template Reference

This repo's AI-agent governance files (`.agents/AGENTS.md`, `.gemini/gemini.md`, `.claude/`) were established independently and have no automated relationship to any other repo. `ai-agent-template` (https://github.com/peterrichards-lr/ai-agent-template) is maintained as the shared "lessons learned" reference for AI-agent rules across the Liferay tooling repos, but nothing here pulls updates from it automatically. This file is a manual checkpoint so drift gets tracked deliberately instead of silently.

**Reference repo**: <https://github.com/peterrichards-lr/ai-agent-template>
**Reference version at last check**: `v1.2.0` (origin/main @ `83b1cf2`, 2026-08-01)
**Last checked**: 2026-08-05

## Known drift as of this check

- [#11](https://github.com/peterrichards-lr/ldm-cx-samples/issues/11) — a bulk commit stamped fresh "Last Reviewed" footers onto ~19 unrelated files bundled with an unrelated fix, plus accidentally committed debug artifacts. Fixed in PR #14: debug artifacts removed and gitignored, `[bypass limit]` convention retired via `CONTRIBUTING.md`. **Correction to this file's earlier note**: `ai-agent-template`'s `append_timestamps.py` was verified append-only-from-day-one (no PR #16 fix for a rewrite-on-touch bug exists there — that premise was mistaken). Our own `scripts/append_timestamps.py` was independently verified to already be append-only-if-missing too, so no script fix was needed on either side.
- [#12](https://github.com/peterrichards-lr/ldm-cx-samples/issues/12) — `.agents/AGENTS.md` (modular) and `.gemini/GEMINI.md` + `.claude/CLAUDE.md` (monolithic, never pruned) were two non-reconciled instruction systems despite a commit claiming to "migrate" from one to the other. Fixed by reconciling in place (documenting coexistence + precedence) rather than pruning: `AGENTS.md` now states it's additive/repo-specific and defers to the general rules on Liferay platform fundamentals; the general rules files (and all their mirrors in `.cursor/`, `.windsurf/`, `.github/`, `.workspace-rules/`) now cross-reference `AGENTS.md` back. Also added the `release-management` skill `AGENTS.md` claimed to require but never had. **Correction to this file's earlier note**: `ai-agent-template` does not actually have a "thin pointer" `CLAUDE.md`/`GEMINI.md` pattern to copy (it has no `CLAUDE.md` at all, and its `GEMINI.md` only delegates specific sections, not the whole file) — this repo's fix was designed directly for its own structure rather than ported.

## Skills available in the reference repo (for comparison; not all apply here)

`coding-standards`, `documentation`, `github-workflow`, `human-in-the-loop`, `multi-agent-orchestration`, `reflection-and-planning`, `release-management`, `rule-adherence`, `tool-use-react`, `unit-testing`

## How to use this file

Before writing a new agent rule here, check whether `ai-agent-template` already documents a corrected/newer version of the same rule (its `documentation` and `rule-adherence` skills are directly relevant to the drift found above). If you find and fix a real process bug in this repo, consider whether the same lesson belongs in `ai-agent-template` too, so future repos don't inherit the same bug.

Update the "Last checked" date and the drift list above whenever this comparison is repeated.

---

_Last Updated: 2026-08-06_ | _Last Reviewed: 2026-08-06_
