# Project Agent Instructions

Add project-specific guidance for your coding agents here.

<!-- >>> agent-memory (managed) >>> -->
## Project memory (user data)
- Before changing code, search memory with the `memory` MCP tools (`memory_search`, `graph_query`) for relevant decisions, lessons, and structure.
- After a non-trivial decision or lesson, save it with `memory_save` (or write to `~/agent-memory/<project-id>/notes/`).
- If the memory server is unavailable, continue normally; memory is advisory.
- Specs live in `~/agent-memory/<project-id>/specs/` unless committed to the repo for teammates/CI.
- Don't create memory files in the project directory; use the designated memory locations.
<!-- <<< agent-memory (managed) <<< -->
