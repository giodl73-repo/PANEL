---
format_version: "4.0"
---

# Testing Patterns & Strategies

This document defines the testing patterns and strategies used across all applications in the App Manager monorepo.

---

## Table of Contents

1. [Testing Philosophy](#testing-philosophy)
2. [Backend Testing (Python/FastAPI)](#backend-testing-pythonfastapi)
3. [Frontend Testing (React/TypeScript)](#frontend-testing-reacttypescript)
4. [Integration Testing](#integration-testing)
5. [E2E Testing](#e2e-testing)
6. [Test Organization](#test-organization)
7. [CI/CD Testing](#cicd-testing)

---

## Testing Philosophy

### Test Pyramid

```
        /\
       /  \     E2E Tests (Few)
      /____\
     /      \   Integration Tests (Some)
    /________\
   /          \ Unit Tests (Many)
  /____________\
```

**Ratios**:
- **Unit Tests**: 70% (fast, isolated, many)
- **Integration Tests**: 20% (medium speed, test interactions)
- **E2E Tests**: 10% (slow, test critical user flows)

### Testing Goals

1. **Fast Feedback**: Unit tests run in < 5 seconds
2. **High Coverage**: Aim for 80%+ code coverage
3. **Maintainable**: Tests are easy to read and update
4. **Reliable**: No flaky tests
5. **Comprehensive**: Cover happy paths, edge cases, and errors

---

## Backend Testing (Python/FastAPI)

### Technology Stack
- **Framework**: pytest
- **Database**: SQLAlchemy with in-memory SQLite for tests
- **Mocking**: pytest-mock, unittest.mock
- **Coverage**: pytest-cov
- **Fixtures**: pytest fixtures for reusable test data

### Project Structure

```
<app>-backend/
├── tests/
│   ├── conftest.py              # Shared fixtures
│   ├── test_api/                # API endpoint tests
│   │   ├── test_cards.py
│   │   └── test_stats.py
│   ├── test_services/           # Service layer tests
│   │   ├── test_card_service.py
│   │   └── test_stats_service.py
│   ├── test_models/             # Model tests
│   │   └── test_card.py
│   └── test_schemas/            # Schema validation tests
│       └── test_card_schemas.py
```

### 1. Fixtures (conftest.py)

```python
# tests/conftest.py
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from fastapi.testclient import TestClient
from app.main import app
from app.database import Base, get_db
from app.models.card import Card

# In-memory test database
SQLALCHEMY_TEST_DATABASE_URL = "sqlite:///:memory:"

@pytest.fixture(scope="function")
def db():
    """Create a fresh database for each test"""
    engine = create_engine(
        SQLALCHEMY_TEST_DATABASE_URL,
        connect_args={"check_same_thread": False}
    )
    Base.metadata.create_all(bind=engine)

    TestingSessionLocal = sessionmaker(
        autocommit=False,
        autoflush=False,
        bind=engine
    )

    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()
        Base.metadata.drop_all(bind=engine)

@pytest.fixture(scope="function")
def client(db):
    """Test client with test database"""
    def override_get_db():
        try:
            yield db
        finally:
            pass

    app.dependency_overrides[get_db] = override_get_db

    with TestClient(app) as test_client:
        yield test_client

    app.dependency_overrides.clear()

@pytest.fixture
def sample_card(db):
    """Create a sample card for testing"""
    card = Card(
        name="Test Card",
        set_name="Test Set",
        card_number="001",
        rarity="Rare"
    )
    db.add(card)
    db.commit()
    db.refresh(card)
    return card
```

### 2. API Endpoint Tests

```python
# tests/test_api/test_cards.py
import pytest
from fastapi import status

def test_get_cards_empty(client):
    """Test getting cards when database is empty"""
    response = client.get("/api/cards")
    assert response.status_code == status.HTTP_200_OK
    assert response.json() == []

def test_get_cards_with_data(client, sample_card):
    """Test getting cards with data in database"""
    response = client.get("/api/cards")
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert len(data) == 1
    assert data[0]["name"] == "Test Card"

def test_create_card(client):
    """Test creating a new card"""
    card_data = {
        "name": "New Card",
        "set_name": "New Set",
        "card_number": "002",
        "rarity": "Common"
    }
    response = client.post("/api/cards", json=card_data)
    assert response.status_code == status.HTTP_201_CREATED
    data = response.json()
    assert data["name"] == "New Card"
    assert "id" in data

def test_create_card_validation_error(client):
    """Test creating card with invalid data"""
    card_data = {
        "name": "",  # Empty name should fail validation
        "set_name": "Test Set"
    }
    response = client.post("/api/cards", json=card_data)
    assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY

def test_get_card_by_id(client, sample_card):
    """Test getting a specific card by ID"""
    response = client.get(f"/api/cards/{sample_card.id}")
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert data["id"] == sample_card.id
    assert data["name"] == sample_card.name

def test_get_card_not_found(client):
    """Test getting non-existent card"""
    response = client.get("/api/cards/999")
    assert response.status_code == status.HTTP_404_NOT_FOUND

def test_update_card(client, sample_card):
    """Test updating a card"""
    update_data = {"name": "Updated Card"}
    response = client.put(
        f"/api/cards/{sample_card.id}",
        json=update_data
    )
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert data["name"] == "Updated Card"

def test_delete_card(client, sample_card):
    """Test deleting a card"""
    response = client.delete(f"/api/cards/{sample_card.id}")
    assert response.status_code == status.HTTP_204_NO_CONTENT

    # Verify card is deleted
    response = client.get(f"/api/cards/{sample_card.id}")
    assert response.status_code == status.HTTP_404_NOT_FOUND
```

### 3. Service Layer Tests

```python
# tests/test_services/test_card_service.py
import pytest
from app.services.card_service import card_service
from app.schemas.card import CardCreate

def test_create_card(db):
    """Test creating card through service"""
    card_data = CardCreate(
        name="Service Card",
        set_name="Test Set",
        card_number="003",
        rarity="Rare"
    )
    card = card_service.create(db, card_data)
    assert card.id is not None
    assert card.name == "Service Card"

def test_get_by_id(db, sample_card):
    """Test getting card by ID"""
    card = card_service.get(db, sample_card.id)
    assert card is not None
    assert card.id == sample_card.id

def test_get_by_id_not_found(db):
    """Test getting non-existent card"""
    card = card_service.get(db, 999)
    assert card is None

def test_get_multi(db):
    """Test getting multiple cards with pagination"""
    # Create multiple cards
    for i in range(15):
        card_data = CardCreate(
            name=f"Card {i}",
            set_name="Test Set",
            card_number=f"{i:03d}",
            rarity="Common"
        )
        card_service.create(db, card_data)

    # Test pagination
    cards = card_service.get_multi(db, skip=0, limit=10)
    assert len(cards) == 10

    cards = card_service.get_multi(db, skip=10, limit=10)
    assert len(cards) == 5
```

### 4. Database Model Tests

```python
# tests/test_models/test_card.py
import pytest
from app.models.card import Card

def test_card_creation(db):
    """Test creating a card model"""
    card = Card(
        name="Model Test Card",
        set_name="Model Test Set",
        card_number="001",
        rarity="Rare"
    )
    db.add(card)
    db.commit()

    assert card.id is not None
    assert card.name == "Model Test Card"

def test_card_relationships(db):
    """Test card relationships (if any)"""
    # Example if cards have sets relationship
    pass
```

### 5. Alembic Migration Tests

```python
# tests/test_migrations/test_migrations.py
import pytest
from alembic import command
from alembic.config import Config

def test_migrations_run():
    """Test that migrations run without errors"""
    alembic_cfg = Config("alembic.ini")
    command.upgrade(alembic_cfg, "head")
    command.downgrade(alembic_cfg, "base")
```

### Running Backend Tests

```bash
# Run all tests
cd apps/tcm-backend
poetry run pytest

# Run with coverage
poetry run pytest --cov=app --cov-report=html

# Run specific test file
poetry run pytest tests/test_api/test_cards.py

# Run specific test
poetry run pytest tests/test_api/test_cards.py::test_create_card

# Run with verbose output
poetry run pytest -v

# Run and show print statements
poetry run pytest -s
```

---

## Frontend Testing (React/TypeScript)

### Technology Stack
- **Framework**: Vitest (Vite-native testing)
- **Component Testing**: React Testing Library
- **Mocking**: vi from Vitest
- **Coverage**: Vitest coverage
- **E2E**: Playwright (optional)

### Project Structure

```
<app>-frontend/
├── src/
│   ├── components/
│   │   ├── Card.tsx
│   │   └── Card.test.tsx
│   ├── pages/
│   │   ├── Cards.tsx
│   │   └── Cards.test.tsx
│   └── hooks/
│       ├── useCards.ts
│       └── useCards.test.ts
├── tests/
│   ├── setup.ts              # Test setup
│   └── e2e/                  # E2E tests
└── vitest.config.ts
```

### 1. Vitest Configuration

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./tests/setup.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html'],
      exclude: [
        'node_modules/',
        'tests/',
        '**/*.test.tsx',
        '**/*.test.ts',
      ],
    },
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
      '@common/ui': path.resolve(__dirname, '../../packages/common-ui/src'),
    },
  },
});
```

### 2. Test Setup

```typescript
// tests/setup.ts
import { expect, afterEach } from 'vitest';
import { cleanup } from '@testing-library/react';
import * as matchers from '@testing-library/jest-dom/matchers';

// Extend Vitest matchers with jest-dom
expect.extend(matchers);

// Cleanup after each test
afterEach(() => {
  cleanup();
});
```

### 3. Component Tests

```typescript
// src/components/Card.test.tsx
import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import { Card } from './Card';

describe('Card Component', () => {
  it('renders card with data', () => {
    const card = {
      id: 1,
      name: 'Test Card',
      set_name: 'Test Set',
      card_number: '001',
      rarity: 'Rare',
    };

    render(<Card card={card} />);

    expect(screen.getByText('Test Card')).toBeInTheDocument();
    expect(screen.getByText('Test Set')).toBeInTheDocument();
    expect(screen.getByText('001')).toBeInTheDocument();
  });

  it('calls onClick when clicked', () => {
    const handleClick = vi.fn();
    const card = {
      id: 1,
      name: 'Test Card',
      set_name: 'Test Set',
      card_number: '001',
      rarity: 'Rare',
    };

    render(<Card card={card} onClick={handleClick} />);

    fireEvent.click(screen.getByText('Test Card'));

    expect(handleClick).toHaveBeenCalledWith(card);
  });

  it('applies correct rarity styling', () => {
    const card = {
      id: 1,
      name: 'Rare Card',
      set_name: 'Test Set',
      card_number: '001',
      rarity: 'Rare',
    };

    const { container } = render(<Card card={card} />);

    expect(container.firstChild).toHaveClass('border-yellow-500');
  });
});
```

### 4. Hook Tests

```typescript
// src/hooks/useCards.test.ts
import { describe, it, expect, beforeEach, vi } from 'vitest';
import { renderHook, waitFor } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useCards } from './useCards';
import * as api from '../api/client';

// Mock API client
vi.mock('../api/client');

describe('useCards Hook', () => {
  let queryClient: QueryClient;

  beforeEach(() => {
    queryClient = new QueryClient({
      defaultOptions: {
        queries: { retry: false },
      },
    });
  });

  it('fetches cards successfully', async () => {
    const mockCards = [
      { id: 1, name: 'Card 1', set_name: 'Set 1' },
      { id: 2, name: 'Card 2', set_name: 'Set 2' },
    ];

    vi.mocked(api.getCards).mockResolvedValue(mockCards);

    const wrapper = ({ children }: { children: React.ReactNode }) => (
      <QueryClientProvider client={queryClient}>
        {children}
      </QueryClientProvider>
    );

    const { result } = renderHook(() => useCards(), { wrapper });

    await waitFor(() => expect(result.current.isSuccess).toBe(true));

    expect(result.current.data).toEqual(mockCards);
  });

  it('handles fetch error', async () => {
    vi.mocked(api.getCards).mockRejectedValue(new Error('API Error'));

    const wrapper = ({ children }: { children: React.ReactNode }) => (
      <QueryClientProvider client={queryClient}>
        {children}
      </QueryClientProvider>
    );

    const { result } = renderHook(() => useCards(), { wrapper });

    await waitFor(() => expect(result.current.isError).toBe(true));

    expect(result.current.error).toBeDefined();
  });
});
```

### 5. Page/Integration Tests

```typescript
// src/pages/Cards.test.tsx
import { describe, it, expect, vi } from 'vitest';
import { render, screen, waitFor } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { CardsPage } from './Cards';
import * as api from '../api/client';

vi.mock('../api/client');

describe('Cards Page', () => {
  it('displays loading state', () => {
    const queryClient = new QueryClient();

    vi.mocked(api.getCards).mockImplementation(
      () => new Promise(() => {}) // Never resolves
    );

    render(
      <QueryClientProvider client={queryClient}>
        <CardsPage />
      </QueryClientProvider>
    );

    expect(screen.getByText(/loading/i)).toBeInTheDocument();
  });

  it('displays cards when loaded', async () => {
    const queryClient = new QueryClient({
      defaultOptions: { queries: { retry: false } },
    });

    const mockCards = [
      { id: 1, name: 'Card 1', set_name: 'Set 1', card_number: '001', rarity: 'Common' },
      { id: 2, name: 'Card 2', set_name: 'Set 2', card_number: '002', rarity: 'Rare' },
    ];

    vi.mocked(api.getCards).mockResolvedValue(mockCards);

    render(
      <QueryClientProvider client={queryClient}>
        <CardsPage />
      </QueryClientProvider>
    );

    await waitFor(() => {
      expect(screen.getByText('Card 1')).toBeInTheDocument();
      expect(screen.getByText('Card 2')).toBeInTheDocument();
    });
  });

  it('displays error message on failure', async () => {
    const queryClient = new QueryClient({
      defaultOptions: { queries: { retry: false } },
    });

    vi.mocked(api.getCards).mockRejectedValue(new Error('Failed to fetch'));

    render(
      <QueryClientProvider client={queryClient}>
        <CardsPage />
      </QueryClientProvider>
    );

    await waitFor(() => {
      expect(screen.getByText(/error/i)).toBeInTheDocument();
    });
  });
});
```

### Running Frontend Tests

```bash
# Run all tests
cd apps/tcm-frontend
pnpm test

# Run with coverage
pnpm test:coverage

# Run in watch mode
pnpm test:watch

# Run specific test file
pnpm test Card.test.tsx

# Run with UI
pnpm test:ui
```

---

## Integration Testing

### Backend Integration Tests

Test multiple layers together (API → Service → Database):

```python
# tests/integration/test_card_flow.py
import pytest

def test_complete_card_lifecycle(client, db):
    """Test creating, reading, updating, and deleting a card"""
    # Create
    card_data = {
        "name": "Lifecycle Card",
        "set_name": "Test Set",
        "card_number": "001",
        "rarity": "Rare"
    }
    response = client.post("/api/cards", json=card_data)
    assert response.status_code == 201
    card_id = response.json()["id"]

    # Read
    response = client.get(f"/api/cards/{card_id}")
    assert response.status_code == 200
    assert response.json()["name"] == "Lifecycle Card"

    # Update
    response = client.put(f"/api/cards/{card_id}", json={"name": "Updated Card"})
    assert response.status_code == 200
    assert response.json()["name"] == "Updated Card"

    # Delete
    response = client.delete(f"/api/cards/{card_id}")
    assert response.status_code == 204

    # Verify deleted
    response = client.get(f"/api/cards/{card_id}")
    assert response.status_code == 404
```

---

## E2E Testing

### Playwright Setup (Optional)

```typescript
// tests/e2e/cards.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Cards Management', () => {
  test('user can create a new card', async ({ page }) => {
    await page.goto('http://localhost:3000/cards');

    // Click "Add Card" button
    await page.click('button:has-text("Add Card")');

    // Fill form
    await page.fill('input[name="name"]', 'E2E Test Card');
    await page.fill('input[name="set_name"]', 'E2E Set');
    await page.fill('input[name="card_number"]', '999');
    await page.selectOption('select[name="rarity"]', 'Rare');

    // Submit
    await page.click('button:has-text("Save")');

    // Verify card appears in list
    await expect(page.locator('text=E2E Test Card')).toBeVisible();
  });
});
```

---

## Test Organization

### File Naming Conventions

- **Backend**: `test_*.py` (pytest convention)
- **Frontend**: `*.test.tsx` or `*.test.ts`
- **E2E**: `*.spec.ts`

### Test Naming

```python
# Backend: test_<what>_<condition>_<expected>
def test_create_card_with_valid_data_returns_201():
    pass

