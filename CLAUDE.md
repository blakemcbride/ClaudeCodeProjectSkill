# Working in this repository

This repository is the one source of six Claude Code skills (`new-project`,
`resume-project`, `save-project`, `list-projects`, `describe-project`,
`delete-project`) and their documentation. It is public on GitHub.

## Layout

- `skills/<name>/SKILL.md` — the skills. On the owner's machine each
  directory is linked from `~/.claude/skills/`, so an edit here is live in
  every Claude Code session at once. Do not leave a skill half edited.
- `ProjectSkills.md` — full documentation of every skill and step.
- `README.md` — public introduction, install, use, update and remove steps.
- `PROJECTS.md` and `Projects/` — this repository's own saved state, written
  by the skills themselves. Use `/resume-project` and `/save-project` here as
  in any other project.

## Rules

- **Keep the documentation in step.** In the same task that changes a skill
  (a rename, a new or changed step, a changed trigger, a change to where the
  state lives), update `ProjectSkills.md`, and update `README.md` where its
  summary, install steps or described behavior changed.
- **Public wording.** The skills, `ProjectSkills.md` and `README.md` say "the
  user", never a person's name. They hold no home directory path and nothing
  specific to one project.
- **A project is never finished.** No skill marks a project as done or
  closed, and none deletes a project's entry or note except
  `delete-project`, on an explicit request and after confirmation.
- **The skills only write records.** They change no application code and
  never commit, push, deploy or restart anything.
- **Test by running.** The skills are instructions, not code. A change is
  checked by running the skill in a session.
- **Commit and push only when asked**, each time, on `master`. Never create a
  branch without being asked. After changing anything, say that the
  repository has uncommitted changes.
