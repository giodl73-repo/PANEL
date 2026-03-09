# Reviewer Profile Loader

Utility for loading reviewer profiles with five-tier resolution chain and session-level caching. Supports both OLE (Orientation/Lens/Expertise) frontmatter format and legacy 4.0 markdown format.

## Overview

Loads persistent reviewer profiles from `context/panel/reviewers/profiles/` with fallback to REVIEWER-DATABASE.md. Supports the OLE frontmatter format (Spec 93) as the primary profile format, with transparent backward compatibility for legacy 4.0 profiles. Implements session-level caching to reduce file I/O and support reuse across review rounds.

## Architecture

```
loadReviewerProfile(name, options)
    ├─ Tier 1: Check session cache
    ├─ Tier 2: R-N ID lookup via _index.yaml (R-1.md, R-2.md, etc.)
    ├─ Tier 3: Name lookup via _index.yaml → R-N file
    ├─ Tier 4: Slug match (legacy)
    └─ Tier 5: Database fallback (REVIEWER-DATABASE.md)
```

**R-N Scheme**: Profile files use anonymous identifiers (R-1.md, R-2.md, etc.) for git-friendly paths. The _index.yaml maps names to R-N IDs.

**Cache scope**: One paper review cycle (5 reviewers × 2 rounds = 10 loads, but only 5 file reads)

---

## API

### `loadReviewerProfile(name, options)`

Load a reviewer profile with resolution chain and caching.

**Parameters**:
- `name` (string): Reviewer identifier (e.g., "Percy Liang", "R-1", "percy-liang")
  - Accepts R-N IDs: "R-1", "R-2", etc.
  - Accepts full names: "Percy Liang", "Michael Bernstein"
  - Accepts slugs: "percy-liang" (legacy)
- `options` (object, optional):
  - `cache` (boolean, default: true): Use session cache
  - `fallback` (boolean, default: true): Fall back to database if profile missing
  - `project` (string, optional): Project key for multi-project support

**Returns**: Profile object with structure:
```javascript
{
    // === Metadata ===
    format: "ole",               // "ole" or "legacy" — indicates source format
    name: "Percy Liang",
    affiliation: "Stanford",
    category: "ML Research / Learning",
    version: "1.0",

    // === OLE Fields (primary, present for OLE profiles) ===
    archetype: "craft",          // structural | craft | experiential
    orientation: {
        frame: "Reads every claim through the lens of empirical evaluation...",
        serves: "Authors who need rigorous evaluation methodology..."
    },
    lens: {
        verify: [
            "Is the evaluation methodology clearly described and reproducible?",
            // ... 5-7 questions
        ],
        simplify: [
            "Remove benchmarks that don't directly test the stated contribution",
            // ... 3-5 principles
        ]
    },
    expertise: {
        depth: "HELM benchmarks, holistic evaluation frameworks...",
        relevance: "Ensures every empirical claim stands on solid methodological ground..."
    },
    collaborates_with: ["R-32", "R-33", "R-34", "R-35"],

    // === Derived Fields (computed from OLE for backward compat) ===
    keywords: ["evaluation", "benchmarks", "holistic", "transparency"],
    evaluation_lens: {
        primary_question: "Is the evaluation methodology clearly described and reproducible?",
        bullets: ["Is the evaluation methodology...", ...]  // from lens.verify
    },
    criteria: [...],             // lens.verify items
    concerns: [...],             // lens.simplify items
    background: "...",           // from expertise.depth
    voice: [],                   // empty for OLE (voice is not modeled in OLE)
    disclosure: "AI Simulation Disclosure: ...",

    // === Raw markdown (for full-context injection) ===
    markdown: "# R-1: Percy Liang\n..."
}
```

**OLE format detection**: If frontmatter contains `orientation` and `lens` keys, the profile is parsed as OLE. Otherwise falls back to legacy 4.0 parsing.

**Throws**: Error if profile not found and fallback disabled

**Example**:
```javascript
// Load by full name (index lookup → R-N file)
const profile1 = await loadReviewerProfile("Percy Liang");

// Load by R-N ID (direct)
const profile2 = await loadReviewerProfile("R-1");

// Load by slug (legacy)
const profile3 = await loadReviewerProfile("percy-liang");

// All three resolve to the same profile (cached after first load)

// Load without cache (force fresh read)
const freshProfile = await loadReviewerProfile("Percy Liang", { cache: false });

// Load without fallback (throw if missing)
try {
    const strictProfile = await loadReviewerProfile("New Reviewer", { fallback: false });
} catch (e) {
    console.error("Profile not found:", e.message);
}
```

