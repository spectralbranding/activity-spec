# ASP-02: Match Activity Specifications

**Version**: 1.0
**Input**: One `i_want.yaml` + one `i_need.yaml`
**Output**: `match_report.yaml`
**Schema**: `schema/match_report.yaml`

---

## System Prompt

```
You are evaluating the compatibility between two Activity Specifications
for potential collaboration. One is an "I want" spec (a person's activity
profile). The other is an "I need" spec (an organization's or project's
capability requirements).

Load both YAML files. Analyze structural fit across five dimensions.
Be precise — cite specific fields from both specs to justify each score.
Do not infer capabilities that aren't stated in the specs.

Output a structured match_report.yaml following the schema.
```

---

## Analysis Dimensions

### 1. Complementarity (weight: highest)

The most important dimension. For each entry in the `i_want.active_work` section:
- Does the `i_need.what_we_offer` or `i_need.active_problems.what_exists` match the person's stated `need`?
- Does the person's `frameworks_or_outputs` or `activity.method` match the org's `requirements.capabilities_needed`?

Score:
- **high** — Direct match: person's need is what org offers, org's need is what person produces
- **medium** — Adjacent match: capabilities overlap but require adaptation
- **low** — Minimal overlap: connection exists but requires significant bridging
- **conflict** — Competing for the same space or fundamentally incompatible goals

For each match, cite the specific fields:
```yaml
a_needs_b_has:
  - a_need: "i_want.active_work[0].need"
    b_offers: "i_need.what_we_offer[2].description"
    match_quality: direct
```

### 2. Method Compatibility (weight: high)

Compare `i_want.collaboration` with `i_need.requirements.method_requirements`:
- Does the person's preferred format match the org's expected approach?
- Does the autonomy level match? (A person who needs autonomy + an org that directs closely = friction)
- Does the time commitment align?

Also compare `i_want.activity.method` with `i_need.requirements.preferred_approach`:
- Is the person's working method compatible with what the project requires?

Score: **compatible** | **adaptable** | **incompatible**

### 3. Intellectual Alignment (weight: medium)

Compare `i_want.intellectual_priors` with `i_need` context and requirements:
- Do they share foundational references? (Shared priors suggest shared epistemology)
- Are the person's priors relevant to the org's domain?
- Zero overlap is not necessarily bad — it means different lenses on the same problem (can be complementary)
- Flag contradictions: priors that imply incompatible worldviews

Score: **convergent** | **complementary** | **orthogonal** | **contradictory**

### 4. Positioning (weight: medium)

Compare `i_want.positioning` with `i_need.opportunity`:
- Is the person solving a different aspect of the org's problem? (complementary)
- Is the person's framing a restatement of the org's framing? (overlapping — redundant?)
- Is the person's approach in tension with the org's existing approach? (competing)

Score: **complementary** | **overlapping** | **competing**

### 5. Recommendation (synthesis)

Based on all four dimensions, produce:
- **fit**: strong | moderate | weak | poor
- **collaboration_type**: The most natural form of engagement
  - `autonomous_research` — person works independently, reports results
  - `directed_project` — org sets goals, person executes
  - `co_development` — both contribute to shared output
  - `advisory` — person provides guidance, not execution
  - `not_recommended` — poor fit, don't pursue
- **concrete_first_step**: A specific, actionable thing both parties could do to test the collaboration (not "schedule a call" — something substantive)
- **risks**: What could go wrong even with a strong match

---

## Output Rules

1. Output valid YAML following the `match_report.yaml` schema
2. Every score must be justified with specific field citations from both input specs
3. Do not infer capabilities not stated in the specs — if a field is empty or absent, note this as a gap
4. The `concrete_first_step` must be specific enough to act on without further discussion
5. For historical demos: include `hindsight_verdict` describing what actually happened
6. If complementarity is high but method_compatibility is incompatible, flag this explicitly — high-potential matches with execution friction are common and important to identify

---

## Example Output (abbreviated)

```yaml
meta:
  schema_version: "1.0"
  report_type: "match_report"
  date: "1946-12-15"
  spec_a:
    file: "shannon_1946.yaml"
    name: "Claude Shannon"
    one_line: "Formalizing the mathematical structure of communication"
  spec_b:
    file: "bell_labs_comm_1946.yaml"
    name: "Bell Telephone Laboratories — Communication Research"
    one_line: "Mathematical foundations for next-generation communication systems"

complementarity:
  score: high
  a_needs_b_has:
    - a_need: "Publication venue reaching both mathematicians and engineers"
      b_offers: "Bell System Technical Journal — read by both communities"
      match_quality: direct
  b_needs_a_has:
    - b_need: "Theoretical framework for channel capacity and noise"
      a_offers: "Mathematical abstraction from engineering problems — signal structure independent of content"
      match_quality: direct
  gaps: []

recommendation:
  fit: strong
  collaboration_type: autonomous_research
  concrete_first_step: "Shannon writes a technical memo formalizing the entropy measure for discrete communication channels. Bell Labs circulates to Hamming and Tukey for review."
  risks:
    - "The work may be too abstract for immediate engineering application — Bell Labs management may not see the value until the paper is published and engineers begin applying it"
  hindsight_verdict: "Shannon published 'A Mathematical Theory of Communication' in the Bell System Technical Journal, July and October 1948. It became the foundation of information theory and one of the most cited papers in the history of science."
```
