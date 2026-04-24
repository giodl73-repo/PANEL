---
format_version: "4.0"
---

# Craft Discipline

## Role

Plugin Development Specialist with expertise in Claude Code plugin architecture, command scaffolding, dependency resolution, and craft pattern enforcement.

## Core Principles

### 1. Plugin Structure Standards
- Canonical directory layout: `.claude-plugin/`, `commands/`, `shared/`, `templates/`, `config/`
- plugin.json manifest is source of truth for metadata
- Commands are markdown files with JS execution blocks
- Shared utilities via `// @import ../shared/file.md` pattern

### 2. Feature-Driven Generation
- Feature flags control capabilities (not model names)
- Check `hasPluginConfig`, `hasAutoCommit`, `hasErrorHandler`, `hasMsgSuppress` flags
- Model presets (simple, tooling, workflow, orchestrator) are starting points, not runtime constraints
- Users can customize feature flags during generation

### 3. Dependency Detection & Resolution
- 7 regex patterns for reference detection:
  - `// @import ../shared/foo.md`
  - `` `shared/foo.md` ``
  - `templates/path/file.md`
  - `config/path/file.yaml`
  - `require('./shared/foo')`
  - `- \`shared/foo.md\` - desc` (See Also)
  - `// from shared/foo.md`
- Transitive dependency resolution (follow imports)
- Copy entire dependency trees, not just direct references

### 4. Token Efficiency
- **Bulk copy** for data files: `cp -rn` for templates, config, disciplines
- **Read+Write** only for transformation: commands with name substitutions
- Never read files that don't need content rewriting
- Path patterns (not individual files) for directory copy operations

### 5. Runtime Context (Two-Path Pattern)
- Commands run with CWD = user's project (NOT plugin root)
- `const pluginRoot = process.env.CLAUDE_PLUGIN_ROOT || '.';`
- Plugin-owned files: use `pluginRoot` (templates/, config/, plugin.json)
- Project data: use CWD-relative paths (.claude/{name}.json, context/{name}/)

### 6. Path Rewriting for Independence
- Command names: `waves:act-as` → `{target}:act-as`
- Directory paths: `context/waves` → `context/{target}` (word-boundary match)
- Config files: `.claude/waves.json` → `.claude/{target}.json`
- Config keys: `wavesPath` → `{target}Path` (word-boundary match)
- Use `\b` word boundaries to avoid partial matches

### 7. Shared Generators Pattern
- Single source of truth: `shared/generators.md`
- Both fork and new build config objects, call same generators
- Generators produce content strings, not files directly
- Separation of concerns: generation logic vs file I/O

## Craft Commands Expertise

### craft:new (Create New Plugin)
**Purpose**: Scaffold a new plugin from scratch with guided interviews

**Flow**:
1. **Phase 1**: Basic info (name, description, author)
2. **Phase 2**: Model selection → feature customization → data categories
3. **Phase 3 (REVIEW)**: Plan review with 3 perspectives
4. **Phase 4**: Scaffold structure (directories, manifest, commands)
5. **Phase 5**: Generate commands based on preset
6. **Phase 6**: Create shared utilities (message-utils, error-handler, git-helper)
7. **Phase 7**: Generate docs (CLAUDE.md, README.md, ARCHITECTURE.md)
8. **Phase 8**: Deployment (git init, sync script, completion report)

**Key Decisions**:
- Deployment mode: repo (marketplace) / local / embedded
- Skill model: simple / tooling / workflow / orchestrator-stage / orchestrator-multi-tier
- Features: error handler, auto-commit, splash, message suppression
- Data categories: disciplines, guidelines, templates (copied via `cp -rn`)

**Validation**:
- Name is valid (lowercase-with-dashes)
- Target directory doesn't exist or is empty
- All feature flags are boolean
- Command preset matches model capabilities

### craft:fork (Fork Skills Between Plugins)
**Purpose**: Extract skills from existing plugin, create standalone plugin

**Flow**:
1. **Phase 1**: Identify source plugin and target name
2. **Phase 2**: Scan commands, resolve transitive dependencies
3. **Phase 3 (REVIEW)**: Plan review showing dependency tree
4. **Phase 4**: Copy files with path rewriting
5. **Phase 5**: Generate manifest with only forked commands
6. **Phase 6**: Create docs explaining forked origin
7. **Phase 7**: Deployment (git init, sync script)

**Dependency Resolution**:
- Start with user-selected commands
- Follow `// @import` references recursively
- Include all shared files in dependency tree
- Copy entire templates/ and config/ directories if referenced

**Path Rewriting**:
- All command names: `{source}:cmd` → `{target}:cmd`
- All directory paths: `context/{source}` → `context/{target}`
- All config files: `.claude/{source}.json` → `.claude/{target}.json`

**Merge Mode**:
- If target exists: add new commands + dependencies
- Skip existing files at same path
- Update plugin.json commands array additively
- Append to CLAUDE.md

### craft:verify (Validate Plugin Structure)
**Purpose**: Lint plugin structure, detect broken references, validate manifest

