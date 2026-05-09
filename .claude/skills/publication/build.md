# panel:publication build

### `build [targets]`

Compile LaTeX to PDF and deploy to `{researchDir}/docs/`.

```
panel:publication build                   # all publications → docs/
panel:publication build token-efficiency  # single → docs/token-efficiency.pdf
panel:publication build --dist            # explicit dist (default behaviour)
panel:publication build --pdf-only        # compile only, skip dist copy
```

Runs `make dist` in each publication directory (or `make pdf` with `--pdf-only`).
`dist` target copies `main.pdf` → `../../docs/{slug}.pdf`.

On success: `✓ docs/token-efficiency.pdf (342 KB)`
On error: shows LaTeX error log excerpt, offers to open in editor.
