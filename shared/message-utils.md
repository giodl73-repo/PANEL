# Message Utils — Standardized Output Formatting

Provides standardized output formatting for panel plugin commands. Replaces raw `console.log()` with semantic message types.

## Functions

```javascript
// ═══════════════════════════════════════════════════════════════
// Message utilities — standardized output formatting
// ═══════════════════════════════════════════════════════════════

let _msgSuppress = [];

/**
 * Initialize message utilities with plugin config.
 * Call this at the start of each command's main() function.
 *
 * @param {Object} config - Plugin config object
 * @param {Array<string>} config.suppressMessages - Message types to suppress
 */
function msgInit(config) {
    _msgSuppress = config?.suppressMessages || [];
}

/**
 * Output a formatted message with semantic type.
 *
 * @param {string} text - Message text
 * @param {string} type - Message type (see types below)
 */
function msg(text, type = 'info') {
    if (_msgSuppress.includes(type)) return;

    switch (type) {
        case 'header':
            console.log('');
            console.log(`═══ ${text} ═══`);
            console.log('');
            break;
        case 'stage':
            console.log('');
            console.log(`▶ ${text}`);
            console.log('');
            break;
        case 'success':
            console.log(`  ✓ ${text}`);
            break;
        case 'error':
            console.log(`  ✗ ${text}`);
            break;
        case 'warning':
            console.log(`  ⚠ ${text}`);
            break;
        case 'info':
            console.log(`  ${text}`);
            break;
        case 'item':
            console.log(`    • ${text}`);
            break;
        case 'subitem':
            console.log(`      - ${text}`);
            break;
        case 'complete':
            console.log(`  + ${text}`);
            break;
        case 'update':
            console.log(`  ~ ${text}`);
            break;
        case 'pending':
            console.log(`  ○ ${text}`);
            break;
        case 'fix':
            console.log(`  → ${text}`);
            break;
        case 'location':
            console.log(`  @ ${text}`);
            break;
        default:
            console.log(`  ${text}`);
    }
}

/**
 * Display a boxed title banner.
 *
 * @param {Array<string>} lines - Lines of text to display in box
 * @param {string} label - Optional label (defaults to first line)
 */
function msgBox(lines, label) {
    const width = 64;
    const title = label || lines[0] || 'PANEL';

    console.log('');
    console.log('╔' + '═'.repeat(width) + '╗');

    for (const line of lines) {
        const padded = (' ' + line).padEnd(width);
        console.log('║' + padded + ' ║');
    }

    console.log('╚' + '═'.repeat(width) + '╝');
    console.log('');
}

/**
 * Display a simple separator line.
 */
function msgSep() {
    if (_msgSuppress.includes('separator')) return;
    console.log('─'.repeat(64));
}
```

## Message Types

| Type | Symbol | Use Case |
|------|--------|----------|
| `header` | `═══` | Section headers |
| `stage` | `▶` | Stage/phase transitions |
| `success` | `✓` | Success confirmations |
| `error` | `✗` | Error messages |
| `warning` | `⚠` | Warnings |
| `info` | `  ` | General information |
| `item` | `•` | List items |
| `subitem` | `-` | Nested list items |
| `complete` | `+` | Completed actions |
| `update` | `~` | Modified items |
| `pending` | `○` | Pending items |
| `fix` | `→` | Applied fixes |
| `location` | `@` | File/path references |

## Usage Examples

```javascript
// @import ../shared/message-utils.md

async function main(args) {
    // Load config
    let pluginConfig = {};
    try {
        const cfgContent = await Read('.claude/panel.json');
        pluginConfig = JSON.parse(cfgContent);
    } catch {}

    // Initialize message utils
    msgInit(pluginConfig);

    // Display banner
    msgBox(['PANEL:PAPER', 'Per-paper review lifecycle'], 'PANEL:PAPER');

    // Output messages
    msg('Paper review lifecycle', 'header');
    msg('Loading paper state...', 'info');
    msg('State loaded successfully', 'success');
    msg('panel-review-methodology', 'item');
    msg('Stage: synthesis (round 1)', 'subitem');
    msg('3 files modified', 'complete');
}
```

## Suppression

Commands can suppress specific message types via `.claude/panel.json`:

```json
{
  "suppressMessages": ["item", "subitem", "separator"]
}
```

This is useful for:
- Reducing verbosity in CI/CD environments
- Focusing on errors/warnings only
- Customizing output for specific workflows