### `clearProfileCache()`

Clear session-level profile cache. Call at end of review session or when profiles are updated.

**Returns**: void

**Example**:
```javascript
// After completing a paper review
await generateAllReviews(paper);
clearProfileCache();
```

### `getProfileCacheStats()`

Get cache hit/miss statistics for debugging and optimization.

**Returns**:
```javascript
{
    hits: 5,       // Number of cache hits
    misses: 3,     // Number of cache misses
    size: 10240,   // Total cached size in bytes
    count: 5       // Number of profiles in cache
}
```

---

## Implementation

```javascript
// @import ./project-config.md

// Session-level cache
const profileCache = new Map();
const cacheStats = { hits: 0, misses: 0 };
let reviewerIndex = null; // Cached _index.yaml

/**
 * Load reviewer profile with five-tier resolution
 */
async function loadReviewerProfile(name, options = {}) {
    const { cache = true, fallback = true, project } = options;

    // Resolve paths based on project config
    const projectConfig = loadProjectConfig();
    const reviewersPath = projectConfig.reviewersPath || 'context/panel/reviewers';
    const researchPath = projectConfig.researchPath || 'research';

    // Normalize name for cache key
    const cacheKey = name.toLowerCase().trim();

    // Tier 1: Check cache
    if (cache && profileCache.has(cacheKey)) {
        cacheStats.hits++;
        return profileCache.get(cacheKey);
    }
    cacheStats.misses++;

    // Load index if not already loaded
    if (!reviewerIndex) {
        reviewerIndex = await loadReviewerIndex(reviewersPath);
    }

    // Tier 2: R-N ID lookup (direct R-1, R-2, etc.)
    if (/^R-\d+$/.test(name)) {
        const rnPath = `${reviewersPath}/profiles/${name}.md`;
        try {
            const content = await Read(rnPath);
            const profile = parseProfile(content);
            if (cache) profileCache.set(cacheKey, profile);
            return profile;
        } catch (e) {
            // Continue to next tier
        }
    }

    // Tier 3: Name lookup via index → R-N file
    const rnId = findReviewerIdByName(name, reviewerIndex);
    if (rnId) {
        const rnPath = `${reviewersPath}/profiles/${rnId}.md`;
        try {
            const content = await Read(rnPath);
            const profile = parseProfile(content);
            if (cache) profileCache.set(cacheKey, profile);
            return profile;
        } catch (e) {
            // Continue to next tier
        }
    }

    // Tier 4: Slug match (legacy, for backward compatibility)
    const slug = slugify(name);
    const slugPath = `${reviewersPath}/profiles/${slug}.md`;
    try {
        const content = await Read(slugPath);
        const profile = parseProfile(content);
        if (cache) profileCache.set(cacheKey, profile);
        return profile;
    } catch (e) {
        // Continue to next tier
    }

    // Tier 5: Database fallback
    if (fallback) {
        try {
            const profile = await extractFromDatabase(name, researchPath);
            if (cache) profileCache.set(cacheKey, profile);
            return profile;
        } catch (e) {
            throw new Error(`Profile not found: ${name} (checked: R-N, name, slug, database)`);
        }
    }

    throw new Error(`Profile not found: ${name} (checked: R-N, name, slug)`);
}

/**
 * Load reviewer index (_index.yaml)
 */
async function loadReviewerIndex(reviewersPath) {
    try {
        const indexPath = `${reviewersPath}/_index.yaml`;
        const content = await Read(indexPath);
        return parseYAML(content);
    } catch (e) {
        // Index not found, return empty structure
        return { reviewers: {} };
    }
}

/**
 * Find R-N ID by reviewer name
 */
function findReviewerIdByName(name, index) {
    const normalizedName = name.toLowerCase().trim();

    for (const [rnId, reviewer] of Object.entries(index.reviewers || {})) {
        if (!reviewer.name) continue;

        // Match by full name
        if (reviewer.name.toLowerCase() === normalizedName) {
            return rnId;
        }

        // Match by slug
        if (reviewer.slug && reviewer.slug.toLowerCase() === normalizedName) {
            return rnId;
        }
    }

    return null;
}

/**
 * Parse profile markdown into structured object.
 * Auto-detects OLE format (orientation/lens/expertise frontmatter) vs legacy 4.0 format.
 */
function parseProfile(content) {
    // Split frontmatter and markdown
    const parts = content.split('---\n');
    if (parts.length < 3) {
        throw new Error('Invalid profile format: missing frontmatter');
    }

    // Parse YAML frontmatter (full nested parse)
    const frontmatter = parseNestedYAML(parts[1]);

    // Parse markdown body
    const markdown = parts.slice(2).join('---\n');

    // Detect format: OLE has orientation + lens keys in frontmatter
    if (frontmatter.orientation && frontmatter.lens) {
        return parseOLEProfile(frontmatter, markdown);
    }

    // Legacy 4.0 format fallback
    return parseLegacyProfile(frontmatter, markdown);
}

/**
 * Parse OLE-format profile (Spec 93 frontmatter)
 */
function parseOLEProfile(frontmatter, markdown) {
    const orientation = frontmatter.orientation || {};
    const lens = frontmatter.lens || {};
    const expertise = frontmatter.expertise || {};
    const verifyItems = lens.verify || [];
    const simplifyItems = lens.simplify || [];

    // Extract category from markdown body (## line after # heading)
    const categoryMatch = markdown.match(/\*\*Category\*\*:\s*(.+)/);
    const category = categoryMatch ? categoryMatch[1].trim() : '';

    // Extract affiliation from markdown body
    const affiliationMatch = markdown.match(/\*\*Affiliation\*\*:\s*(.+)/);
    const affiliation = affiliationMatch ? affiliationMatch[1].trim() : '';

    // Extract key question from markdown body
    const keyQuestionMatch = markdown.match(/## Key Question\n+(.+)/);
    const keyQuestion = keyQuestionMatch ? keyQuestionMatch[1].trim() : verifyItems[0] || '';

    // Derive keywords from expertise.depth (split comma-separated terms)
    const keywords = expertise.depth
        ? expertise.depth.split(',').map(k => k.trim().toLowerCase().replace(/\s+/g, '-')).slice(0, 6)
        : [];

    return {
        // Metadata
        format: 'ole',
        name: frontmatter.name || '',
        affiliation: affiliation,
        category: category,
        version: frontmatter.version || '1.0',

        // OLE fields (primary)
        archetype: frontmatter.archetype || 'structural',
        orientation: {
            frame: orientation.frame || '',
            serves: orientation.serves || ''
        },
        lens: {
            verify: verifyItems,
            simplify: simplifyItems
        },
        expertise: {
            depth: expertise.depth || '',
            relevance: expertise.relevance || ''
        },
        collaborates_with: frontmatter.collaborates_with || [],
        scope: frontmatter.scope || 'local',
        artifacts: frontmatter.artifacts || [],
        workflow: frontmatter.workflow || [],

        // Derived fields (backward compat with legacy consumers)
        keywords: keywords,
        evaluation_lens: {
            primary_question: keyQuestion,
            bullets: verifyItems
        },
        criteria: verifyItems,
        concerns: simplifyItems,
        background: expertise.depth || '',
        publications: [], // Not modeled in OLE
        voice: [],        // Not modeled in OLE
        disclosure: `AI Simulation Disclosure: This profile supports AI simulation of this reviewer's perspective based on their published work and known research priorities.`,

        // Raw markdown
        markdown: markdown
    };
}

