---
format_version: "4.0"
---

# Frontend Patterns (React)

This document defines frontend coding patterns and best practices for React applications in the monorepo.

---

## Table of Contents

1. [Project Structure](#project-structure)
2. [Application Setup](#application-setup)
3. [API Client](#api-client)
4. [TypeScript Types](#typescript-types)
5. [Custom Hooks](#custom-hooks)
6. [Components](#components)
7. [Pages](#pages)
8. [React Dropdown Component Pattern](#react-dropdown-component-pattern)
9. [Error Handling](#error-handling)
10. [Testing Patterns](#testing-patterns)
11. [Code Style](#code-style)

---

## Project Structure

```
<app>-frontend/
├── src/
│   ├── main.tsx                # Entry point
│   ├── App.tsx                 # Root component
│   ├── pages/                  # Pages
│   ├── components/             # Components
│   ├── hooks/                  # Custom hooks
│   ├── api/                    # API client
│   └── types/                  # TypeScript types
```

---

## Application Setup

```typescript
// src/main.tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { BrowserRouter } from 'react-router-dom';
import App from './App';
import './index.css';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
      retry: 1,
      staleTime: 5 * 60 * 1000, // 5 minutes
    },
  },
});

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </QueryClientProvider>
  </React.StrictMode>
);
```

---

## API Client

```typescript
// src/api/client.ts
import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000';

export const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor
api.interceptors.request.use(
  (config) => {
    // Add auth token if available
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor
api.interceptors.response.use(
  (response) => response.data,
  (error) => {
    if (error.response?.status === 401) {
      // Handle unauthorized
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);
```

---

## TypeScript Types

```typescript
// src/types/card.ts
export interface Card {
  id: number;
  name: string;
  player: string | null;
  team: string | null;
  year: number | null;
  value: number | null;
  created_at: string;
  updated_at: string | null;
}

export interface CardCreate {
  name: string;
  player?: string;
  team?: string;
  year?: number;
  value?: number;
}

export interface CardUpdate extends Partial<CardCreate> {}
```

---

## Custom Hooks

```typescript
// src/hooks/useCards.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '../api/client';
import type { Card, CardCreate, CardUpdate } from '../types/card';

export const useCards = (skip = 0, limit = 100) => {
  return useQuery({
    queryKey: ['cards', skip, limit],
    queryFn: () => api.get<Card[]>('/api/cards', { params: { skip, limit } }),
  });
};

export const useCard = (id: number) => {
  return useQuery({
    queryKey: ['card', id],
    queryFn: () => api.get<Card>(`/api/cards/${id}`),
    enabled: !!id,
  });
};

export const useCreateCard = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CardCreate) => api.post<Card>('/api/cards', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['cards'] });
    },
  });
};

export const useUpdateCard = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: CardUpdate }) =>
      api.patch<Card>(`/api/cards/${id}`, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['cards'] });
      queryClient.invalidateQueries({ queryKey: ['card', variables.id] });
    },
  });
};

export const useDeleteCard = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: number) => api.delete(`/api/cards/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['cards'] });
    },
  });
};
```

---

## Components

```typescript
// src/components/CardCard.tsx
import React from 'react';
import { Card } from '../types/card';
import { Button } from '@common/ui';

interface CardCardProps {
  card: Card;
  onEdit: (card: Card) => void;
  onDelete: (id: number) => void;
}

export const CardCard: React.FC<CardCardProps> = ({ card, onEdit, onDelete }) => {
  return (
    <div className="border rounded-lg p-4 shadow-sm hover:shadow-md transition">
      <h3 className="text-lg font-semibold">{card.name}</h3>
      <p className="text-gray-600">{card.player}</p>
      <p className="text-sm text-gray-500">{card.team} - {card.year}</p>
      {card.value && (
        <p className="text-green-600 font-bold">${card.value.toFixed(2)}</p>
      )}
      <div className="mt-4 flex gap-2">
        <Button onClick={() => onEdit(card)} variant="primary" size="sm">
          Edit
        </Button>
        <Button onClick={() => onDelete(card.id)} variant="danger" size="sm">
          Delete
        </Button>
      </div>
    </div>
  );
};
```

---

## Pages

```typescript
// src/pages/CardsPage.tsx
import React, { useState } from 'react';
import { useCards, useDeleteCard } from '../hooks/useCards';
import { CardCard } from '../components/CardCard';
import { LoadingSpinner, Button } from '@common/ui';
import type { Card } from '../types/card';

export const CardsPage: React.FC = () => {
  const [page, setPage] = useState(0);
  const limit = 20;
  const { data: cards, isLoading, error } = useCards(page * limit, limit);
  const deleteCard = useDeleteCard();

  const handleDelete = async (id: number) => {
    if (confirm('Are you sure you want to delete this card?')) {
      await deleteCard.mutateAsync(id);
    }
  };

  if (isLoading) return <LoadingSpinner />;
  if (error) return <div>Error loading cards</div>;

  return (
    <div className="container mx-auto p-4">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Trading Cards</h1>
        <Button onClick={() => {/* open create modal */}}>
          Add Card
        </Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {cards?.map((card) => (
          <CardCard
            key={card.id}
            card={card}
            onEdit={(card) => {/* open edit modal */}}
            onDelete={handleDelete}
          />
        ))}
      </div>

      <div className="flex justify-center gap-2 mt-6">
        <Button
          onClick={() => setPage(p => Math.max(0, p - 1))}
          disabled={page === 0}
        >
          Previous
        </Button>
        <span className="py-2 px-4">Page {page + 1}</span>
        <Button
          onClick={() => setPage(p => p + 1)}
          disabled={!cards || cards.length < limit}
        >
          Next
        </Button>
      </div>
    </div>
  );
};
```

---

## React Dropdown Component Pattern

### Overview

Reusable dropdown pattern with keyboard navigation, click-outside detection, and accessibility features. Used in the Wave Launcher component.

### File Organization

```
src/components/
├── WaveLauncher/
│   ├── index.tsx                  # Main component
│   ├── WaveLauncher.types.ts     # TypeScript types
│   ├── WaveLauncher.test.tsx     # Unit tests
│   ├── WaveLauncher.css          # Component styles
│   └── hooks/
│       ├── useClickOutside.ts    # Click outside detection
│       └── useKeyboardNav.ts     # Keyboard navigation
```

### Basic Dropdown Structure

```typescript
// src/components/WaveLauncher/index.tsx
import { useState, useRef, useEffect } from 'react';
import { useClickOutside } from './hooks/useClickOutside';
import { useKeyboardNav } from './hooks/useKeyboardNav';
import type { ProjectConfig } from './WaveLauncher.types';

export const WaveLauncher: React.FC = () => {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  // Close dropdown when clicking outside
  useClickOutside(dropdownRef, () => setIsOpen(false));

  // Handle keyboard navigation
  const { focusedIndex, handleKeyDown } = useKeyboardNav({
    itemCount: projects.length,
    isOpen,
    onSelect: (index) => handleProjectClick(projects[index].id),
    onClose: () => setIsOpen(false),
  });

  return (
    <div ref={dropdownRef} className="dropdown-container">
      <button
        className={`dropdown-button ${isOpen ? 'open' : ''}`}
        onClick={() => setIsOpen(!isOpen)}
        onKeyDown={handleKeyDown}
        aria-haspopup="listbox"
        aria-expanded={isOpen}>
        Dropdown
      </button>

      {isOpen && (
        <div className="dropdown-menu" role="listbox">
          {/* Dropdown items */}
        </div>
      )}
    </div>
  );
};
```

### Custom Hook: useClickOutside

```typescript
// src/hooks/useClickOutside.ts
import { useEffect, RefObject } from 'react';

export const useClickOutside = (
  ref: RefObject<HTMLElement>,
  handler: () => void
) => {
  useEffect(() => {
    const listener = (event: MouseEvent | TouchEvent) => {
      // Do nothing if clicking ref's element or descendent elements
      if (!ref.current || ref.current.contains(event.target as Node)) {
        return;
      }
      handler();
    };

    document.addEventListener('mousedown', listener);
    document.addEventListener('touchstart', listener);

    return () => {
      document.removeEventListener('mousedown', listener);
      document.removeEventListener('touchstart', listener);
    };
  }, [ref, handler]);
};
```

### Custom Hook: useKeyboardNav

```typescript
// src/hooks/useKeyboardNav.ts
import { useState, useCallback, KeyboardEvent } from 'react';

interface UseKeyboardNavProps {
  itemCount: number;
  isOpen: boolean;
  onSelect: (index: number) => void;
  onClose: () => void;
}

export const useKeyboardNav = ({
  itemCount,
  isOpen,
  onSelect,
  onClose,
}: UseKeyboardNavProps) => {
  const [focusedIndex, setFocusedIndex] = useState(-1);

  const handleKeyDown = useCallback(
    (e: KeyboardEvent<HTMLElement>) => {
      switch (e.key) {
        case 'Enter':
        case ' ':
          e.preventDefault();
          if (focusedIndex >= 0) {
            onSelect(focusedIndex);
          }
          break;

        case 'Escape':
          e.preventDefault();
          onClose();
          break;

        case 'ArrowDown':
          e.preventDefault();
          setFocusedIndex((prev) =>
            prev < itemCount - 1 ? prev + 1 : prev
          );
          break;

        case 'ArrowUp':
          e.preventDefault();
          setFocusedIndex((prev) => (prev > 0 ? prev - 1 : 0));
          break;

        case 'Home':
          e.preventDefault();
          setFocusedIndex(0);
          break;

        case 'End':
          e.preventDefault();
          setFocusedIndex(itemCount - 1);
          break;

        default:
          break;
      }
    },
    [focusedIndex, itemCount, onSelect, onClose]
  );

  // Reset focus when dropdown closes
  useEffect(() => {
    if (!isOpen) {
      setFocusedIndex(-1);
    }
  }, [isOpen]);

  return { focusedIndex, handleKeyDown };
};
```

### TypeScript Type Safety

```typescript
// src/components/WaveLauncher/WaveLauncher.types.ts

// Readonly array for immutable project configs
export interface ProjectConfig {
  id: string;
  name: string;
  color: string;
}

export const PROJECT_CONFIGS: readonly ProjectConfig[] = [
  { id: 'app-manager', name: 'App Manager', color: '#F38181' },
  { id: 'tcm', name: 'TCM', color: '#FF6B35' },
  { id: 'nhl', name: 'NHL', color: '#4ECDC4' },
  { id: 'apportionment', name: 'Apportionment', color: '#95E1D3' },
  { id: 'performance', name: 'Performance', color: '#2496ED' },
] as const;

// Extract valid project IDs as a union type
export type ProjectId = typeof PROJECT_CONFIGS[number]['id'];
// Result: 'app-manager' | 'tcm' | 'nhl' | 'apportionment' | 'performance'

// Component props
export interface WaveLauncherProps {
  className?: string;
  onProjectSelect?: (projectId: ProjectId) => void;
}

// Dropdown state
export interface DropdownState {
  isOpen: boolean;
  focusedIndex: number;
}
```

### Type Guards for Validation

```typescript
// Type guard for runtime validation
const isValidProjectId = (id: string): id is ProjectId => {
  const validIds: readonly string[] = PROJECT_CONFIGS.map((p) => p.id);
  return validIds.includes(id);
};

// Usage in component
const handleProjectClick = (projectId: string) => {
  if (!isValidProjectId(projectId)) {
    console.error('Invalid project ID:', projectId);
    return;
  }

  // TypeScript knows projectId is ProjectId type here
  openWaves(projectId);
};
```

### Component Optimization

```typescript
import { memo, useMemo, useCallback } from 'react';

// Memoize static project list
const projects = useMemo(() => PROJECT_CONFIGS, []);

// Memoize dropdown item component
const DropdownItem = memo<{
  project: ProjectConfig;
  onClick: () => void;
  isFocused: boolean;
}>(({ project, onClick, isFocused }) => (
  <div
    className={`dropdown-item ${isFocused ? 'focused' : ''}`}
    onClick={onClick}
    data-project={project.id}>
    <span
      className="color-dot"
      style={{ backgroundColor: project.color }}
    />
    <span className="project-name">{project.name}</span>
  </div>
));

DropdownItem.displayName = 'DropdownItem';

// Memoize click handlers
const handleProjectClick = useCallback((projectId: ProjectId) => {
  window.open(`http://localhost:5100?project=${projectId}`, '_blank');
  setIsOpen(false);
}, []);
```

### CSS Architecture

```css
/* Component-scoped CSS with BEM naming */

/* Container */
.wave-launcher {
  position: relative;
  display: inline-block;
}

/* Button */
.wave-launcher__button {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease-out;
}

.wave-launcher__button:hover {
  background: var(--color-bg-hover);
  border-color: var(--color-border-hover);
}

.wave-launcher__button:focus-visible {
  outline: 2px solid var(--color-focus);
  outline-offset: 2px;
}

.wave-launcher__button--open .wave-launcher__chevron {
  transform: rotate(180deg);
}

/* Dropdown menu */
.wave-launcher__menu {
  position: absolute;
  top: calc(100% + 8px);
  right: 0;
  min-width: 260px;
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: 8px;
  box-shadow:
    0 10px 15px -3px rgba(0, 0, 0, 0.1),
    0 4px 6px -2px rgba(0, 0, 0, 0.05);
  padding: 8px;
  z-index: 1000;
  animation: slideDown 0.25s ease-out;
}

@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Dropdown items */
.wave-launcher__item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 14px;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.15s ease-out;
}

.wave-launcher__item:hover,
.wave-launcher__item--focused {
  background: var(--color-bg-hover);
}

.wave-launcher__item:focus-visible {
  outline: 2px solid var(--color-focus);
  outline-offset: -2px;
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce) {
  .wave-launcher__button,
  .wave-launcher__menu,
  .wave-launcher__item {
    animation: none !important;
    transition: none !important;
  }
}
```

### Accessibility Patterns

```typescript
// Full accessibility implementation
export const AccessibleDropdown: React.FC = () => {
  const [isOpen, setIsOpen] = useState(false);
  const buttonRef = useRef<HTMLButtonElement>(null);
  const menuRef = useRef<HTMLDivElement>(null);

  // Announce to screen readers
  const [announcement, setAnnouncement] = useState('');

  const handleOpen = () => {
    setIsOpen(true);
    setAnnouncement('Dropdown opened, 5 items available');
  };

  const handleClose = () => {
    setIsOpen(false);
    setAnnouncement('Dropdown closed');
    buttonRef.current?.focus(); // Return focus to button
  };

  return (
    <>
      <button
        ref={buttonRef}
        role="button"
        aria-haspopup="listbox"
        aria-expanded={isOpen}
        aria-label="Select project to view waves"
        onClick={() => (isOpen ? handleClose() : handleOpen())}>
        Dropdown
      </button>

      {isOpen && (
        <div
          ref={menuRef}
          role="listbox"
          aria-label="Project list"
          aria-activedescendant={focusedIndex >= 0 ? `item-${focusedIndex}` : undefined}>
          {projects.map((project, index) => (
            <div
              key={project.id}
              id={`item-${index}`}
              role="option"
              aria-selected={index === focusedIndex}
              tabIndex={index === focusedIndex ? 0 : -1}>
              {project.name}
            </div>
          ))}
        </div>
      )}

      {/* Screen reader announcements */}
      <div className="sr-only" role="status" aria-live="polite">
        {announcement}
      </div>
    </>
  );
};
```

---

## Error Handling

```typescript
const { data, error, isLoading } = useCards();

if (error) {
  return (
    <div className="text-red-600">
      Error: {error.response?.data?.detail || 'Something went wrong'}
    </div>
  );
}
```

---

## Testing Patterns

### Frontend Tests (Vitest + React Testing Library)

```typescript
// src/components/CardCard.test.tsx
import { render, screen } from '@testing-library/react';
import { CardCard } from './CardCard';

describe('CardCard', () => {
  const mockCard = {
    id: 1,
    name: 'Test Card',
    player: 'Test Player',
    value: 10.00
  };

  it('renders card information', () => {
    render(<CardCard card={mockCard} onEdit={() => {}} onDelete={() => {}} />);

    expect(screen.getByText('Test Card')).toBeInTheDocument();
    expect(screen.getByText('Test Player')).toBeInTheDocument();
    expect(screen.getByText('$10.00')).toBeInTheDocument();
  });
});
```

### Dropdown Testing Pattern

```typescript
// src/components/WaveLauncher/WaveLauncher.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { WaveLauncher } from './index';

describe('WaveLauncher', () => {
  it('renders button', () => {
    render(<WaveLauncher />);
    expect(screen.getByRole('button', { name: /waves/i })).toBeInTheDocument();
  });

  it('opens dropdown on click', () => {
    render(<WaveLauncher />);
    fireEvent.click(screen.getByRole('button'));
    expect(screen.getByRole('listbox')).toBeInTheDocument();
  });

  it('closes dropdown on outside click', () => {
    const { container } = render(<WaveLauncher />);
    fireEvent.click(screen.getByRole('button'));
    fireEvent.mouseDown(container);
    expect(screen.queryByRole('listbox')).not.toBeInTheDocument();
  });

  it('handles keyboard navigation', () => {
    render(<WaveLauncher />);
    const button = screen.getByRole('button');

    // Open with Enter
    fireEvent.keyDown(button, { key: 'Enter' });
    expect(screen.getByRole('listbox')).toBeInTheDocument();

    // Navigate with Arrow Down
    fireEvent.keyDown(button, { key: 'ArrowDown' });
    // Assert focus moved

    // Close with Escape
    fireEvent.keyDown(button, { key: 'Escape' });
    expect(screen.queryByRole('listbox')).not.toBeInTheDocument();
  });

  it('opens correct URL on project select', () => {
    const mockOpen = jest.spyOn(window, 'open').mockImplementation();

    render(<WaveLauncher />);
    fireEvent.click(screen.getByRole('button'));
    fireEvent.click(screen.getByText('TCM'));

    expect(mockOpen).toHaveBeenCalledWith(
      'http://localhost:5100?project=tcm',
      '_blank'
    );

    mockOpen.mockRestore();
  });
});
```

---

## Code Style

### TypeScript Best Practices

```typescript
// Use interfaces for objects
interface Card {
  id: number;
  name: string;
}

// Use functional components
export const CardCard: React.FC<CardCardProps> = ({ card }) => {
  return <div>{card.name}</div>;
};

// Use const for everything
const cards = await api.get('/cards');
```

---

## Important Guidelines

### Do's

- Use functional components
- Use TypeScript strictly (no `any`)
- Use React Query for data fetching
- Keep components small and focused
- Use Tailwind for styling
- Use `const` for everything
- Use pnpm for package management
- Memoize expensive computations and static data
- Use semantic HTML and ARIA attributes

### Don'ts

- Don't use `npm` or `yarn` - use `pnpm` for Node packages
- Don't use `fetch` - use the `api` client from `@common/api-client`
- Don't add dependencies without using pnpm
- Don't use class components (use functional components)
- Don't skip accessibility features

---

## Related Documentation

- [Backend Patterns](./backend_patterns.md) - FastAPI/Python patterns
- [General Patterns](./general_patterns.md) - Monorepo and testing patterns
- [CLAUDE.md](./CLAUDE.md) - Project overview and quick reference
- [ARCHITECTURE.md](./ARCHITECTURE.md) - System design and architecture
