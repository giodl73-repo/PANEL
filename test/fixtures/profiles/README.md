# Test Fixtures — Reviewer Profiles

Mock profiles using Sesame Street characters for profile loader system validation. Not production profiles—minimal structure for testing only.

## Why Sesame Street?

✅ **Clearly fictional** — No confusion with real researchers
✅ **No ethical concerns** — No simulation of real people
✅ **Fun and memorable** — Easy to remember in test code
✅ **Diverse personalities** — Different review styles to test

## Fixtures

| File | Size | Character | Category | Tests |
|------|------|-----------|----------|-------|
| `cookie-monster.md` | ~680B | Cookie Monster | ML Research | Evaluation rigor, baselines |
| `big-bird.md` | ~650B | Big Bird | HCI | Child learning, user studies |
| `oscar-the-grouch.md` | ~670B | Oscar | ML Systems | Resource efficiency |
| `elmo.md` | ~640B | Elmo | Prompting | Clarity, dialogue systems |
| `grover.md` | ~350B | Grover | ML Research | Minimal valid profile |

## Test Coverage

### Resolution Chain
- **Exact match**: `loadReviewerProfile("cookie-monster")` → cookie-monster.md
- **Slug match**: `loadReviewerProfile("Cookie Monster")` → cookie-monster.md (slugified)
- **Database fallback**: `loadReviewerProfile("Bert")` → REVIEWER-DATABASE.md (if Bert not in profiles)

### Parser Validation
- **Full structure**: cookie-monster.md, big-bird.md have all 7 sections
- **Minimal structure**: grover.md has bare minimum
- **YAML frontmatter**: All fixtures have valid frontmatter
- **Markdown sections**: Background, Publications, Lens, Criteria, Concerns, Voice, Disclosure

### Category Coverage
- ML Research: cookie-monster, grover
- HCI: big-bird
- ML Systems: oscar-the-grouch
- Prompting: elmo

### Caching
- Load cookie-monster twice → first miss, second hit
- Cache stats: 1 hit, 1 miss, ~680B cached

## Character Personas

**Cookie Monster** (ML Research)
Focus: Rigorous evaluation, comprehensive benchmarking
Voice: Systematic (but distracted by cookies)
Key concern: "How many test cases?"

**Big Bird** (HCI)
Focus: Child learning, educational systems
Voice: Curious, child-centered
Key concern: "Can children understand this?"

**Oscar the Grouch** (ML Systems)
Focus: Resource efficiency, no waste
Voice: Grumpy but practical
Key concern: "Why waste resources on this?"

**Elmo** (Prompting)
Focus: Dialogue, clarity, simple explanations
Voice: Enthusiastic, third-person
Key concern: "Can Elmo understand this?"

**Grover** (ML Research)
Focus: Minimal test case
Voice: Lovable and furry
Purpose: Parser edge cases

## Usage

```javascript
// In integration tests (E3-E6)

// Point loader to test fixtures
process.env.PANEL_TEST_MODE = 'true';
process.env.PANEL_PROFILES_PATH = 'test/fixtures/profiles';

// Load test profile
const profile = await loadReviewerProfile("Cookie Monster");
assert(profile.name === "Cookie Monster");
assert(profile.category === "ML Research");

// Test caching
const profile2 = await loadReviewerProfile("Cookie Monster");
const stats = getProfileCacheStats();
assert(stats.hits === 1);

// Test slug match
clearProfileCache();
const profile3 = await loadReviewerProfile("cookie-monster");
assert(profile3.name === "Cookie Monster");

// Test database fallback (if Bert is in REVIEWER-DATABASE but not profiles)
const fallback = await loadReviewerProfile("Bert");
assert(fallback.version === "db-fallback");
```

## Not Included

These fixtures are NOT production-ready profiles:
- ❌ Full 2KB content (minimal ~350-680B instead)
- ❌ Complete publications list (1-2 entries instead of 3-5)
- ❌ Detailed evaluation lens (2-3 bullets instead of 4-6)
- ❌ Comprehensive voice/tone (2-3 descriptors instead of 5)

For production profile examples, see the research paper's architecture specification.

## Validation

All fixtures pass basic validation:
- ✅ YAML frontmatter parses without errors
- ✅ All required fields present (name, affiliation, category, keywords, version)
- ✅ Markdown sections extractable
- ✅ AI Simulation Disclosure included

## Adding New Fixtures

If you need additional test profiles:
1. Use Sesame Street characters (Bert, Ernie, Count, Prairie Dawn, etc.)
2. Keep size minimal (~400-700B)
3. Include all required sections (even if brief)
4. Add to this README with character persona

---

**Purpose**: System validation during E3-E6 integration
**Not for**: Production use, experimental measurements, real reviews
**Theme**: Sesame Street characters (clearly fictional, no ethical concerns)