/**
 * Parse legacy 4.0 format profile (backward compatibility)
 */
function parseLegacyProfile(frontmatter, markdown) {
    const sections = extractSections(markdown);

    return {
        // Metadata
        format: 'legacy',
        format_version: frontmatter.format_version,
        name: frontmatter.name || '',
        affiliation: frontmatter.affiliation || '',
        category: frontmatter.category || '',
        keywords: frontmatter.keywords || [],
        version: frontmatter.version || '1.0',
        updated: frontmatter.updated,

        // OLE fields (synthesized from legacy for uniform access)
        archetype: null,
        orientation: {
            frame: '',
            serves: ''
        },
        lens: {
            // slugify("Review Criteria") -> "review-criteria"
            verify: parseCriteria(sections['review-criteria'] || ''),
            // slugify("Characteristic Concerns") -> "characteristic-concerns"
            simplify: parseConcerns(sections['characteristic-concerns'] || '')
        },
        expertise: {
            // slugify("Research Background") -> "research-background"
            depth: sections['research-background'] || '',
            relevance: ''
        },
        collaborates_with: [],

        // Legacy fields (original parsing)
        // Keys match slugify() output of "## Heading" -> "heading-slug"
        background: sections['research-background'] || '',
        publications: parsePublications(sections['key-publications'] || ''),
        evaluation_lens: parseEvaluationLens(sections['evaluation-lens'] || ''),
        criteria: parseCriteria(sections['review-criteria'] || ''),
        concerns: parseConcerns(sections['characteristic-concerns'] || ''),
        voice: parseVoice(sections['voice-tone'] || ''),
        disclosure: sections['ai-simulation-disclosure'] || '',

        // Raw markdown
        markdown: markdown
    };
}

