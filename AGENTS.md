# Project Instructions

## General Guidelines

- Follow the project's architecture and conventions (Flutter + Dart).
- Prefer clean, maintainable, and idiomatic Dart code, over cleverness.
- When unsure, ask clarifying questions before generating code.
- Never invent APIs or Flutter widgets that don’t exist; if unsure, say so.
- Keep code deterministic and reproducible.
- Every file you modify should follow the project’s formatting (dart format).
- When generating code, include imports.

## Code Style

- When creating new functions or classes, include a docstring of 1-3 lines, describing what it does. Prioritize using three slashes (///) when possible for clearance from the user interface.
- 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss
- 'surfaceVariant' is deprecated and shouldn't be used. Use surfaceContainerHighest instead.

## Architecture

- Prefer separation of concerns and modular code over bulky and long code. For example, putting new models in a dedicated file in `lib/models` directory, different pages in a dedicated file in `lib/pages` directory, etc.
- Follow the repository pattern
- Keep business logic in service layers

## UI

- Produce clean, reusable Flutter widgets.
- Follow Material 3 design.
- Use `const` whenever possible.
- Avoid deprecated widgets.
- Keep business logic outside of UI files.  

## State Management
- 

## Database

## Testing

**Role:**  
Creates and maintains unit, widget, and integration tests.

**Goals:**  
- Provide deterministic and meaningful tests.
- Achieve high coverage of critical logic.
- Provide clear test structure.

**Workflow:**  
1. Identify what is testable.  
2. Write test suites.  
3. Create mocks and expected behaviors.

**Rules:**  
- Test your code, not the Flutter framework.  
- Keep tests small and isolated.  
- Avoid flaky tests.