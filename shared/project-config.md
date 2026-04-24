# Project Config Loader

Multi-project configuration loader for panel. Supports both standalone mode and monorepo mode.

## Purpose

Load the active project configuration from `.claude/panel.json` to determine:
- `researchPath` - Root for all research content (legacy fallback)
- `papersPath` - Where markdown quick-research papers live (default: `{researchPath}/papers`)
- `publicationsPath` - Where formal LaTeX publications live (default: `{researchPath}/publications`)
- `panelPath` - Where panel context data is stored
- `clientSlug` - Client identifier for hub integration
- `projectName` - Human-readable project name

### Content Types

| Type | Path | Format | Purpose |
|------|------|--------|---------|
| **paper** | `papersPath` | Markdown | Quick research notes, position papers, working documents |
| **publication** | `publicationsPath` | LaTeX | Formal academic papers with sections, PDF, full review lifecycle |

Papers and publications both participate in module tracks. A paper can be promoted
to a publication via `panel:paper promote`.

## Configuration Structure

### Single-Project Mode (Legacy/Standalone)

```json
{
  "default": "panel",
  "projects": {
    "panel": {
      "researchPath": "research",
      "papersPath": "research/papers",
      "publicationsPath": "research/publications",
      "panelPath": "context/panel/panel-dev",
      "clientSlug": "panel-dev",
      "projectName": "panel"
    }
  }
}
```

### Multi-Project Mode (Monorepo)

```json
{
  "default": "craft-research",
  "projects": {
    "craft-research": {
      "researchPath": "research/craft",
      "papersPath": "research/craft/papers",
      "publicationsPath": "research/craft/publications",
      "panelPath": "context/panel/craft-research",
      "clientSlug": "craft-research",
      "projectName": "craft",
      "description": "Craft plugin research papers and publications"
    },
    "waves-research": {
      "researchPath": "research/waves",
      "papersPath": "research/waves/papers",
      "publicationsPath": "research/waves/publications",
      "panelPath": "context/panel/waves-research",
      "clientSlug": "waves-research",
      "projectName": "waves",
      "description": "Waves plugin research"
    }
  }
}
```

### Backward Compatibility

`researchPath` alone (no `papersPath`/`publicationsPath`) is still valid.
Defaults: `papersPath = researchPath`, `publicationsPath = researchPath`.
Existing installations continue to work unchanged.

## Functions

### loadProjectConfig()

Load the active project configuration.

**Returns:**
```javascript
{
  projectName: string,
  researchPath: string,        // root fallback (legacy)
  papersPath: string,          // markdown quick-research papers
  publicationsPath: string,    // formal LaTeX publications
  panelPath: string,
  pluginReviewersPath: string, // ${pluginRoot}/.roles/panel-reviewer (source of truth)
  localReviewersPath: string,  // .roles/panel-reviewer (user extensions only)
  clientSlug: string,
  description: string,
  configPath: string,          // Path to .claude/panel.json
  pluginRoot: string           // Plugin installation path (CLAUDE_PLUGIN_ROOT)
}
```

**Implementation:**