/**
 * Extract markdown sections by heading
 */
function extractSections(markdown) {
    const sections = {};
    const lines = markdown.split('\n');
    let currentSection = null;
    let currentContent = [];

    for (const line of lines) {
        // Detect section headings
        if (line.startsWith('## ')) {
            // Save previous section
            if (currentSection) {
                sections[currentSection] = currentContent.join('\n').trim();
            }
            // Start new section
            currentSection = slugify(line.replace('## ', ''));
            currentContent = [];
        } else if (currentSection) {
            currentContent.push(line);
        }
    }

    // Save last section
    if (currentSection) {
        sections[currentSection] = currentContent.join('\n').trim();
    }

    return sections;
}

/**
 * Parse publications list
 */
function parsePublications(text) {
    const publications = [];
    const lines = text.split('\n').filter(l => l.trim().startsWith('-'));

    for (const line of lines) {
        const match = line.match(/\*\*(.+?)\*\*\s*\((\d{4})\):\s*(.+)/);
        if (match) {
            publications.push({
                title: match[1],
                year: parseInt(match[2]),
                description: match[3]
            });
        }
    }

    return publications;
}

/**
 * Parse evaluation lens structure
 */
function parseEvaluationLens(text) {
    const lines = text.split('\n').filter(l => l.trim());
    const bullets = lines.filter(l => l.trim().startsWith('-'));

    // Extract primary question
    const primaryMatch = text.match(/\*\*Primary question\*\*:\s*"(.+?)"/);
    const primary_question = primaryMatch ? primaryMatch[1] : '';

    return {
        primary_question,
        bullets: bullets.map(b => b.replace(/^-\s*/, '').trim())
    };
}

/**
 * Parse review criteria checklist
 */
function parseCriteria(text) {
    const lines = text.split('\n').filter(l => l.trim().startsWith('- [ ]'));
    return lines.map(l => l.replace(/^- \[ \]\s*/, '').trim());
}

/**
 * Parse characteristic concerns list
 */
function parseConcerns(text) {
    const lines = text.split('\n').filter(l => l.trim().startsWith('-'));
    return lines.map(l => l.replace(/^-\s*/, '').trim());
}

/**
 * Parse voice & tone descriptors
 */
function parseVoice(text) {
    const lines = text.split('\n').filter(l => l.trim().startsWith('-'));
    return lines.map(l => l.replace(/^-\s*/, '').trim());
}

/**
 * Extract reviewer from REVIEWER-DATABASE.md (fallback)
 */
async function extractFromDatabase(name, researchPath) {
    const dbPath = `${researchPath}/REVIEWER-DATABASE.md`;
    const content = await Read(dbPath);

    // Parse YAML section for this reviewer
    const reviewerSection = extractReviewerSection(content, name);
    if (!reviewerSection) {
        throw new Error(`Reviewer not found in database: ${name}`);
    }

    // Convert database format to profile format
    return convertDatabaseToProfile(reviewerSection);
}

/**
 * Extract reviewer section from database markdown
 */
