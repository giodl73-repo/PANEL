# Module Utils

Shared utilities for MODULE.md parsing, track operations, and cross-module track
resolution. Used by panel:module, panel:curate, panel:board, and panel:author.

---

## Core Data Structures

```javascript
// Track — causal chain within or across modules
Track {
    name: string,            // slug, e.g. "methodology"
    theme: string,           // 1 sentence: what causal question does this chain answer?
    papers: string[],        // ordered slugs — the causal chain
    arc: string,             // LaTeX series arc paragraph (with actual numbers)
    modules: string[],       // which modules this track spans (1+ modules)
    score: number | null,    // from REVIEW_PANEL.md — null until convened
    chain_status: 'strong' | 'partial' | 'weak' | 'broken'
}

// Paper assignment
PaperTrackEntry {
    paper: string,           // slug
    tracks: string[],        // track names this paper belongs to
    primary_number: string,  // the quantified finding this paper must produce
    chain_positions: Record<string, number>  // track → position in that track's chain
}

// Module — the full MODULE.md parsed
Module {
    name: string,
    theme: string,
    tracks: Track[],
    papers: PaperTrackEntry[],
    module_arc: string,      // cross-track paragraph
    created: string
}
```

---

## Functions

### `parseModule(moduleFilePath)`

Parse `MODULE.md` into a Module object.

```javascript
function parseModule(moduleFilePath) {
    const content = Read(moduleFilePath);
    if (!content) throw new Error(`MODULE.md not found: ${moduleFilePath}`);

    // Parse tracks from ## Track sections
    // Parse paper table from | Paper | Tracks | Primary Number | Status | Venue |
    // Parse module arc from ## Module Arc section
    // Return Module object
}
```

### `getTrackPapers(module, trackName)`

Return papers for a track in chain order.

```javascript
function getTrackPapers(module, trackName) {
    const track = module.tracks.find(t => t.name === trackName);
    if (!track) throw new Error(`Track not found: ${trackName}`);
    return track.papers; // ordered slugs
}
```

### `getPaperTracks(module, paperSlug)`

Return track names a paper belongs to.

```javascript
function getPaperTracks(module, paperSlug) {
    const entry = module.papers.find(p => p.paper === paperSlug);
    return entry ? entry.tracks : [];
}
```

### `getOrphanPapers(module, researchDir)`

Return papers in researchDir that have no track assignment in MODULE.md.

```javascript
async function getOrphanPapers(module, researchDir) {
    const papers = await glob(`${researchDir}/panel-*/_panel.yaml`);
    const paperSlugs = papers.map(p => path.basename(path.dirname(p)));
    const assigned = module.papers.map(p => p.paper);
    return paperSlugs.filter(s => !assigned.includes(s));
}
```

### `getArcParagraph(module, trackName, paperSlug)`

Return the series arc paragraph for a paper in a specific track.
Used by panel:author to inject into Introduction.

```javascript
function getArcParagraph(module, trackName, paperSlug) {
    const track = module.tracks.find(t => t.name === trackName);
    if (!track || !track.arc) return null;

    // The arc paragraph is shared across all papers in the track.
    // Each paper gets the same text — it describes the whole track program.
    return track.arc;
}
```

### `validateChain(module, trackName)`

Validate a track's causal chain. Returns chain_status.

```javascript
function validateChain(module, trackName) {
    const track = module.tracks.find(t => t.name === trackName);
    if (!track) return 'broken';
    if (track.papers.length < 2) return 'broken';     // single-paper track
    if (!track.arc) return 'weak';                     // no arc written yet
    if (!track.theme) return 'partial';
    return 'strong';
}
```

### `resolveModuleFile(researchDir)`

Find MODULE.md in a research directory. Returns null if not found.

```javascript
function resolveModuleFile(researchDir) {
    const candidate = path.join(researchDir, 'MODULE.md');
    return exists(candidate) ? candidate : null;
}
```

---

## Cross-Module Track Resolution

Tracks can span multiple modules. A track defined in module-alpha may continue
in module-beta — showing integration between modules.

### `discoverCrossModuleTracks(allProjects, cwd)`

Scan all module MODULE.md files and identify tracks that appear in multiple modules.