def test_get_card_when_not_found_returns_404():
    pass
```

```typescript
// Frontend: descriptive sentences
it('renders card with correct data', () => {});
it('calls onClick handler when card is clicked', () => {});
```

---

## CI/CD Testing

### GitHub Actions Example

```yaml
name: Tests

on: [push, pull_request]

jobs:
  backend-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - name: Install dependencies
        run: |
          cd apps/tcm-backend
          pip install poetry
          poetry install
      - name: Run tests
        run: |
          cd apps/tcm-backend
          poetry run pytest --cov=app --cov-report=xml
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  frontend-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - uses: pnpm/action-setup@v2
      - name: Install dependencies
        run: pnpm install
      - name: Run tests
        run: |
          cd apps/tcm-frontend
          pnpm test:coverage
```

---

## Best Practices

### General
1. **Test behavior, not implementation**: Test what users see/experience
2. **Keep tests independent**: Each test should run in isolation
3. **Use descriptive names**: Test names should explain what's being tested
4. **Follow AAA pattern**: Arrange, Act, Assert
5. **Mock external dependencies**: Don't call real APIs in unit tests

### Backend
1. **Use fixtures for common setup**: Reduce duplication with pytest fixtures
2. **Test database transactions**: Verify data persistence correctly
3. **Test error cases**: Don't just test happy paths
4. **Use in-memory DB for speed**: SQLite :memory: for fast tests
5. **Test Pydantic validation**: Ensure schemas validate correctly

### Frontend
1. **Query by accessibility**: Use getByRole, getByLabelText
2. **Test user interactions**: Click, type, submit
3. **Don't test implementation details**: Don't test state directly
4. **Mock API calls**: Use vi.mock() for API client
5. **Test loading/error states**: Not just success cases

---

## Coverage Goals

### Minimum Coverage Targets
- **Overall**: 80%
- **Critical paths**: 100% (authentication, payments, data persistence)
- **Business logic**: 90%
- **UI components**: 70%

### Measuring Coverage

```bash
# Backend
poetry run pytest --cov=app --cov-report=term-missing

