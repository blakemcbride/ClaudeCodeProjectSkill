# Project management skills

Six Claude Code skills that keep the state of each project in plain files:
`new-project`, `resume-project`, `save-project`, `list-projects`,
`describe-project`, `delete-project`. This repository is their one source
and also keeps this record of the work on them.

## Where everything is

- This repository (branch `master`, public on GitHub as
  `blakemcbride/ClaudeCodeProjectSkill`, MIT).
  - `skills/<name>/SKILL.md` — the six skills.
  - `ProjectSkills.md` — full documentation of every step.
  - `README.md` — public introduction, install, use, update, remove.
  - `CLAUDE.md` — the rules for working in this repository.
  - `PROJECTS.md` and `Projects/` — this project's own saved state.
- On the owner's machine `~/.claude/skills/<name>` for each of the six is a
  symbolic link into `skills/` here, so editing a skill through either path
  edits this repository.
- Other projects on the owner's machine use the skills, each with its own
  `PROJECTS.md` and `Projects/` in its root. What has to be kept in step in
  those projects when a skill changes is recorded in Claude's memory for this
  repository, not here.

## Decisions the owner made, and why

- **A project is never finished.** More corrections and enhancements are
  always possible. No skill marks a project done or closed. With nothing
  outstanding an entry stays, with `Next: Nothing outstanding.`
- **`save-project` is a checkpoint, not an ending.** It runs at any time,
  including mid-work, records what is in flight without stopping or cleaning
  it up, and the work then continues. It was first called `wrap-up`, then
  `end-project`; both names were dropped because they implied an ending.
- **`save-project` never deletes a project.** Only `delete-project` removes
  an entry or note, on an explicit request, after showing what will go and
  getting a yes. `resume-project` likewise deletes done items but never an
  entry or note.
- **Notes live in the project, not in Claude's memory directory**, so that
  nothing Claude Code cleans up can reach them. The owner wanted to be sure
  nothing is auto-deleted; the memory directory is protected only by the
  current Claude Code version's behavior.
- **The status file is `PROJECTS.md`** (was `OPEN.md`).
- **`new-project` is a pure alias** for `resume-project` and holds no steps of
  its own.
- **Fresh session first.** `resume-project` (and so `new-project`) refuses to
  run in a session that already holds other work and tells the user to
  `/clear` or start `claude` again. Status-only questions ("where are we on
  X") are exempt and answered in place, but the work is not continued there.
- **Loose match asks first** in `resume-project`; an exact match (whole title
  or note name) resumes without asking. `describe-project` uses a loose match
  without asking because it changes nothing.
- **`save-project` checks a new name for a collision** (equal to, containing,
  or contained in an existing title or note name) so a name can never be a
  loose match for another project.
- **`list-projects` is brief:** names only, one comma-separated line per
  section, plus the total. Detail comes from `describe-project`, which was
  added for that purpose and reads only the entry and the note.
- **Section headings in `PROJECTS.md` are categories, not projects.**
- **Purposes the owner named:** one session per piece of work instead of
  weeks-long sessions, and saving tokens, since a fresh session reads only a
  few kilobytes of state where a long or reopened session re-sends its whole
  history each turn.
- **How the owner presents the skills publicly**, and so how `README.md`
  opens: Claude Code already saves and resumes sessions, but a saved session
  (1) holds far too much detail and uses unnecessary tokens, (2) is purged
  automatically after a set period, and (3) is stored in Claude Code's own
  directories, which may not be backed up with the project. A "project" does
  essentially what session save and resume does without those three
  shortcomings. Keep the README's opening in that order.
- **Public-facing wording.** Because the repository is public and the
  installed skills are the same files, the skills, `ProjectSkills.md` and
  `README.md` say "the user", never a person's name, and hold no home
  directory path and nothing specific to one project.
- **Keep the GitHub repository current** as the skills are enhanced: update
  `ProjectSkills.md` and `README.md` in the same task as a skill change.
  Committing and pushing need the owner's request each time.
- **This project's own record lives here**, not in another project, because
  the skills are not specific to any one project. It is written for a public
  repository: no person's name, no home directory path, no other project's
  name.

## Rejected

- **Making the skills clear the session themselves.** Claude Code offers no
  way for a skill, tool or hook to trigger `/clear` or restart a session.
  Two substitutes were offered and the owner chose neither: a `SessionStart`
  hook that picks up a saved project name after `/clear` is typed, and
  launching a new terminal running `claude "/resume-project <name>"`.

## Traps

- A skill runs in the session it is typed in; it cannot start a fresh one.
- The skills are instructions, not code: a change is tested by running the
  skill, not by a build.
- Symbolic links for skill directories work: a fresh Claude Code 2.1.330
  session listed all six linked skills.
- Because the installed skills are links, a half-made edit here is live in
  every Claude Code session on the machine at once.
- A session started in this repository does not load another project's
  memory, so the rules that matter here are in `CLAUDE.md`.
- The skills take the project root to be the directory the session was
  started in. Work on these skills is often done from a session started in
  another project; a save from there has to be pointed at this repository's
  `PROJECTS.md` and `Projects/` deliberately.
- Saving this record changes tracked files, so the repository shows
  uncommitted changes after every save until the owner asks for a commit.
