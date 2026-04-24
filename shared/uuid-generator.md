# UUID Generator

Generate 6-character hex UUIDs for papers (matching waves pattern).

## Functions

### generatePaperUUID()

Generate a random 6-character hex UUID.

**Returns**: `string` - 6-character hex UUID (e.g., "a1b2c3")

**Implementation**:
```javascript
const crypto = require('crypto');

function generatePaperUUID() {
    const bytes = crypto.randomBytes(3); // 3 bytes = 6 hex chars
    return bytes.toString('hex');
}
```

**Collision probability**:
- 6 hex chars = 16,777,216 possible values
- For <1000 papers: collision probability is negligible
- If collision detected: regenerate UUID

### checkUUIDCollision()

Check if a UUID already exists in the paper index.

**Parameters**:
- `uuid` (string) - UUID to check
- `papers` (array) - Array of paper objects from paper-index.yaml

**Returns**: `boolean` - true if collision detected

**Implementation**:
```javascript
function checkUUIDCollision(uuid, papers) {
    return papers.some(p => p.uuid === uuid);
}
```

### generateUniqueUUID()

Generate a UUID that doesn't collide with existing papers.

**Parameters**:
- `papers` (array) - Array of existing paper objects

**Returns**: `string` - Unique 6-character hex UUID

**Implementation**:
```javascript
function generateUniqueUUID(papers) {
    let uuid;
    let attempts = 0;
    const maxAttempts = 100;

    do {
        uuid = generatePaperUUID();
        attempts++;

        if (attempts > maxAttempts) {
            throw new Error('Failed to generate unique UUID after 100 attempts');
        }
    } while (checkUUIDCollision(uuid, papers));

    return uuid;
}
```

## Usage

```javascript
// @import ../shared/uuid-generator.md

// Generate a single UUID
const uuid = generatePaperUUID();
console.log(uuid); // "a1b2c3"

// Generate unique UUID (avoid collisions)
const papers = loadPaperIndex();
const uniqueUUID = generateUniqueUUID(papers);
```

## Module Exports

```javascript
module.exports = {
    generatePaperUUID,
    checkUUIDCollision,
    generateUniqueUUID
};
```