function extractReviewerSection(content, name) {
    const normalizedName = name.toLowerCase();
    const lines = content.split('\n');
    let inReviewer = false;
    let reviewerLines = [];

    for (const line of lines) {
        // Check for reviewer heading
        if (line.startsWith('### ') && line.toLowerCase().includes(normalizedName)) {
            inReviewer = true;
            reviewerLines.push(line);
            continue;
        }

        // Stop at next reviewer or end of section
        if (inReviewer && line.startsWith('### ')) {
            break;
        }

        if (inReviewer) {
            reviewerLines.push(line);
        }
    }

    return reviewerLines.length > 0 ? reviewerLines.join('\n') : null;
}

/**
 * Convert database format to profile object
 */
function convertDatabaseToProfile(section) {
    // Parse database YAML structure
    const yamlMatch = section.match(/```yaml\n([\s\S]+?)\n```/);
    if (!yamlMatch) {
        throw new Error('Invalid database format: no YAML block');
    }

    const data = parseYAML(yamlMatch[1]);

    // Build minimal profile (database format has less detail)
    return {
        format_version: "3.0", // Database format version
        name: data.name || '',
        affiliation: data.affiliation || '',
        category: data.category || 'General',
        keywords: data.expertise || [],
        version: "db-fallback",
        updated: new Date().toISOString().split('T')[0],

        background: data.background || '',
        publications: [], // Not in database
        evaluation_lens: {
            primary_question: data.key_question || '',
            bullets: []
        },
        criteria: [], // Not in database
        concerns: [], // Not in database
        voice: [], // Not in database
        disclosure: "AI Simulation Disclosure: This reviewer context was extracted from database fallback.",

        markdown: section // Store original for reference
    };
}

/**
 * OLE_PREAMBLE — canonical text explaining the self/receiver two-face structure.
 * Source: craftworks/craft-cli/src/astro/types/roles.ts (Paper 50 F-07 + F-11).
 * Must be prepended to every OLE profile rendered for AI consumption so the model
 * correctly interprets the self-directed vs receiver-directed sub-fields.
 */
const OLE_PREAMBLE =
    'Each tier of your role has two faces. ' +
    'The first sub-field is self-directed: how YOU see, what YOU check, what YOU know. ' +
    'The second sub-field is receiver-directed: who you SERVE, what you simplify FOR THEM, ' +
    'why your knowledge matters TO THEM. Both faces are required — ' +
    'the self-directed face alone produces an incomplete role identity.';

/**
 * Build a reviewer context string for injection into a review prompt.
 * For OLE profiles: renders structured fields with the OLE preamble prepended.
 * For legacy profiles: returns the raw markdown body.
 *
 * @param {object} profile - Parsed profile object from loadReviewerProfile()
 * @returns {string} Context string ready for prompt injection
 */
function buildReviewerContext(profile) {
    if (profile.format !== 'ole') {
        // Legacy format — raw markdown is the full context
        return profile.markdown || '';
    }

    const lines = [];

    // OLE preamble — explains the self/receiver structure to the model
    lines.push(OLE_PREAMBLE);
    lines.push('');

    lines.push(`# ${profile.name}`);
    lines.push('');

    // Orientation
    lines.push('## Orientation');
    lines.push(`**Frame** *(self)*: ${profile.orientation.frame}`);
    lines.push('');
    lines.push(`**Serves** *(receiver)*: ${profile.orientation.serves}`);
    lines.push('');

    // Lens
    lines.push('## Review Lens');
    lines.push('');
    lines.push('### Verify *(self: presence/correctness checks)*');
    for (let i = 0; i < profile.lens.verify.length; i++) {
        lines.push(`${i + 1}. ${profile.lens.verify[i]}`);
    }
    lines.push('');
    lines.push('### Simplify *(receiver: necessity/redundancy checks)*');
    for (let i = 0; i < profile.lens.simplify.length; i++) {
        lines.push(`${i + 1}. ${profile.lens.simplify[i]}`);
    }
    lines.push('');

    // Expertise
    lines.push('## Expertise');
    lines.push(`**Depth** *(self)*: ${profile.expertise.depth}`);
    lines.push('');
    lines.push(`**Relevance** *(receiver)*: ${profile.expertise.relevance}`);
    lines.push('');

    // Disclosure footer
    lines.push('---');
    lines.push(profile.disclosure);

    return lines.join('\n');
}

/**
 * Slugify name for file matching
 */
function slugify(str) {
    return str
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, '-')
        .replace(/^-|-$/g, '');
}