```javascript
async function discoverCrossModuleTracks(allProjects, cwd) {
    const trackIndex = {};  // trackName → [{ module, papers, arc }]

    for (const project of allProjects) {
        const researchDir = path.join(cwd, project.researchPath);
        const moduleFile = resolveModuleFile(researchDir);
        if (!moduleFile) continue;

        const module = parseModule(moduleFile);
        for (const track of module.tracks) {
            if (!trackIndex[track.name]) trackIndex[track.name] = [];
            trackIndex[track.name].push({
                module: project.projectName,
                papers: track.papers,
                arc: track.arc,
                score: track.score
            });
        }
    }

    // Cross-module tracks: appear in 2+ modules
    const crossModuleTracks = Object.entries(trackIndex)
        .filter(([_, entries]) => entries.length > 1)
        .map(([name, entries]) => ({
            name,
            modules: entries.map(e => e.module),
            alignment: assessTrackAlignment(entries)
        }));

    return { trackIndex, crossModuleTracks };
}
```

### `assessTrackAlignment(trackEntries)`

For a track that appears in multiple modules, assess how well it aligns.

```javascript
function assessTrackAlignment(entries) {
    // aligned: same chain logic, arcs compatible
    // subset: one module's track is a specialization of another
    // divergent: same name, different causal direction
    // parallel: independent treatments of the same theme

    if (entries.length < 2) return 'unique';

    // Compare arc paragraphs for semantic overlap
    // Compare paper themes for causal compatibility
    // Return alignment status
    const arcSimilarity = compareArcs(entries.map(e => e.arc));
    if (arcSimilarity > 0.8) return 'aligned';
    if (arcSimilarity > 0.5) return 'subset';
    if (arcSimilarity > 0.2) return 'parallel';
    return 'divergent';
}
```

### Cross-module track status values

| Status | Meaning | Board action |
|--------|---------|--------------|
| `aligned` | Same track, compatible chains across modules | Note as program strength |
| `subset` | One module's track specializes the other | Good — shows depth |
| `parallel` | Independent treatments of same theme | PP/B item: should they cite each other? |
| `divergent` | Same name, conflicting logic | B1 item: reconcile or rename |
| `unique` | Track only in one module | Fine — no cross-module implication |

---

## MODULE.md Update Operations

### `addPaperToTrack(moduleFilePath, paperSlug, trackName, position)`

Add a paper to a track at a specific chain position. Updates the `## Papers` table
and the track's `**Chain**` line.

### `addTrack(moduleFilePath, track)`

Append a new track definition to MODULE.md.

### `updateTrackScore(moduleFilePath, trackName, score)`

Write track score into MODULE.md Track Coverage table (updated by panel:module review).

### `updateTrackArc(moduleFilePath, trackName, arc)`

Update the series arc paragraph for a track (updated after quantification contracts filled).

---

## Usage in Commands

### panel:author

```javascript
const moduleFile = resolveModuleFile(researchDir);
if (moduleFile) {
    const module = parseModule(moduleFile);
    const paperTracks = getPaperTracks(module, paperSlug);

    if (paperTracks.length === 0) {
        msg(`⚠ "${paperSlug}" has no track assignment in MODULE.md`, 'warning');
        msg(`  Run: panel:module --assign ${paperSlug} <track>`, 'item');
    }

    // Inject arc paragraphs for each track into plan context
    const arcs = paperTracks.map(t => getArcParagraph(module, t, paperSlug)).filter(Boolean);
}
```

### panel:module review

```javascript
const module = parseModule(resolveModuleFile(researchDir));
const { crossModuleTracks } = await discoverCrossModuleTracks(allProjects, cwd);

// Assess tracks, generate PP items tagged to tracks
// Update MODULE.md track scores after assessment
for (const track of module.tracks) {
    const score = assessTrack(track, papers);
    updateTrackScore(moduleFile, track.name, score);
}
```

### panel:board

```javascript
const { trackIndex, crossModuleTracks } = await discoverCrossModuleTracks(allProjects, cwd);

// Surface cross-module track alignment in REVIEW_BOARD.md
// Generate B items for divergent tracks
// Note aligned and subset tracks as program strengths
```