# Frontend
pnpm test:coverage
```

---

## Troubleshooting

### Common Issues

**Backend:**
- Database fixture not cleaning up → Use `scope="function"`
- Async tests failing → Use `pytest-asyncio`
- Migration tests failing → Ensure test DB is clean

**Frontend:**
- Component not rendering → Check test setup.ts
- Async tests timing out → Use waitFor with proper timeout
- Mock not working → Verify vi.mock() path is correct

---

## Assessment Requirements

### Quality Gate Standards

When reviewing completed waves, enforce these requirements:

#### 1. Bug Detection
**Any bugs found during assessment require**:
- Regression test that would have caught the bug
- Test must be added before wave completion
- Return NEEDS_WORK if tests missing

**Example**:
```python
# Bug found: Division by zero in stats calculation
# Required regression test:
def test_stats_calculation_handles_zero_denominator():
    """Regression test for division by zero bug"""
    result = calculate_average(total=0, count=0)
    assert result == 0  # Should handle gracefully
```

#### 2. Gap Detection
**Any missing functionality identified requires**:
- Test coverage for the gap being filled
- Edge case tests for new code paths
- Return NEEDS_WORK if coverage insufficient

#### 3. Minimum Coverage Requirements
- **New features**: ≥80% test coverage
- **Bug fixes**: 100% regression test coverage
- **Critical paths**: Integration/E2E tests required

#### 4. Test Quality Standards
**All tests must**:
- Use AAA pattern (Arrange, Act, Assert)
- Be isolated (no dependencies between tests)
- Be deterministic (no flaky tests)
- Have clear failure messages

**Example**:
```python
def test_create_card_with_duplicate_number_fails():
    """Bug fix: Duplicate card numbers should be rejected"""
    # Arrange
    existing_card = Card(name="Card 1", card_number="001")
    db.add(existing_card)
    db.commit()

    # Act
    duplicate_card = Card(name="Card 2", card_number="001")
    db.add(duplicate_card)

    # Assert
    with pytest.raises(IntegrityError):
        db.commit()
```

### Assessment Output Format

```markdown
## Testing Assessment

**Status**: NEEDS_WORK | APPROVED

**Issues Found**: X bugs, Y gaps

**Test Coverage Required**:
- [ ] Regression test for Bug #1: [description]
- [ ] Edge case tests for Gap #1: [description]
- [ ] Integration tests for Feature #1: [description]

**Follow-up Enhancement**: Create EXX to add missing test coverage

**Approval Criteria**:
- All bugs have regression tests
- All gaps have edge case coverage
- Test pass rate: 100%
- Test coverage: ≥80% for new code
```

---

**Last Updated**: 2026-01-29
**Version**: 1.1
**Status**: Active