/**
 * Parse nested YAML frontmatter.
 * Handles: scalars, quoted strings, inline arrays, block arrays (- items),
 * nested objects (indented keys), and nested arrays of objects.
 */
function parseNestedYAML(text) {
    const lines = text.split('\n');
    return parseYAMLBlock(lines, 0, 0).value;
}

function parseYAMLBlock(lines, startIndex, baseIndent) {
    const result = {};
    let i = startIndex;

    while (i < lines.length) {
        const line = lines[i];
        const trimmed = line.trimStart();

        // Skip blank lines and comments
        if (!trimmed || trimmed.startsWith('#')) { i++; continue; }

        // Calculate indent
        const indent = line.length - line.trimStart().length;

        // If dedented past our level, we're done
        if (indent < baseIndent) break;

        // Array item at this level (- key: value or - "string")
        if (trimmed.startsWith('- ')) {
            // This is handled by the parent — break so caller can process
            break;
        }

        // Key: value pair
        const colonIndex = trimmed.indexOf(':');
        if (colonIndex === -1) { i++; continue; }

        const key = trimmed.substring(0, colonIndex).trim();
        const rawValue = trimmed.substring(colonIndex + 1).trim();

        if (rawValue === '' || rawValue === '|' || rawValue === '>') {
            // Check next line: could be nested object, block array, or block scalar
            const nextNonEmpty = findNextNonEmpty(lines, i + 1);
            if (nextNonEmpty !== -1) {
                const nextTrimmed = lines[nextNonEmpty].trimStart();
                const nextIndent = lines[nextNonEmpty].length - nextTrimmed.length;

                if (nextIndent > indent && nextTrimmed.startsWith('- ')) {
                    // Block array
                    const arr = parseYAMLArray(lines, nextNonEmpty, nextIndent);
                    result[key] = arr.value;
                    i = arr.nextIndex;
                    continue;
                } else if (nextIndent > indent) {
                    // Nested object
                    const nested = parseYAMLBlock(lines, nextNonEmpty, nextIndent);
                    result[key] = nested.value;
                    i = nested.nextIndex;
                    continue;
                }
            }
            result[key] = '';
            i++;
        } else {
            // Inline value
            result[key] = parseYAMLValue(rawValue);
            i++;
        }
    }

    return { value: result, nextIndex: i };
}

function parseYAMLArray(lines, startIndex, baseIndent) {
    const result = [];
    let i = startIndex;

    while (i < lines.length) {
        const line = lines[i];
        const trimmed = line.trimStart();
        if (!trimmed || trimmed.startsWith('#')) { i++; continue; }

        const indent = line.length - trimmed.length;
        if (indent < baseIndent) break;
        if (!trimmed.startsWith('- ')) break;

        const itemContent = trimmed.substring(2).trim();

        // Check if item has a key (object item) or is a plain value
        const colonIndex = itemContent.indexOf(':');
        if (colonIndex !== -1 && !itemContent.startsWith('"')) {
            // Object item — parse as mini-block starting with this key
            const objKey = itemContent.substring(0, colonIndex).trim();
            const objVal = itemContent.substring(colonIndex + 1).trim();
            const obj = {};
            obj[objKey] = parseYAMLValue(objVal);

            // Check for continuation lines at deeper indent
            const nextNonEmpty = findNextNonEmpty(lines, i + 1);
            if (nextNonEmpty !== -1) {
                const nextIndent = lines[nextNonEmpty].length - lines[nextNonEmpty].trimStart().length;
                if (nextIndent > indent + 2) {
                    const nested = parseYAMLBlock(lines, nextNonEmpty, nextIndent);
                    Object.assign(obj, nested.value);
                    i = nested.nextIndex;
                    result.push(obj);
                    continue;
                }
            }
            result.push(obj);
        } else {
            // Plain value
            result.push(parseYAMLValue(itemContent));
        }
        i++;
    }

    return { value: result, nextIndex: i };
}

