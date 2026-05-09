# Connect Mode

```
panel:setup --connect
panel:setup --connect research
```

Standalone mode — connects an existing research directory to a research monorepo without running full setup.

## Behavior

```javascript
// @import ../shared/project-config.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);
```

1. **Verify prerequisites**: Check `researchDir` exists in cwd. If not, abort with:
   ```
   Error: Research directory not found. Run panel:setup first to create it.
   ```

2. **Resolve monorepo path**:
   - If `--connect <path>` provided: use that path
   - Default: `../research`

3. **Run Step 8 only**: Execute the Research Monorepo Connection logic (detection, connection, registration) from the project setup flow (see project.md Step 8).

4. **Report**: Show just the connection outcome:
   ```
   Panel Setup — Connect to Research Monorepo
   ═══════════════════════════════════════════════════════════════════════

   Module: boost
   Monorepo: ../research/

   ✓ scripts/sync-to-research.sh generated
   ✓ Initial sync complete ({N} papers)
   ✓ Module registered in monorepo README.md + CLAUDE.md
   ✓ Committed: [{module}] Register module: initial sync
   ```

   If already connected:
   ```
   ✓ Already connected — synced ({N} papers)
   ```

   If monorepo not found:
   ```
   Error: No git repository found at ../research
   Hint: Clone it first, or specify the path: panel:setup --connect <path>
   ```

5. **Auto-commit**: Commit sync script and any local changes.