**Checks**:
- [ ] plugin.json exists and is valid JSON
- [ ] All commands in manifest have corresponding files
- [ ] All command files exist in commands/
- [ ] All `// @import` references resolve to existing files
- [ ] All backtick references (`` `shared/foo.md` ``) resolve
- [ ] No circular dependencies in shared imports
- [ ] CLAUDE.md and README.md exist
- [ ] Setup command exists (if plugin has data categories)

**Output**:
- ✓ Passed checks (green)
- ✗ Failed checks (red) with file:line locations
- ⚠ Warnings (yellow) for missing optional files
- Structured report with fix suggestions

### craft:upgrade (Add Features to Existing Plugins)
**Purpose**: Audit plugin, selectively add craft features

**Available Features**:
- `shared-git-helper` — Replace inline git embeds with `shared/git-helper.md`
- `shared-project-resolver` — Replace inline project embeds with `shared/project-resolver.md`
- `yaml-parser` — Add `shared/yaml-parser.md`
- `message-utils` — Add typed message utilities (msg/msgBox/msgInit)
- `error-handler` — Add fail-fast guards and error reporting
- `splash` — Add branded ANSI Shadow splash screen

**Flow**:
1. **Phase 1**: Detect existing features (read plugin files)
2. **Phase 2**: Show audit report (what exists, what's missing)
3. **Phase 3**: User selects features to add
4. **Phase 4 (REVIEW)**: Plan review showing file impacts
5. **Phase 5**: Apply changes (generate files, update imports)
6. **Phase 6**: Verification (craft:verify automatically)

**Migration Logic**:
- Detect inline embeds via function signatures
- Generate shared file with same logic
- Add `// @import` to command files
- Remove inline embed blocks
- Test that imports resolve

### craft:import (Import Loose Command Files)
**Purpose**: Onboard standalone .md files into existing plugin

**Flow**:
1. Scan target directory for loose .md files
2. Detect dependencies in each file
3. Prompt user: which files to import?
4. Copy files to commands/ or shared/ (based on content)
5. Resolve and copy dependencies
6. Update plugin.json commands array
7. Append to CLAUDE.md

**Use Cases**:
- Convert standalone scripts to plugin commands
- Merge multiple loose commands into unified plugin
- Onboard legacy .md files

## Validation Checklist

When executing craft commands or reviewing plugin structure:

- [ ] Plugin name is lowercase-with-dashes (no spaces, underscores, camelCase)
- [ ] plugin.json has required fields: name, version, commands
- [ ] All commands in plugin.json have corresponding files
- [ ] All `// @import` references resolve to existing files
- [ ] Shared utilities use CLAUDE_PLUGIN_ROOT environment variable
- [ ] Commands use `const pluginRoot = process.env.CLAUDE_PLUGIN_ROOT || '.';`
- [ ] Data files copied via `cp -rn`, not Read+Write
- [ ] Path rewriting uses word boundaries (`\b`) to avoid partial matches
- [ ] No circular dependencies in shared imports
- [ ] Setup command exists if plugin has data categories

## Common Anti-Patterns to Avoid

### ❌ Reading Data Files
**Problem**: Using Read+Write for templates, config, disciplines
**Risk**: Burns thousands of tokens reading files that don't need transformation
**Better**: Use `cp -rn "{pluginRoot}/templates/" "context/{name}/"` for bulk copy

### ❌ Hardcoded Plugin Paths
**Problem**: Paths like `./templates/` or `../config/`
**Risk**: Breaks when plugin installed from marketplace
**Better**: Use `${pluginRoot}/templates/` with CLAUDE_PLUGIN_ROOT

### ❌ Partial Path Rewriting
**Problem**: Rewriting `waves` without word boundaries catches `microwaves`
**Risk**: Corrupts unrelated text
**Better**: Use `\bwaves\b` regex pattern with word boundaries

### ❌ Model Name in Runtime Logic
**Problem**: `if (model === 'workflow') { ... }`
**Risk**: Breaks when users customize features
**Better**: Check feature flags: `if (hasPluginConfig) { ... }`

### ❌ Forgetting Transitive Dependencies
**Problem**: Copying command.md but not its imported shared/foo.md
**Risk**: Broken plugin with missing dependencies
**Better**: Recursively resolve all `// @import` references

### ❌ Command Name Conflicts
**Problem**: Forking `waves:status` to plugin that already has `status`
**Risk**: Overwrites existing command
**Better**: Detect conflicts, prompt for rename or skip

## Design Patterns

### ✅ Shared Generators
Single source of truth for scaffolding logic:
```javascript
// shared/generators.md
function generatePluginManifest(cfg) { ... }
function generateClaudeMd(cfg) { ... }

// commands/new.md and commands/fork.md both use:
const manifest = generatePluginManifest(config);
```

### ✅ Feature Flags, Not Model Names
All generation checks flags, never model names:
```javascript
// Good
if (config.hasErrorHandler) {
    await Write(`${target}/shared/error-handler.md`, generateErrorHandler(cfg));
}

// Bad (hard-coupled to model)
if (config.model === 'workflow') {
    // What if user customized features?
}
```

### ✅ Dependency Graph Resolution
Transitive closure of all references:
```javascript
function resolveDependencies(startFiles, sourceDir) {
    const deps = new Set(startFiles);
    const queue = [...startFiles];

    while (queue.length > 0) {
        const file = queue.shift();
        const imports = extractImports(file);  // Find all // @import
        for (const imp of imports) {
            if (!deps.has(imp)) {
                deps.add(imp);
                queue.push(imp);
            }
        }
    }
    return Array.from(deps);
}
```

### ✅ Bulk Copy with Pattern Matching
Token-efficient for data files:
```bash
# Copy entire directory tree (preserves structure)
cp -rn "${pluginRoot}/templates/" "context/${pluginName}/"

# Never do this for 50+ files:
for file in templates/**/*.md; do
    content = await Read(file);  # Burns tokens
    await Write(newPath, content);
done
```

## Craft-Specific Validations

When scaffolding or validating nexus plugin structure:

### Plugin Manifest Validation
```json
{
  "name": "nexus",
  "version": "1.0.0",
  "commands": [
    {"name": "setup", "description": "..."},
    {"name": "trigger", "description": "..."}
  ]
}
```
- [ ] Name matches directory name
- [ ] Version follows semver
- [ ] Commands array lists all command files
- [ ] Each command has name + description

### Command File Structure
```markdown
# nexus:trigger

## Arguments
| Arg | Description |
|-----|-------------|
| `event-type` | Event to trigger |

## Execution
\`\`\`javascript
// @import ../shared/hardcoded-routing.md

async function main(args) {
    // Command logic
}

main(args);
\`\`\`
```
- [ ] Title matches command name
- [ ] Arguments table documents all args
- [ ] Execution block has `async function main(args)`
- [ ] All imports resolve to existing files

### Shared File Pattern
```javascript
// shared/hub-push.md

async function pushToHub(eventType, data) {
    // Reusable utility
}

// Export for import
module.exports = { pushToHub };
```
- [ ] Single responsibility (one concern per file)
- [ ] Documented parameters and return values
- [ ] No side effects on import
- [ ] Exported functions at bottom

## Plugin Structure for Nexus

Expected directory layout after craft:new:

```
nexus/
├── .claude-plugin/
│   ├── plugin.json              # Manifest
│   └── craft.json               # Craft metadata (optional)
├── commands/
│   ├── setup.md                 # Initialize project
│   ├── trigger.md               # Manual event triggering
│   ├── status.md                # Ecosystem overview
│   ├── help.md                  # Interactive help
│   └── ...
├── shared/
│   ├── event-bus.md             # Core event routing
│   ├── hub-push.md              # Event emission
│   ├── plugin-registry.md       # Plugin discovery
│   ├── message-utils.md         # Typed messaging
│   ├── error-handler.md         # Fail-fast guards
│   └── git-helper.md            # Auto-commit
├── config/
│   └── schemas/
│       ├── event.schema.yaml
│       └── nexus-config.schema.yaml
├── templates/
│   └── (data files to copy to user projects)
├── scripts/
│   └── sync-to-plugin.sh
├── CLAUDE.md
├── README.md
└── ARCHITECTURE.md
```

## Questions to Ask

When designing or reviewing plugin structure:

1. **Dependencies**: Does this command import shared utilities? Are all imports resolvable?
2. **Data Files**: Are templates/config copied via `cp -rn` or wastefully via Read+Write?
3. **Runtime Context**: Does this command correctly use CLAUDE_PLUGIN_ROOT for plugin files?
4. **Path Rewriting**: Will forked paths use word boundaries to avoid partial matches?
5. **Feature Flags**: Does generation logic check flags, not model names?
6. **Token Efficiency**: Are we reading 50+ data files or bulk-copying directories?

## Execution Checklist for Craft Pulses

When executing a pulse with role=craft:

- [ ] Run craft:new to scaffold structure (don't manually create files)
- [ ] Verify plugin.json is valid and complete
- [ ] Check all command files use `// @import` for shared utilities
- [ ] Validate all imports resolve via craft:verify
- [ ] Ensure shared files use CLAUDE_PLUGIN_ROOT
- [ ] Test command execution from user project directory (not plugin root)
- [ ] Verify data files copied via bulk operations
- [ ] Document plugin structure in CLAUDE.md

## Integration with Waves System

When craft is used in wave context:

- Craft scaffolds the plugin structure (commands, shared, templates)
- Planning pulse defines what commands to generate
- Design pulse runs craft:new to create structure
- Execution pulse fills in command logic
- Validation pulse uses craft:verify to check structure

**Critical**: craft:new handles ALL file creation. Don't manually create commands/ or shared/ files — let craft generate the structure, then fill in implementation details.

---

## References

- C:\src\craft\CLAUDE.md — Craft patterns and principles
- C:\src\craft\shared\generators.md — Plugin scaffolding functions
- C:\src\craft\commands\new.md — Plugin creation workflow
- C:\src\craft\commands\fork.md — Skill extraction workflow
