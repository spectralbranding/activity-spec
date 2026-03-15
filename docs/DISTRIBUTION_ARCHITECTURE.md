# Distribution Architecture: How Activity Specifications Scale

This document explores how ASP moves from "two files compared manually" to an ecosystem of machine-readable professional specifications matched by AI agents.

---

## The Problem with Centralized Matching

LinkedIn, job boards, and academic networks share a structural flaw: they collapse multi-dimensional profiles into platform-enforced summaries. A 120-character headline. A dropdown menu of skills. A chronological job list.

This collapse is not a UI limitation — it is a business model. The platform captures the full profile, then sells access to it. The person who created the profile does not control how it is searched, filtered, or presented. The platform's algorithm decides which dimensions matter.

The result: two "Brand Strategists" with structurally different activity profiles appear identical in search. Two research programs with perfect complementarity never find each other because one is tagged "marketing" and the other "measurement theory." The collapse destroys the information that matching requires.

---

## Three Distribution Models

### Model 1: Centralized Platform (Current World)

```
Person --> Platform --> Profile (collapsed)
Organization --> Platform --> Job posting (collapsed)
Platform matches collapsed profiles against collapsed postings
```

**How it works**: One platform hosts all specifications. Search, matching, and presentation are controlled by the platform.

**Strengths**: Easy discovery (one place to look). Network effects (everyone is there).