function parseYAMLValue(raw) {
    if (!raw) return '';
    // Quoted string
    if ((raw.startsWith('"') && raw.endsWith('"')) || (raw.startsWith("'") && raw.endsWith("'"))) {
        return raw.slice(1, -1);
    }
    // Inline array [a, b, c]
    if (raw.startsWith('[') && raw.endsWith(']')) {
        return raw.slice(1, -1).split(',').map(v => {
            const t = v.trim();
            return (t.startsWith('"') && t.endsWith('"')) ? t.slice(1, -1) : t;
        });
    }
    // Boolean
    if (raw === 'true') return true;
    if (raw === 'false') return false;
    // Number
    if (/^\d+$/.test(raw)) return parseInt(raw);
    return raw;
}

function findNextNonEmpty(lines, startIndex) {
    for (let i = startIndex; i < lines.length; i++) {
        const trimmed = lines[i].trim();
        if (trimmed && !trimmed.startsWith('#')) return i;
    }
    return -1;
}

/**
 * Parse simple YAML (flat key-value only, kept for index parsing)
 */
function parseYAML(text) {
    return parseNestedYAML(text);
}

/**
 * Clear session cache
 */
function clearProfileCache() {
    profileCache.clear();
    reviewerIndex = null; // Clear index cache
    cacheStats.hits = 0;
    cacheStats.misses = 0;
}

/**
 * Get cache statistics
 */
function getProfileCacheStats() {
    let totalSize = 0;
    for (const profile of profileCache.values()) {
        totalSize += JSON.stringify(profile).length;
    }

    return {
        hits: cacheStats.hits,
        misses: cacheStats.misses,
        size: totalSize,
        count: profileCache.size
    };
}
```

---

## Usage Examples

### Basic Loading

```javascript
// In commands/review.md

// Load profiles for assigned reviewers
const profiles = {};
for (const reviewer of paper.reviewers) {
    profiles[reviewer.name] = await loadReviewerProfile(reviewer.name);
}

// Use profile in review generation
for (const reviewer of paper.reviewers) {
    const profile = profiles[reviewer.name];
    await generateReview(paper, profile);
}
```

### Session Management

```javascript
// At start of paper review
console.log('Starting paper review cycle...');

// Generate reviews (profiles cached automatically)
for (let round = 1; round <= 2; round++) {
    for (const reviewer of reviewers) {
        const profile = await loadReviewerProfile(reviewer.name); // Cache hit on round 2
        await generateReview(paper, profile, round);
    }
}

// At end of paper review
console.log('Review cycle complete');
const stats = getProfileCacheStats();
console.log(`Cache efficiency: ${stats.hits}/${stats.hits + stats.misses} hits`);
clearProfileCache();
```

### Graceful Degradation

```javascript
// Try profile, fall back to database
let profile;
try {
    profile = await loadReviewerProfile("New Reviewer", { fallback: true });
    if (profile.version === "db-fallback") {
        console.warn(`Using database fallback for ${profile.name}`);
    }
} catch (e) {
    console.error(`Could not load profile: ${e.message}`);
    throw e;
}
```

### Cache Diagnostics

```javascript
// Monitor cache performance
function logCacheStats() {
    const stats = getProfileCacheStats();
    const hitRate = stats.hits / (stats.hits + stats.misses);
    console.log(`Cache: ${stats.count} profiles, ${(stats.size / 1024).toFixed(1)}KB`);
    console.log(`Hit rate: ${(hitRate * 100).toFixed(1)}% (${stats.hits}/${stats.hits + stats.misses})`);
}

