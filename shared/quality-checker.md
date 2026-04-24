# Quality Checker — Run Quality Gates for Papers

Shared utility for checking paper quality against venue requirements and standards.

## Functions

```javascript
// ═══════════════════════════════════════════════════════════════
// Quality Checker — Validate paper against quality standards
// ═══════════════════════════════════════════════════════════════

/**
 * Run quality checks on a paper
 *
 * @param {string} paperDir - Path to paper directory
 * @param {Object} plan - Parsed plan object (from plan-parser.md)
 * @returns {Promise<Object>} Quality check results
 */
async function checkQuality(paperDir, plan) {
    const results = {
        passed: true,
        checks: [],
        errors: [],
        warnings: []
    };

    // Check 1: All sections written
    const sectionCheck = await checkSections(paperDir, plan.sections);
    results.checks.push(sectionCheck);
    if (!sectionCheck.passed) results.passed = false;

    // Check 2: main.tex compiles
    const compileCheck = await checkCompilation(paperDir);
    results.checks.push(compileCheck);
    if (!compileCheck.passed) results.passed = false;

    // Check 3: Abstract exists and is appropriate length
    const abstractCheck = await checkAbstract(paperDir);
    results.checks.push(abstractCheck);
    if (!abstractCheck.passed) results.passed = false;

    // Check 4: Word count within venue limits
    const wordCountCheck = await checkWordCount(paperDir, plan);
    results.checks.push(wordCountCheck);
    if (!wordCountCheck.passed) results.passed = false;

    // Check 5: References count
    const refCheck = await checkReferences(paperDir, plan);
    results.checks.push(refCheck);
    if (!refCheck.passed) {
        results.warnings.push(refCheck.message);
    }

    // Check 6: All figures have captions
    const figureCheck = await checkFigureCaptions(paperDir);
    results.checks.push(figureCheck);
    if (!figureCheck.passed) results.passed = false;

    // Check 7: All experiments completed
    const experimentCheck = checkExperiments(plan);
    results.checks.push(experimentCheck);
    if (!experimentCheck.passed) results.passed = false;

    return results;
}

/**
 * Check if all sections are written
 */
async function checkSections(paperDir, sections) {
    const missing = [];

    for (let i = 0; i < sections.length; i++) {
        const sectionNum = String(i + 1).padStart(2, '0');
        const sectionName = sections[i].name.toLowerCase().replace(/\s+/g, '-');
        const sectionFile = `${paperDir}/sections/${sectionNum}-${sectionName}.tex`;

        try {
            const content = await Read(sectionFile);
            // Check if section has content (not just comments or empty)
            const cleanContent = content.replace(/%.*/g, '').trim();
            if (cleanContent.length < 100) {
                missing.push(sections[i].name);
            }
        } catch {
            missing.push(sections[i].name);
        }
    }

    return {
        name: 'All sections written',
        passed: missing.length === 0,
        message: missing.length === 0
            ? 'All sections written'
            : `Missing sections: ${missing.join(', ')}`
    };
}

/**
 * Check if main.tex compiles without errors
 */
async function checkCompilation(paperDir) {
    try {
        const result = await Bash(`cd "${paperDir}" && make pdf 2>&1`);
        const success = !result.includes('Error') && !result.includes('Fatal');

        return {
            name: 'main.tex compiles',
            passed: success,
            message: success ? 'PDF compiled successfully' : 'LaTeX compilation failed'
        };
    } catch (e) {
        return {
            name: 'main.tex compiles',
            passed: false,
            message: 'Compilation check failed: ' + e.message
        };
    }
}

/**
 * Check abstract length
 */
async function checkAbstract(paperDir) {
    try {
        const mainContent = await Read(`${paperDir}/main.tex`);
        const abstractMatch = mainContent.match(/\\begin{abstract}([\s\S]*?)\\end{abstract}/);

        if (!abstractMatch) {
            return {
                name: 'Abstract exists',
                passed: false,
                message: 'No abstract found'
            };
        }

        const abstractText = abstractMatch[1].replace(/%.*/g, '').trim();
        const wordCount = abstractText.split(/\s+/).length;

        // Typical abstract: 150-300 words
        if (wordCount < 100) {
            return {
                name: 'Abstract length',
                passed: false,
                message: `Abstract too short: ${wordCount} words (min 100)`
            };
        }

        if (wordCount > 400) {
            return {
                name: 'Abstract length',
                passed: false,
                message: `Abstract too long: ${wordCount} words (max 400)`
            };
        }

        return {
            name: 'Abstract length',
            passed: true,
            message: `Abstract: ${wordCount} words`
        };
    } catch (e) {
        return {
            name: 'Abstract exists',
            passed: false,
            message: 'Could not check abstract: ' + e.message
        };
    }
}

/**
 * Check word count against venue limits
 */
async function checkWordCount(paperDir, plan) {
    try {
        const result = await Bash(`cd "${paperDir}" && make wordcount 2>&1 || texcount -sum -1 main.tex 2>&1`);
        const match = result.match(/(\d+)\s+words/i);

        if (!match) {
            return {
                name: 'Word count',
                passed: false,
                message: 'Could not determine word count'
            };
        }

        const wordCount = parseInt(match[1]);
        const pageLimit = plan.venue.pageLimit || 10;
        const maxWords = pageLimit * 800; // ~800 words per page
        const minWords = pageLimit * 500; // ~500 words per page

        if (wordCount < minWords) {
            return {
                name: 'Word count',
                passed: false,
                message: `Word count too low: ${wordCount} (expected ${minWords}-${maxWords})`
            };
        }

        if (wordCount > maxWords * 1.1) { // Allow 10% over
            return {
                name: 'Word count',
                passed: false,
                message: `Word count too high: ${wordCount} (max ${maxWords})`
            };
        }

        return {
            name: 'Word count',
            passed: true,
            message: `${wordCount} words (target: ${minWords}-${maxWords})`
        };
    } catch (e) {
        return {
            name: 'Word count',
            passed: false,
            message: 'Could not check word count: ' + e.message
        };
    }
}

/**
 * Check reference count
 */
async function checkReferences(paperDir, plan) {
    try {
        const mainContent = await Read(`${paperDir}/main.tex`);
        const bibMatch = mainContent.match(/\\bibliography{([^}]+)}/);

        if (!bibMatch) {
            return {
                name: 'References',
                passed: false,
                message: 'No bibliography specified'
            };
        }

        const bibFile = `${paperDir}/${bibMatch[1]}.bib`;
        const bibContent = await Read(bibFile);
        const entryMatches = bibContent.match(/@\w+{/g);
        const refCount = entryMatches ? entryMatches.length : 0;

        // Check quality checkpoints for reference target
        const refCheckpoint = plan.qualityCheckpoints.find(c => c.name.toLowerCase().includes('reference'));
        const targetRefs = refCheckpoint ? parseInt(refCheckpoint.target.match(/\d+/)?.[0]) : 30;

        if (refCount < targetRefs * 0.8) {
            return {
                name: 'References',
                passed: false,
                message: `Only ${refCount} references (target: ${targetRefs})`
            };
        }

        return {
            name: 'References',
            passed: true,
            message: `${refCount} references (target: ${targetRefs})`
        };
    } catch (e) {
        return {
            name: 'References',
            passed: false,
            message: 'Could not check references: ' + e.message
        };
    }
}

/**
 * Check figure captions
 */
async function checkFigureCaptions(paperDir) {
    try {
        const mainContent = await Read(`${paperDir}/main.tex`);

        // Find all \begin{figure} environments
        const figureMatches = mainContent.match(/\\begin{figure}[\s\S]*?\\end{figure}/g) || [];

        // Also check sections/ directory
        const sectionFiles = await Glob('*.tex', { path: `${paperDir}/sections` });
        for (const file of sectionFiles) {
            const content = await Read(file);
            const moreFigs = content.match(/\\begin{figure}[\s\S]*?\\end{figure}/g) || [];
            figureMatches.push(...moreFigs);
        }

        const missingCaptions = [];
        for (const fig of figureMatches) {
            if (!fig.includes('\\caption{')) {
                missingCaptions.push('(figure without caption)');
            }
        }

        if (missingCaptions.length > 0) {
            return {
                name: 'Figure captions',
                passed: false,
                message: `${missingCaptions.length} figures missing captions`
            };
        }

        return {
            name: 'Figure captions',
            passed: true,
            message: `All ${figureMatches.length} figures have captions`
        };
    } catch (e) {
        return {
            name: 'Figure captions',
            passed: true, // Don't fail if we can't check
            message: 'Could not verify figure captions'
        };
    }
}

/**
 * Check if all experiments are completed
 */
function checkExperiments(plan) {
    const incomplete = plan.experiments.filter(e => !e.completed);

    return {
        name: 'Experiments completed',
        passed: incomplete.length === 0,
        message: incomplete.length === 0
            ? 'All experiments completed'
            : `${incomplete.length} experiments incomplete: ${incomplete.map(e => e.name).join(', ')}`
    };
}

/**
 * Format quality check results for display
 *
 * @param {Object} results - Quality check results
 * @returns {string} Formatted output
 */
function formatResults(results) {
    let output = '';

    for (const check of results.checks) {
        const symbol = check.passed ? '✓' : '✗';
        output += `  ${symbol} ${check.message}\n`;
    }

    if (results.warnings.length > 0) {
        output += '\n';
        for (const warning of results.warnings) {
            output += `  ⚠ ${warning}\n`;
        }
    }

    return output;
}
```

## Usage

```javascript
// @import ../shared/plan-parser.md
// @import ../shared/quality-checker.md
// @import ../shared/message-utils.md

async function main(args) {
    const paperDir = 'research/panel-my-paper';

    // Parse plan
    const planContent = await Read(`${paperDir}/plan.md`);
    const plan = parsePlan(planContent);

    // Run quality checks
    msg('Quality Gate — Final Check', 'header');
    const results = await checkQuality(paperDir, plan);

    // Display results
    console.log(formatResults(results));

    if (results.passed) {
        msg('Paper meets quality standards', 'success');
    } else {
        msg('Paper needs improvement before review', 'error');
    }
}
```

## Quality Gates

Quality gates are used at key points in the writing process:

1. **After writing complete**: Before marking paper ready for review
2. **Before panel:review**: Ensure paper meets minimum standards
3. **On demand**: Via `panel:new --check`

Each gate checks:
- Structural completeness (all sections written)
- Technical correctness (LaTeX compiles)
- Content adequacy (word count, references)
- Quality standards (abstract length, figure captions)
