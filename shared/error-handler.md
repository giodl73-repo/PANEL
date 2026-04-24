# Error Handler — Standardized Error Reporting

Provides standardized error handling for panel commands with semantic error codes and helpful recovery suggestions.

## Error Codes

```javascript
const ERROR_CODES = {
  // File & State Errors (E100-E199)
  E100: 'FILE_NOT_FOUND',
  E101: 'INVALID_YAML',
  E102: 'MISSING_REQUIRED_FIELD',
  E103: 'STATE_FILE_CORRUPT',
  E104: 'TEMPLATE_NOT_FOUND',

  // Stage & Workflow Errors (E200-E299)
  E200: 'INVALID_STAGE',
  E201: 'GATE_NOT_MET',
  E202: 'STAGE_PREREQUISITE_MISSING',
  E203: 'ROUND_CONFLICT',
  E204: 'PAPER_NOT_INITIALIZED',

  // Review Errors (E300-E399)
  E300: 'INSUFFICIENT_REVIEWERS',
  E301: 'REVIEWER_NOT_FOUND',
  E302: 'REVIEW_INCOMPLETE',
  E303: 'SYNTHESIS_FAILED',
  E304: 'SCORE_VALIDATION_FAILED',

  // Module & Board Errors (E400-E499)
  E400: 'MODULE_NOT_FOUND',
  E401: 'PANEL_REVIEW_MISSING',
  E402: 'BOARD_NOT_READY',
  E403: 'INSUFFICIENT_MODULES',
  E404: 'CROSS_MODULE_CONFLICT',

  // Git & Sync Errors (E500-E599)
  E500: 'GIT_OPERATION_FAILED',
  E501: 'SYNC_CONFLICT',
  E502: 'UNCOMMITTED_CHANGES',
  E503: 'REMOTE_OUT_OF_SYNC',

  // Configuration Errors (E600-E699)
  E600: 'INVALID_CONFIG',
  E601: 'MISSING_VENUE',
  E602: 'INVALID_SCORING_RUBRIC',
  E603: 'TEMPLATE_CONFIG_MISMATCH',
};
```

## Functions

### throwError(code, context)

Throws a standardized error with helpful recovery suggestions.

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `code` | string | yes | Error code from ERROR_CODES (e.g., 'E200') |
| `context` | object | no | Additional context for error message |

#### Behavior

```
1. Look up error code in ERROR_CODES
2. Build error message with:
   - Error code and name
   - Contextual details from context object
   - Recovery suggestion based on error type
3. Output formatted error via msg() from message-utils.md
4. Return error object (don't throw - allows caller to decide)
```

### recoverySuggestion(code, context)

Provides helpful recovery suggestions based on error code.

#### Mapping

| Code Range | Suggestion |
|------------|------------|
| E100-E199 | Check file paths, verify YAML syntax, ensure required fields present |
| E200-E299 | Review stage requirements in `panel:help stages`, check gate conditions |
| E300-E399 | Run `panel:reviewers` to verify reviewer database, check review completeness |
| E400-E499 | Run `panel:status` to see module state, ensure panels are complete |
| E500-E599 | Check git status, resolve conflicts, ensure repo is clean |
| E600-E699 | Verify `.claude/panel.json`, check venue list, validate config/scoring.yaml |

## Usage

```javascript
// @import ../shared/message-utils.md
// @import ../shared/error-handler.md

async function main(args) {
    // ... command logic ...

    // Validate stage
    const validStages = ['draft', 'panel', 'synthesis', 'revision', 'recheck', 'ready', 'submit', 'accepted'];
    if (!validStages.includes(currentStage)) {
        const err = throwError('E200', {
            stage: currentStage,
            validStages: validStages.join(', ')
        });
        return;
    }

    // Check gate condition
    if (stage === 'panel' && reviewCount < 5) {
        const err = throwError('E300', {
            reviewCount,
            required: 5,
            paper: paperName
        });
        msg('Run panel:review again to generate remaining reviews', 'info');
        return;
    }

    // File not found
    try {
        const content = await Read(`${paperDir}/_panel.yaml`);
    } catch (e) {
        const err = throwError('E100', {
            file: `${paperDir}/_panel.yaml`,
            command: 'panel:review'
        });
        msg('Run panel:setup <paper-name> to initialize the paper', 'fix');
        return;
    }
}
```

## Error Message Format

```
  ✗ Error E200: INVALID_STAGE
  ✗ Stage 'reveiw' is not valid
  ✗ Valid stages: draft, panel, synthesis, revision, recheck, ready, submit, accepted

  → Run panel:help stages for stage requirements
```

## Integration with message-utils

Error handler uses `msg(text, 'error')` for error output and `msg(text, 'fix')` for recovery suggestions, ensuring consistent formatting across the plugin.

## Reporting

For errors that may indicate bugs in the plugin, include a footer:

```
If you believe this is a plugin error, please report it:
→ https://github.com/giodl_microsoft/panel/issues
```

Include this for:
- E103 (STATE_FILE_CORRUPT)
- E303 (SYNTHESIS_FAILED)
- E404 (CROSS_MODULE_CONFLICT)
- E603 (TEMPLATE_CONFIG_MISMATCH)
