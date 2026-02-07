---
format_version: "4.0"
---

# Reviewer Discipline Guidelines

**Focus**: Code review, commit quality, consistency enforcement, and common issue detection

---

## Overview

Reviewers are generalist experts who ensure code quality, consistency, and correctness across all domains. They focus on commit-level review, identifying patterns of problems, maintaining coding standards, and catching issues that specialized domain experts might miss.

**Core Responsibilities**:
- Review commits for consistency and quality
- Identify common coding antipatterns
- Enforce coding standards across domains
- Verify commit messages and documentation
- Catch cross-cutting concerns (security, performance, maintainability)
- Provide actionable feedback with specific fixes

---

## Review Scope

### What Reviewers Focus On

| Area | What to Check | Why |
|------|---------------|-----|
| **Consistency** | Naming, formatting, patterns | Maintainability |
| **Commit Quality** | Message clarity, atomic changes, scope | Git history usability |
| **Common Issues** | Null checks, error handling, edge cases | Correctness |
| **Documentation** | Comments, README updates, inline docs | Knowledge transfer |
| **Standards** | Style guides, conventions, best practices | Team alignment |
| **Cross-Cutting** | Security, performance, accessibility | Quality attributes |

### What Reviewers Don't Focus On

- Deep domain-specific logic (delegate to domain experts)
- Architecture decisions (TPM/architect responsibility)
- Product requirements (PM responsibility)
- UI/UX design (designer responsibility)

---

## Review Checklist

### 1. Commit Quality

**Message Structure**:
```
Short subject line (<70 chars)

- Detailed explanation of what and why
- Breaking changes noted
- References to issues/enhancements

Co-Authored-By: Name <email>
```

**Commit Scope**:
- [ ] Single logical change per commit
- [ ] No unrelated changes bundled together
- [ ] No leftover debug code (console.logs, debugger statements)
- [ ] No commented-out code blocks
- [ ] No unnecessary whitespace changes

**Commit Message Quality**:
- [ ] Subject line uses imperative mood ("Add feature" not "Added feature")
- [ ] Subject line is clear without reading diff
- [ ] Body explains WHY, not just WHAT
- [ ] Breaking changes highlighted
- [ ] Issue/enhancement references included

### 2. Code Consistency

