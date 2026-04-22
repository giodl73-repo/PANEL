---
name: panel:project
description: Switch between panel projects or list all projects
user-invocable: true
---

# panel:project — Project Switcher

Switch between configured panel projects or list all available projects in a monorepo.

## Purpose

Manage multi-project panel configurations in monorepo setups where multiple plugins each have their own research papers.

## Usage

### List All Projects

```bash
panel:project
```

Shows all configured projects with their research paths and current active project.

### Switch Project

```bash
panel:project <project-name>
```

Switch to a different project. All subsequent panel commands will use the new project's `researchPath`.

## Examples

```bash
# List all projects
panel:project

# Switch to craft research
panel:project craft-research

# Switch to waves research
panel:project waves-research

# Switch to panel's own research (meta)
panel:project panel-research
```

## Execution Flow

### List Mode (no arguments)

```javascript
// @import ../shared/project-config.md
// @import ../shared/message-utils.md

const projects = getAllProjects();
const currentConfig = loadProjectConfig();

msg('Panel Projects', 'header');
msgSep();

if (projects.length === 0) {
  msg('No projects configured.', 'warning');
  msg('Run panel:setup to initialize.', 'info');
  return;
}

msg(`Current: ${currentConfig.projectName}`, 'info');
msgSep();

for (const project of projects) {
  const active = project.name === currentConfig.projectName ? ' ★' : '';
  msg(`${project.name}${active}`, 'item');
  msg(`  Research: ${project.researchPath}`, 'subitem');
  if (project.targetPlugin) {
    msg(`  Plugin: ${project.targetPlugin}`, 'subitem');
  }
  if (project.description) {
    msg(`  ${project.description}`, 'subitem');
  }
}

msgSep();
msg(`Total: ${projects.length} project${projects.length === 1 ? '' : 's'}`, 'info');
```

### Switch Mode (with project name)

```javascript
// @import ../shared/project-config.md
// @import ../shared/message-utils.md
// @import ../shared/error-handler.md

const projectName = args[0];

if (!projectName) {
  throw error('E601', 'No project name provided', {
    recovery: 'Specify project name: panel:project <name>',
    command: 'panel:project'
  });
}

try {
  // Attempt to switch project
  const project = switchProject(projectName);

  msg('Project Switched', 'success');
  msgSep();
  msg(`Active project: ${projectName}`, 'info');
  msg(`Research path: ${project.researchPath}`, 'item');
  msg(`Client slug: ${project.clientSlug}`, 'item');

  if (project.targetPlugin) {
    msg(`Target plugin: ${project.targetPlugin}`, 'item');
  }

  msgSep();
  msg('Next steps:', 'info');
  msg('• Run panel:status to see papers in this project', 'item');
  msg('• Run panel:setup to initialize if needed', 'item');

} catch (error) {
  // Project not found - list available projects
  msg(`Project "${projectName}" not found`, 'error');
  msgSep();

  const projects = getAllProjects();
  msg('Available projects:', 'info');
  for (const project of projects) {
    msg(`• ${project.name}`, 'item');
  }

  msgSep();
  msg('Add a project by editing .claude/panel.json', 'info');

  throw error;
}
```

## Configuration Context

Projects are defined in `.claude/panel.json`:

```json
{
  "default": "craft-research",
  "projects": {
    "craft-research": {
      "panelPath": "context/panel/craft-research",
      "researchPath": "research/craft",
      "clientSlug": "craft-research",
      "projectName": "craft",
      "targetPlugin": "plugins/craft",
      "description": "Craft plugin research papers"
    },
    "waves-research": {
      "panelPath": "context/panel/waves-research",
      "researchPath": "research/waves",
      "clientSlug": "waves-research",
      "projectName": "waves",
      "targetPlugin": "plugins/waves",
      "description": "Waves plugin research papers"
    }
  }
}
```

## Impact of Switching

When you switch projects, all panel commands will:
- Read/write papers from the new project's `researchPath`
- Store context data in the new project's `panelPath`
- Use the new project's `clientSlug` for hub events

Commands affected:
- `panel:setup` - Creates papers in new researchPath
- `panel:review` - Reviews papers from new researchPath
- `panel:status` - Shows papers from new researchPath
- `panel:module` - Module-tier operations for new project/module
- `panel:board` - Board review across projects (sees all)
- `panel:author` - Authors papers in new researchPath
- `panel:import` - Imports papers to new researchPath

## Monorepo Workflow

Typical workflow in a monorepo:

```bash
# Work on craft research
panel:project craft-research
panel:setup panel-new-craft-paper "CHI 2026"
panel:review panel-new-craft-paper

# Switch to waves research
panel:project waves-research
panel:setup panel-new-waves-paper "CSCW 2026"
panel:review panel-new-waves-paper

# View all projects
panel:project
```

## Single-Project Mode

In standalone installations (non-monorepo), this command still works but typically shows only one project:

```bash
$ panel:project

Panel Projects
═══════════════════════════════════

Current: panel

panel ★
  Research: research
  Panel standalone research paper management

═══════════════════════════════════
Total: 1 project
```

## Error Handling

| Error | Code | Message | Recovery |
|-------|------|---------|----------|
| No project name | E601 | No project name provided | Specify project: `panel:project <name>` |
| Project not found | E602 | Project not found | Lists available projects |
| No config file | E100 | Panel not configured | Run `panel:setup` first |

## Auto-Commit

This command does not auto-commit. Switching projects is a session-level operation that doesn't modify files.

## See Also

- `panel:setup` - Initialize panel for a project
- `panel:status` - View papers in current project
- `probe:project` - Similar command for probe
- `waves:project` - Similar command for waves
