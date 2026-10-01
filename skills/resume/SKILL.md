---
name: resume
description: "Resume a project from its Progress log. Use for 'pick up where we left', 'what's next', and 'check what's next in the todo list and continue'."
---

Find the project's entry file (`AGENTS.md` or `CLAUDE.md`) with an `apcd:protocol` block. Follow its Resume bullet, using the Progress it points to.

No block: tell the user APCD isn't set up here and offer `/apcd:run`.
