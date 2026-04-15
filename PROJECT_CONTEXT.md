# Project Context: Activity Specification Protocol

## What This Is

A public specification + demo repo for the Activity Specification Protocol (ASP) — a YAML-based system for machine-readable professional profiles that describe WHAT people do (not who they are) and WHAT organizations need (not what job title they're hiring for).

## Repository

- **Org**: `spectralbranding` (public)
- **Repo**: `activity-spec`
- **License**: MIT
- **Status**: v1.0.0 — specification + historical demos

## Key Files

| File | Purpose |
|------|---------|
| `schema/i_want.yaml` | Person specification schema |
| `schema/i_need.yaml` | Opportunity specification schema |
| `schema/match_report.yaml` | Compatibility report schema |
| `prompts/ASP_01_GENERATE.md` | LLM prompt for creating specs |
| `prompts/ASP_02_MATCH.md` | LLM prompt for matching specs |
| `examples/` | 5 historical demos (i_want + i_need + match_report each) |
| `docs/DISTRIBUTION_ARCHITECTURE.md` | RSS/pull model design document |

## Origin

ASP grew out of Spectral Brand Theory (SBT) and Organizational Schema Theory (OST). The core insight: traditional CVs are "collapsed perception clouds" — they reduce multi-dimensional activity profiles into single-line summaries, losing structural information. ASP preserves the full dimensionality and lets each observer collapse according to their own needs.

Design documented in the private `spectral-branding` repo: `launch/RESEARCHER_PROFILE.md`

## Conventions

- YAML for all data files (not JSON)
- Markdown for all documentation
- No SBT/OST jargon in public-facing content — standalone comprehensible
- Historical demos must be factually accurate (sources in `docs/HISTORICAL_NOTES.md`)
- Python 3.12 + uv for any future tooling
