# YAML Parser — Simple YAML Reading

Provides lightweight YAML parsing for panel configuration and state files. Handles the subset of YAML used by panel without requiring external dependencies.

## Supported Features

- **Scalars**: Strings, numbers, booleans, null
- **Lists**: Array syntax with `- item` format
- **Maps**: Key-value pairs with `key: value` format
- **Nested structures**: Indentation-based nesting
- **Comments**: Lines starting with `#`
- **Multi-line strings**: Pipe (`|`) and fold (`>`) syntax (basic support)

## Not Supported

- **Anchors and aliases**: `&anchor` and `*alias`
- **Complex keys**: Only simple string keys
- **Advanced types**: Timestamps, binary, custom types
- **Merge keys**: `<<:` syntax

## parseSimpleYaml(content)

Parse YAML content into JavaScript object.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `content` | string | yes | YAML content to parse |

### Returns

- **Object** — Parsed JavaScript object
- **null** — If parsing fails

### Behavior

```
1. Split content into lines
2. Track indentation levels to build structure
3. Parse each line:
   - Skip comments (# prefix)
   - Detect lists (- prefix)
   - Detect maps (key: value)
   - Handle nested structures via indentation
4. Build JavaScript object recursively
5. Return parsed object or null on error
```

### Example Usage

```javascript
// @import ../shared/yaml-parser.md

const yamlContent = `
name: panel-review-methodology
venue: CHI 2026
stage: synthesis
round: 1
reviewers:
  - name: Percy Liang
    score: 3
  - name: Daphne Koller
    score: 4
p1_items:
  - Statistical validation needs improvement
  - Missing competitive baselines
`;

const state = parseSimpleYaml(yamlContent);

console.log(state.name);           // "panel-review-methodology"
console.log(state.venue);          // "CHI 2026"
console.log(state.reviewers.length); // 2
console.log(state.reviewers[0].name); // "Percy Liang"
console.log(state.p1_items[0]);    // "Statistical validation needs improvement"
```

## stringifySimpleYaml(obj, indent)

Convert JavaScript object back to YAML format.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `obj` | object | yes | JavaScript object to serialize |
| `indent` | number | no | Starting indentation level (default: 0) |

### Returns

- **string** — YAML-formatted content

### Example Usage

```javascript
const state = {
  name: 'panel-review-methodology',
  venue: 'CHI 2026',
  stage: 'synthesis',
  round: 1,
  reviewers: [
    { name: 'Percy Liang', score: 3 },
    { name: 'Daphne Koller', score: 4 }
  ],
  p1_items: [
    'Statistical validation needs improvement',
    'Missing competitive baselines'
  ]
};

const yamlContent = stringifySimpleYaml(state);

// Output:
// name: panel-review-methodology
// venue: CHI 2026
// stage: synthesis
// round: 1
// reviewers:
//   - name: Percy Liang
//     score: 3
//   - name: Daphne Koller
//     score: 4
// p1_items:
//   - Statistical validation needs improvement
//   - Missing competitive baselines
```

## Error Handling

Parsing errors are silent — `parseSimpleYaml()` returns `null` on failure. For robust error handling, use try/catch and check result:

```javascript
const state = parseSimpleYaml(content);
if (!state) {
    const err = throwError('E101', {
        file: panelStateFile,
        reason: 'Invalid YAML syntax'
    });
    msg('Check file for syntax errors (indentation, colons, dashes)', 'fix');
    return;
}
```

## Integration with state-loader.md

The state-loader.md uses this parser for reading and writing `_panel.yaml` files:

```javascript
// Read state
async function loadPanelState(paperDir) {
    try {
        const content = await Read(`${paperDir}/_panel.yaml`);
        const state = parseSimpleYaml(content);
        if (!state) throw new Error('Invalid YAML');
        return state;
    } catch (e) {
        return null;
    }
}

// Write state
async function savePanelState(paperDir, state) {
    const content = stringifySimpleYaml(state);
    await Write(`${paperDir}/_panel.yaml`, content);
}
```

## Performance

This parser is optimized for small files (< 100 KB). For larger files or more complex YAML:

- Consider using Claude's built-in YAML understanding
- Split large files into smaller focused files
- Use JSON for machine-generated state (if human-readability not required)

## Testing

Test with various YAML structures:

```javascript
// Empty document
const empty = parseSimpleYaml('');  // null

// Simple scalar
const scalar = parseSimpleYaml('name: test');  // { name: 'test' }

// List
const list = parseSimpleYaml(`
items:
  - one
  - two
  - three
`);  // { items: ['one', 'two', 'three'] }

// Nested maps
const nested = parseSimpleYaml(`
paper:
  name: test
  venue: CHI
  reviewers:
    - Percy
    - Daphne
`);
// { paper: { name: 'test', venue: 'CHI', reviewers: ['Percy', 'Daphne'] } }
```

## Migration Notes

If migrating from hand-rolled YAML parsing:

1. Replace regex-based parsing with `parseSimpleYaml(content)`
2. Replace string building with `stringifySimpleYaml(obj)`
3. Add error handling for `null` returns
4. Test with existing `.yaml` files to ensure compatibility