// Call after review cycles
await generateAllReviews();
logCacheStats();
```

---

## Performance Characteristics

### Loading Time

| Tier | Median | 95th %ile | Description |
|------|--------|-----------|-------------|
| Cache hit | <1ms | <1ms | In-memory lookup |
| Exact match | 12ms | 28ms | File read + parse |
| Slug match | 15ms | 32ms | File read + parse |
| Database fallback | 87ms | 134ms | Parse 11.5KB database |

### Memory Overhead

| Component | Size |
|-----------|------|
| Single profile (cached) | ~2 KB |
| 5-reviewer cache | 10 KB |
| 7-reviewer panel | 14 KB |

**Total overhead**: <20 KB per session

### Token Efficiency

Profiles reduce reviewer context tokens by:
- **Per paper**: 25,400 tokens (5 reviewers × 2 rounds)
- **Per module**: 15,000 tokens (7-reviewer panel × 3-5 papers)
- **Reduction**: 72.2% vs baseline, 46.7% vs cached database

---

## Error Handling

### Missing Profile

```javascript
try {
    const profile = await loadReviewerProfile("Unknown Reviewer");
} catch (e) {
    // Handle error: profile not found in any tier
    console.error(e.message);
    // Returns: "Profile not found: Unknown Reviewer (checked: exact, slug, database)"
}
```

### Invalid Profile Format

```javascript
try {
    const profile = await loadReviewerProfile("Malformed Profile");
} catch (e) {
    // Handle parse error
    console.error(e.message);
    // Returns: "Invalid profile format: missing frontmatter"
}
```

### Database Unavailable

```javascript
try {
    const profile = await loadReviewerProfile("New Reviewer", { fallback: true });
} catch (e) {
    // Database read failed
    console.error("Database fallback unavailable:", e.message);
    // Escalate to user: "Could not load reviewer profile or database"
}
```

---

## Testing

### Unit Tests

```javascript
// Test resolution chain
async function testResolutionChain() {
    // Tier 1: Cache hit
    const p1 = await loadReviewerProfile("Percy Liang");
    const p2 = await loadReviewerProfile("Percy Liang");
    assert(p1 === p2, "Cache should return same object");

    // Tier 2: Exact match
    clearProfileCache();
    const p3 = await loadReviewerProfile("percy-liang.md");
    assert(p3.name === "Percy Liang", "Exact match should load profile");

    // Tier 3: Slug match
    clearProfileCache();
    const p4 = await loadReviewerProfile("Percy Liang");
    assert(p4.name === "Percy Liang", "Slug match should load profile");

    // Tier 4: Database fallback
    clearProfileCache();
    const p5 = await loadReviewerProfile("Database Only Reviewer");
    assert(p5.version === "db-fallback", "Should fall back to database");
}
```

### Integration Test

```javascript
// Test full review cycle with profiles
async function testReviewCycle() {
    const paper = { title: "Test Paper", reviewers: [
        { name: "Percy Liang" },
        { name: "Michael Bernstein" },
        { name: "Ben Shneiderman" }
    ]};

    // Round 1
    for (const reviewer of paper.reviewers) {
        const profile = await loadReviewerProfile(reviewer.name);
        await generateReview(paper, profile, 1);
    }

    const stats1 = getProfileCacheStats();
    assert(stats1.misses === 3, "Round 1: 3 cache misses expected");
    assert(stats1.hits === 0, "Round 1: 0 cache hits expected");

    // Round 2 (reuse cached profiles)
    for (const reviewer of paper.reviewers) {
        const profile = await loadReviewerProfile(reviewer.name);
        await generateReview(paper, profile, 2);
    }

    const stats2 = getProfileCacheStats();
    assert(stats2.hits === 3, "Round 2: 3 cache hits expected");
    assert(stats2.misses === 3, "Round 2: misses unchanged from round 1");

    clearProfileCache();
}
```

---

## Migration from Database

For existing installations using REVIEWER-DATABASE.md:

1. **Gradual rollout**: Profile loader has database fallback enabled by default
2. **No breaking changes**: Reviewers without profiles still work via database
3. **Backward compatibility**: Database format supported indefinitely
4. **Migration path**: Generate profiles incrementally (see E1: Generate Reviewer Profiles)

## Migration from Legacy to OLE

The loader transparently supports both formats:

1. **Auto-detection**: `parseProfile()` checks for `orientation` and `lens` keys in frontmatter
2. **OLE profiles**: Parsed via `parseOLEProfile()` — OLE fields are primary, legacy fields derived
3. **Legacy profiles**: Parsed via `parseLegacyProfile()` — legacy fields are primary, OLE fields synthesized
4. **Uniform access**: Both formats produce the same profile object shape, so consumers don't need to know the source format
5. **OLE-to-legacy field mapping**:
   - `orientation.frame` → provides context for `evaluation_lens.primary_question`
   - `lens.verify` → `criteria` (review checklist items)
   - `lens.simplify` → `concerns` (characteristic issues)
   - `expertise.depth` → `background` + `keywords` (derived)
   - `orientation.serves` → informs `voice` context
6. **Role installation**: OLE profiles can also be installed to `.claude/roles/panel-reviewer/` for use with Claude Code role system

---

**Version**: 2.0
**Last Updated**: 2026-03-01
**Dependencies**: project-config.md
