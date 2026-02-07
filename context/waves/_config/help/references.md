---
format_version: "4.0"
---

# Waves Reference Syntax

## Wave References (^)

Use `^` prefix (optional) to reference waves.

### By Order Number
```
^14        # Wave number 14
14         # Same (^ is optional for waves)
```

### By Slug
```
^command-expansion
command-expansion
```

### By UUID
```
^04ab85    # 6-character hex UUID
04ab85
```

---

## Pulse References (~)

Use `~` prefix to reference pulses within the active wave.

### By Order Number
```
~1         # First pulse in active wave
~10        # Tenth pulse
```

### By Slug
```
~directory-reorganization
~help-system
```

### By UUID
```
~dfadb0    # 6-character hex UUID
```

---

## Cross-Wave Pulse References

Reference pulses in other waves using `@waveUUID:pulseRef`:

```
@04ab85:~1              # Pulse 1 in wave 04ab85
@04ab85:~setup          # Pulse 'setup' in wave 04ab85
```

---

## UUID Generation

UUIDs are deterministic MD5 hashes:

```javascript
// Wave UUID
MD5(project + "-" + wave_slug).slice(0, 6)

// Pulse UUID
MD5(project + "-" + wave_slug + "-" + pulse_slug).slice(0, 6)
```

---

## Resolution Priority

When a reference could match multiple types:

1. **UUID** (if exactly 6 hex chars)
2. **Order** (if numeric)
3. **Slug** (otherwise)

---

## Examples

| Reference | Type | Resolves To |
|-----------|------|-------------|
| `^14` | Order | Wave #14 |
| `^04ab85` | UUID | Wave with UUID 04ab85 |
| `^command-expansion` | Slug | Wave with that slug |
| `~1` | Order | Pulse #1 in active wave |
| `~setup` | Slug | Pulse named 'setup' |
| `~dfadb0` | UUID | Pulse with that UUID |

---

## In Dependencies

Pulse dependencies use the same syntax:

```yaml
# Same wave
dependencies:
  - "~dfadb0+directory-reorganization"
  - "~1"  # By order

# Cross-wave
dependencies:
  - "@abc123:~setup"
```

---

## See Also

- `/waves:help concepts` - Core concepts
- `/waves:help commands` - Command reference