**Weaknesses**:
- Collapse is enforced (120-char headlines, dropdown skills, forced categories)
- Rent-seeking (platform charges for access to profiles it didn't create)
- Lock-in (your profile lives on their server, in their format)
- Algorithmic opacity (you don't know why you weren't shown to a match)
- Incentive misalignment (platform optimizes for engagement, not match quality)

**Verdict**: This is what ASP is designed to replace. Not by building a better platform, but by eliminating the need for one.

### Model 2: Decentralized + Pull (Recommended)

```
Person --> own domain/repo --> i_want.yaml (full specification)
Organization --> own domain --> i_need.yaml (full specification)
AI agents fetch, match, and report to their owners
```

**How it works**: Each person and organization publishes specifications on infrastructure they control. Discovery is distributed. Matching happens client-side.

#### Publishing conventions

**For individuals**:
- Host `i_want.yaml` on personal domain: `person.com/activity-spec.yaml`
- Or in a public git repo: `github.com/user/activity-spec/i_want.yaml`
- Or both (git repo is canonical, domain serves a copy)
- Reference in `llms.txt`: `Activity specification: https://person.com/activity-spec.yaml`

**For organizations**:
- Host opportunity specs at: `company.com/.well-known/asp/opportunities.yaml`
- The `opportunities.yaml` is an index file listing current `i_need` specs:

```yaml
# company.com/.well-known/asp/opportunities.yaml
asp_version: "1.0"
organization: "Example Research Lab"
updated: "2026-03-15"
opportunities:
  - url: "https://example.com/asp/senior-researcher-2026.yaml"
    one_line: "Formal models of organizational decision-making"
    urgency: near_term
    posted: "2026-03-01"
  - url: "https://example.com/asp/postdoc-perception-2026.yaml"
    one_line: "Empirical validation of multi-dimensional perception models"
    urgency: immediate
    posted: "2026-03-10"
```

- Serve with CORS headers (allow cross-origin fetching by AI agents)
- Optional: RSS/Atom feed wrapper for subscription

#### Discovery mechanisms

1. **Direct URL sharing** — Send your spec URL in cold emails, on business cards, in conference materials. The URL IS the introduction.
2. **llms.txt references** — AI agents crawling websites find spec URLs via llms.txt entries.
3. **Voluntary thin registries** — Public indexes that list spec URLs (not hosted content). Like a phone book, not a social network. Anyone can run a registry. Registries are federated.
4. **Web crawling** — AI agents discover specs by following links, reading llms.txt files, and checking `.well-known/asp/` paths.
5. **Git-based discovery** — GitHub/GitLab topic tags (`activity-spec`), README links, repo descriptions.

#### The AI agent monitoring loop

This is the core value proposition: your AI agent works 24/7 so you don't have to.

**Your agent (person side)**:

```
1. Maintains your i_want.yaml (you update it, agent validates)
2. Subscribes to organizations' opportunity feeds
   - Monitors .well-known/asp/opportunities.yaml on target domains
   - Watches RSS feeds from registries
   - Periodically checks domains you've flagged as interesting
3. When a new i_need appears:
   a. Fetches the full spec
   b. Runs ASP-02 matching against your i_want
   c. If match score is "weak" or "poor" — discards silently
   d. If match score is "moderate" or "strong":
      - Researches the organization (web search, papers, news, other specs)
      - Checks for red flags (constraints that conflict with your spec)
      - Drafts a compatibility briefing
4. Delivers briefing to you:
   "This opportunity at [org] scores [strong/moderate] on complementarity.
    Here's the match report. Here's what I found about them.
    Here's a draft introduction if you want to reach out.
    Want me to send it?"
5. You review and decide. The agent does the filtering.
   The human does the judgment.
```

**Organization's agent (demand side)**:

```
1. Maintains opportunity specs (HR/PI updates, agent validates)
2. Receives incoming i_want specs:
   - Via direct submission (person emails their spec URL)
   - Via registry monitoring (discovers new specs matching their domain)
   - Via web crawling (finds specs on personal domains/repos)
3. When a new i_want appears:
   a. Runs ASP-02 matching against active i_need specs
   b. For strong matches: researches the person
      (publications, repos, spec history, web presence)
   c. Drafts a candidate briefing for the hiring manager/PI
4. Delivers briefing:
   "This researcher [name] scores [strong] against your
    [opportunity name] spec. Here's the match report.
    Here's their publication history. Here's their spec's
    git log (shows trajectory). Recommend: reach out."
```

**Key insight**: The agent does the collapse (filtering 1000 specs down to 3 briefings) while the specifications remain full-dimensional. The human never sees the noise. The matching never loses the signal.

#### Technical requirements

- YAML served with `Content-Type: text/yaml` and `Access-Control-Allow-Origin: *`
- Optional JSON-LD embedded in HTML renderings (for search engine indexing)
- `.well-known/asp/` convention for organizational discovery
- RSS/Atom wrappers for feed-based subscription
- GPG-signed git commits for spec authenticity

**Strengths**:
- No platform rent. Specifications hosted by their owners.
- No collapse enforced. Full dimensionality preserved.
- No lock-in. YAML is portable. Git is distributed.
- Matching quality controlled by the user (choose your agent, tune your thresholds)
- Privacy preserved (you choose what to publish, where, and to whom)

**Weaknesses**:
- Cold start (no network effects until adoption reaches critical mass)
- Discovery is harder than centralized search (mitigated by registries and crawling)
- Requires technical literacy to self-host (mitigated by git-based hosting)

### Model 3: Hybrid (Thin Registry + Distributed Storage)

```
Person --> own domain/repo --> i_want.yaml
Person --> registry --> URL pointer
Organization --> own domain --> i_need.yaml
Organization --> registry --> URL pointer
Agents query registries for URLs, fetch specs from source
```

**How it works**: A public registry indexes URLs to spec files — like DNS for activity specifications. No content is hosted centrally. Just pointers.

Anyone can run a registry (federated, like email servers). Registries compete on curation quality, domain focus, and trust.

```yaml
# Example registry entry
- url: "https://person.com/activity-spec.yaml"
  name: "Jane Doe"
  domain: "computational linguistics"
  last_verified: "2026-03-15"
  spec_version: "1.0"
```

**Strengths**: Easier discovery than pure decentralized. No content lock-in (registry only stores URLs). Federated (no single point of control).

**Weaknesses**: Registries can still become gatekeepers if one dominates. Stale URL problem (specs move, registries lag).

---

## Comparison

| Property | Centralized | Decentralized + Pull | Hybrid |
|----------|-------------|---------------------|--------|
| Discovery | Easy (one place) | Hard (must find specs) | Medium (query registries) |
| Collapse | Enforced by platform | None (full spec preserved) | None |
| Lock-in | High (platform owns data) | None (self-hosted) | Low (registry stores URLs only) |
| Privacy | Platform controls | User controls | User controls |
| Matching quality | Platform's algorithm | User's AI agent | User's AI agent |
| Cost | Platform subscription | Self-hosting cost | Self-hosting + registry (free or paid) |
| Network effects | Strong | Weak (until adoption) | Medium |

**Recommendation**: Start with Model 2 (decentralized + pull). Publish specs on personal domains and git repos. Use direct URL sharing. As adoption grows, Model 3 registries will emerge naturally — they're just curated link lists.

---

## The Structural Argument

The decentralized model works because specifications are self-describing. A YAML file that follows the ASP schema contains everything an AI agent needs to evaluate it — no platform context required. This is the same property that makes RSS work: a feed is a self-describing document that any reader can parse.

The centralized model persists because discovery is hard without a directory. But AI agents change this equation: an agent that monitors 50 organizational domains costs almost nothing and misses almost nothing. The "discovery problem" that justified LinkedIn's existence is solved by agents that read YAML, not by platforms that collapse profiles.

The trajectory: as AI agents become standard tools for professionals, the value of centralized platforms decreases and the value of structured, self-hosted specifications increases. Publishing an `i_want.yaml` today is infrastructure for a world that's arriving fast.

---

*This document describes architecture, not implementation. Building a matching platform is a separate project. ASP establishes the specification format. The distribution model follows from the format's properties.*