```javascript
function loadProjectConfig() {
  const configPath = path.join(process.cwd(), '.claude', 'panel.json');

  // Check if config exists
  if (!fs.existsSync(configPath)) {
    throw new Error('Panel not configured. Run panel:setup first.');
  }

  const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

  // Get default project name
  const defaultProject = config.default || 'panel';

  // Check if projects object exists (multi-project mode)
  // Resolve pluginRoot: cached value in config takes priority, then env var
  const pluginRoot = config.pluginRoot || process.env.CLAUDE_PLUGIN_ROOT || null;

  // Plugin's .roles/panel-reviewer is the authoritative source (read via pluginRoot).
  // Local .roles/panel-reviewer is optional — only for user extensions.
  const pluginReviewersPath = pluginRoot ? `${pluginRoot}/.roles/panel-reviewer` : null;
  const localReviewersPath = '.roles/panel-reviewer';

  if (config.projects && config.projects[defaultProject]) {
    const project = config.projects[defaultProject];
    const researchPath = project.researchPath || 'research';

    return {
      projectName: project.projectName || defaultProject,
      researchPath,
      papersPath: project.papersPath || `${researchPath}/papers`,
      publicationsPath: project.publicationsPath || `${researchPath}/publications`,
      panelPath: project.panelPath || `context/panel/${defaultProject}`,
      pluginReviewersPath,
      localReviewersPath,
      clientSlug: project.clientSlug || defaultProject,
      description: project.description || '',
      configPath,
      pluginRoot
    };
  }

  // Legacy mode (no projects object) - use defaults
  const researchPath = 'research';
  return {
    projectName: config.projectName || 'panel',
    researchPath,
    papersPath: config.papersPath || `${researchPath}/papers`,
    publicationsPath: config.publicationsPath || `${researchPath}/publications`,
    panelPath: `context/panel/${defaultProject}`,
    pluginReviewersPath,
    localReviewersPath,
    clientSlug: config.clientSlug || 'panel-dev',
    description: '',
    configPath,
    pluginRoot
  };
}
```

### getAllProjects()

Get all configured projects.

**Returns:**
```javascript
[
  {
    name: string,
    projectName: string,
    researchPath: string,
    panelPath: string,
    clientSlug: string,
    description: string
  },
  ...
]
```

**Implementation:**

```javascript
function getAllProjects() {
  const configPath = path.join(process.cwd(), '.claude', 'panel.json');

  if (!fs.existsSync(configPath)) {
    return [];
  }

  const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

  if (!config.projects) {
    // Legacy mode - return single project
    return [{
      name: config.default || 'panel',
      projectName: config.projectName || 'panel',
      researchPath: 'research',
      panelPath: `context/panel/${config.default || 'panel'}`,
      clientSlug: config.clientSlug || 'panel-dev',
      description: ''
    }];
  }

  // Multi-project mode
  return Object.entries(config.projects).map(([name, project]) => ({
    name,
    projectName: project.projectName || name,
    researchPath: project.researchPath || 'research',
    panelPath: project.panelPath || `context/panel/${name}`,
    clientSlug: project.clientSlug || name,
    description: project.description || ''
  }));
}
```

### switchProject(projectName)

Switch the default project.

**Parameters:**
- `projectName` - Name of the project to switch to

**Implementation:**

```javascript
function switchProject(projectName) {
  const configPath = path.join(process.cwd(), '.claude', 'panel.json');

  if (!fs.existsSync(configPath)) {
    throw new Error('Panel not configured. Run panel:setup first.');
  }

  const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

  // Validate project exists
  if (!config.projects || !config.projects[projectName]) {
    throw new Error(`Project "${projectName}" not found in configuration.`);
  }

  // Update default
  config.default = projectName;

  // Write back
  fs.writeFileSync(configPath, JSON.stringify(config, null, 2), 'utf8');

  return config.projects[projectName];
}
```

## Usage in Commands

### In setup.md

```javascript
// @import ../shared/project-config.md

// Load config to get researchPath
const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);

// Setup research directory
if (!fs.existsSync(researchDir)) {
  fs.mkdirSync(researchDir, { recursive: true });
}
```

### In review.md

```javascript
// @import ../shared/project-config.md

// Load config to get researchPath
const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);

// Find paper
const paperPath = path.join(researchDir, paperName);
```

## Backward Compatibility

The loader supports both legacy (single-project) and new (multi-project) modes:

1. **Legacy mode**: No `projects` object - uses defaults from top-level config
2. **Multi-project mode**: Has `projects` object - uses active project from `default` field

This ensures existing standalone panel installations continue to work without changes.

## Error Handling

- **Missing config**: Throws error with message to run `panel:setup`
- **Invalid project**: Throws error listing available projects
- **Missing researchPath**: Falls back to `"research"` default