**Naming Conventions**:
- [ ] Variables/functions follow project naming (camelCase, snake_case, etc.)
- [ ] Constants are UPPER_CASE
- [ ] Classes are PascalCase
- [ ] Boolean variables start with is/has/should/can
- [ ] Consistent terminology (don't mix "user" and "account")

**Code Style**:
- [ ] Indentation consistent (tabs vs spaces)
- [ ] Line length within limits (typically 80-120 chars)
- [ ] Consistent quote style (single vs double)
- [ ] Consistent bracket placement (K&R vs Allman)
- [ ] Trailing commas used consistently

**File Organization**:
- [ ] Imports/requires organized and sorted
- [ ] Unused imports removed
- [ ] Related functions grouped together
- [ ] Consistent file naming across project

### 3. Common Coding Issues

**Error Handling**:
```python
# ❌ Bad - No error handling
def get_user(id):
    return database.query(id)

# ✅ Good - Explicit error handling
def get_user(id):
    try:
        return database.query(id)
    except NotFoundError:
        raise UserNotFoundError(f"User {id} not found")
    except DatabaseError as e:
        logger.error(f"Database error: {e}")
        raise
```

**Null/Undefined Checks**:
```javascript
// ❌ Bad - No null check
function getUserName(user) {
    return user.profile.name;  // Can throw if user/profile is null
}

// ✅ Good - Safe navigation
function getUserName(user) {
    return user?.profile?.name ?? 'Unknown';
}
```

**Resource Cleanup**:
```python
# ❌ Bad - No cleanup
def process_file(path):
    file = open(path)
    return file.read()

# ✅ Good - Context manager
def process_file(path):
    with open(path) as file:
        return file.read()
```

**Edge Cases**:
- [ ] Empty arrays/lists handled
- [ ] Zero/negative numbers considered
- [ ] Boundary conditions tested
- [ ] Off-by-one errors avoided
- [ ] Division by zero prevented

### 4. Security Review

**Input Validation**:
- [ ] User input sanitized/validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (proper escaping)
- [ ] Path traversal checks (no ../.. in file paths)
- [ ] Command injection prevention

**Sensitive Data**:
- [ ] No hardcoded passwords/keys
- [ ] No secrets in logs
- [ ] Sensitive data encrypted at rest
- [ ] API keys in environment variables
- [ ] No PII in error messages

**Authentication/Authorization**:
- [ ] Auth checks present where needed
- [ ] No auth bypass vulnerabilities
- [ ] Session handling secure
- [ ] CSRF protection in place

### 5. Performance Review

**Common Issues**:
- [ ] No N+1 query problems
- [ ] Database queries optimized (indexes, limits)
- [ ] Large loops optimized
- [ ] Unnecessary re-renders avoided (React/Vue)
- [ ] Memory leaks prevented (event listeners cleaned up)

**Anti-patterns**:
```javascript
// ❌ Bad - N+1 queries
users.forEach(user => {
    const posts = database.getPostsByUser(user.id);  // N queries
});

// ✅ Good - Single query
const allPosts = database.getPostsByUserIds(users.map(u => u.id));
```

### 6. Maintainability Review

**Code Clarity**:
- [ ] Functions are small and focused (<50 lines)
- [ ] Magic numbers replaced with named constants
- [ ] Complex conditions extracted to named variables
- [ ] Nested conditionals flattened (early returns)
- [ ] Duplication eliminated (DRY principle)

**Documentation**:
- [ ] Complex logic has explanatory comments
- [ ] Public APIs documented
- [ ] README updated for new features
- [ ] Breaking changes documented
- [ ] Migration guides provided

**Testing**:
- [ ] Tests included for new features
- [ ] Edge cases tested
- [ ] Tests are clear and focused
- [ ] No flaky tests
- [ ] Test coverage maintained/improved

---

## Common Antipatterns

### Code Smells

| Smell | Example | Fix |
|-------|---------|-----|
| **Magic Numbers** | `if (status === 3)` | `if (status === STATUS_ACTIVE)` |
| **Long Functions** | 200+ line functions | Extract to smaller functions |
| **Deep Nesting** | 5+ levels of if/for | Use early returns, extract functions |
| **Commented Code** | `// const x = 5;` | Delete it (git preserves history) |
| **God Objects** | Class with 50+ methods | Split responsibilities |
| **Primitive Obsession** | Using strings for everything | Create domain types |
| **Feature Envy** | Method uses another class's data heavily | Move method to that class |

### Commit Antipatterns

| Antipattern | Issue | Fix |
|-------------|-------|-----|
| **Mixed Concerns** | Refactor + new feature in one commit | Separate commits |
| **Tiny Commits** | 10 commits for one feature | Squash related commits |
| **Vague Messages** | "Fix bug" | "Fix null pointer in user login flow" |
| **WIP Commits** | "WIP", "temp", "debug" | Squash before merge |
| **Binary Files** | Large images, videos | Use Git LFS or exclude |

---

## Review Process

### 1. Initial Scan (30 seconds)

Quick assessment:
- Commit count and size
- Files changed (expected vs unexpected)
- Overall structure and organization
- Red flags (secrets, large files, formatting issues)

### 2. Detailed Review (5-10 minutes per commit)

For each commit:
1. **Read commit message** - Does it explain what and why?
2. **Check diff scope** - Is it focused and atomic?
3. **Review changed files** - Apply consistency/quality checks
4. **Look for patterns** - Repeated issues across files
5. **Test coverage** - Are changes tested?

### 3. Feedback Format

Use this template:

```markdown
## Summary
[1-2 sentence overview of review findings]

## Critical Issues (must fix before merge)
- [ ] Issue 1: Description with line reference
- [ ] Issue 2: Description with line reference

## Suggestions (nice to have)
- Suggestion 1: Improvement idea
- Suggestion 2: Alternative approach

## Positives
- Good practice 1
- Good practice 2

## Questions
- Question about approach/decision
```

**Example**:
```markdown
## Summary
Solid implementation overall. Found 2 critical issues around error handling
and 1 consistency issue with naming conventions.

## Critical Issues
- [ ] `app.py:42` - No error handling for database connection failure
  ```python
  # Add try/except around db.connect()
  try:
      db.connect()
  except ConnectionError as e:
      logger.error(f"DB connection failed: {e}")
      raise
  ```
- [ ] `user.py:15` - Potential null pointer if user.profile is None
  ```python
  # Use safe navigation
  return user.profile?.name ?? 'Unknown'
  ```

## Suggestions
- Consider extracting `validateUserInput()` to a shared utility (used in 3 places)
- Line 67: `getUserById` could benefit from JSDoc comments

## Positives
- Excellent test coverage (95%+)
- Clear commit messages
- Good error messages for user-facing errors

## Questions
- Why use async here when the operation is synchronous?
```

### 4. Follow-up

After feedback:
- Re-review changes addressing feedback
- Verify all critical issues resolved
- Check for regression from changes
- Approve or request additional changes

---

## Review Guidelines

### Be Constructive

**Good Feedback**:
- Specific: Point to exact line/file
- Actionable: Suggest concrete fix
- Respectful: Assume good intent
- Educational: Explain why

**Poor Feedback**:
- Vague: "This looks wrong"
- Demanding: "Fix this now"
- Condescending: "Everyone knows this"
- Nitpicky: Arguing over personal preference

### Prioritize Issues

| Priority | When | Examples |
|----------|------|----------|
| **Critical** | Blocks merge | Security holes, data loss, crashes |
| **High** | Should fix before merge | Bugs, broken tests, unclear code |
| **Medium** | Nice to have | Consistency, style, optimization |
| **Low** | Optional | Personal preference, trivial naming |

### Know When to Approve

✅ **Approve when**:
- No critical/high issues remain
- Code follows project standards
- Tests pass and cover changes
- Documentation updated
- Commit messages are clear

⚠️ **Request changes when**:
- Critical issues present
- Tests failing or missing
- Security concerns
- Breaking changes without migration plan

---

## Tools and Resources

### Code Review Tools

- **Git**: `git diff`, `git log`, `git show`
- **GitHub**: PR reviews, inline comments, suggested changes
- **Linters**: ESLint, Pylint, RuboCop (catch style issues automatically)
- **Static Analysis**: SonarQube, CodeClimate (find bugs/security issues)

### Quick Commands

```bash
# Review last commit
git show HEAD

# Review specific commit
git show abc123

# See file at specific commit
git show abc123:path/to/file.py

# Compare branches
git diff main..feature-branch

# Check commit message
git log --oneline -10
```

---

## Anti-Patterns to Avoid

### As a Reviewer

❌ **Don't**:
- Nitpick formatting (use automated tools)
- Block on personal preference
- Rewrite the entire PR
- Review while tired/rushed
- Assume malice

✅ **Do**:
- Focus on correctness and maintainability
- Suggest, don't demand
- Approve with minor suggestions
- Ask questions to understand
- Assume good intent

---

## Escalation

When to involve specialists:

| Issue Type | Escalate To |
|------------|-------------|
| Complex algorithm | Domain expert (backend/frontend) |
| Architecture change | Tech lead / architect |
| Security vulnerability | Security team |
| Performance problem | Performance engineer |
| UI/UX concern | Designer |
| Breaking API change | API owner / PM |

---

**Version**: 1.0
**Last Updated**: 2026-01-29
