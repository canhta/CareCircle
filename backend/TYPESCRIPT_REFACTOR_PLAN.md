# TypeScript Refactoring Plan

## Goals

- Replace all `any` types with proper TypeScript types
- Fix TypeScript linting issues
- Improve code maintainability and type safety
- Reduce potential runtime errors

## Prioritized Areas

### 1. Controller Request/Response Types (High Priority)

- Replace `@Request() req: any` with proper request interfaces
- Create proper response interfaces for all controller methods
- Example files:
  - `daily-check-in.controller.ts`
  - `health-record.controller.ts`
  - `subscription.controller.ts`

### 2. Service Method Return Types (High Priority)

- Replace methods returning `any` with proper return types
- Replace methods accepting `any` parameters with typed parameters
- Example files:
  - `health-score-calculator.service.ts`
  - `response-analysis.service.ts`
  - `user-behavior-analytics.service.ts`

### 3. Data Transformation Methods (Medium Priority)

- Replace `any[]` with proper typed arrays
- Define interfaces for data structures passed around
- Example files:
  - `analytics/health-score-calculator.service.ts`
  - `analytics/response-analysis.service.ts`
  - `metrics.service.ts`

### 4. Error Handling (Medium Priority)

- Replace `details?: any` with proper error detail interfaces
- Example files:
  - `domain-exception.filter.ts`
  - `global-exception.filter.ts`

### 5. Generic Utility Functions (Lower Priority)

- Add proper generic types to utility functions
- Example files:
  - `transformation.pipe.ts`
  - `validation.pipe.ts`

## Implementation Approach

1. **Create Common Interface Files**
   - Create `backend/src/common/interfaces/` directory if not exists
   - Define shared interfaces like `RequestWithUser`, `PaginatedResponse`, etc.

2. **Incremental File-by-File Updates**
   - Refactor one file at a time
   - Prioritize most frequently used services and controllers
   - Ensure tests pass after each file update

3. **Use TypeScript Features**
   - Utilize generics where appropriate
   - Use union types instead of `any` when exact type is uncertain
   - Use the `unknown` type instead of `any` when type is truly unknown

4. **Avoid Type Assertions**
   - Minimize use of `as` type assertions
   - Use type guards (e.g., `if (typeof x === 'string')`) when necessary

## Tracking Progress

We'll track progress on this refactoring work using the following metrics:

- Number of remaining `any` types (grep search)
- Number of files completely free of `any` types
- ESLint rule compliance (`no-explicit-any`)

## Timeline

1. **Phase 1 (Controllers - Week 1)**
   - Establish common interfaces
   - Refactor controllers to use proper request/response types

2. **Phase 2 (Services - Week 2)**
   - Refactor high-priority service classes
   - Define domain-specific interfaces

3. **Phase 3 (Data Transformations - Week 3)**
   - Replace all `any[]` with proper typed arrays
   - Refine domain models

4. **Phase 4 (Error Handling & Utilities - Week 4)**
   - Improve error interfaces
   - Update utility functions with proper generic types

## Testing Strategy

- Run the full test suite after each file refactoring
- Add additional unit tests for type-specific behaviors
- Ensure no regressions in functionality

## Maintenance Rules

After completing this refactoring:

- Enforce ESLint rule `@typescript-eslint/no-explicit-any` with error severity
- Add pre-commit hooks to prevent new `any` types
- Add documentation about proper typing practices
