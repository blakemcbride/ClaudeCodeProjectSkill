# Claude Code Project Skills

[Claude Code](https://claude.com/claude-code) saves your sessions
automatically and lets you resume them. That is useful, but it has three
problems:

1. **A saved session holds far too much detail.** It is the whole
   conversation, and all of it is sent to the model again on every turn of a
   resumed session, using tokens that are not needed.
2. **Saved sessions are purged.** Claude Code deletes them automatically
   after a set period (30 days unless you change it).
3. **Saved sessions are stored outside your project.** They are kept in
   Claude Code's own directories, which may not be backed up with your
   project.

These twelve skills manage what they call *projects*. A project does
essentially what session save and resume does, without those three
shortcomings:

1. **Only what matters is kept.** A project's saved state is a short
   summary: where the work stands, the next step, what is outstanding, and
   the decisions and traps a new session could not work out from the code. A
   fresh session that reads it starts with a few kilobytes, not a whole
   conversation.
2. **Nothing is purged.** A project's saved state stays until you delete it
   yourself.
3. **It is stored in your project.** The saved state is plain Markdown files
   in your project's own directory, so it is backed up and copied along with
   everything else there, and can be put under version control.

A long session also loses detail every time its context is compacted. A
saved project does not: you save where it stands, close the session whenever
you like, and start the next one by reading the record back.

> This is an independent project. It is not made or supported by Anthropic.

## The skills

| Skill | What it does |
|---|---|
| `/save-project` | Saves where the project stands right now. It can be run at any time, including in the middle of work, and the work then continues. |
| `/resume-project <name>` | In a fresh session, reads the project's saved state, checks it against version control, reports where things stand, and continues the work. |
| `/new-project <name>` | Alias for `/resume-project`. |
| `/list-projects [words]` | Lists the names of the recorded projects. Changes nothing. |
| `/describe-project <name>` | Shows the detail of one project from its saved state. Changes nothing. |
| `/status-projects [words]` | Shows one line per project: its name, its next step and how many items are outstanding. Changes nothing. |
| `/rename-project <name> to <new name>` | Renames a project and fixes the references to it. |
| `/archive-project <name>` | Sets a project aside without deleting it. Its saved state moves to `Projects/archive/`. |
| `/unarchive-project [name]` | Brings an archived project back. With no name it lists the archived projects. |
| `/merge-project <name> into <other>` | Folds one project into another, after showing the plan and asking for confirmation. |
| `/split-project <name> [into <new name>]` | Makes two projects of one, after showing the plan and asking for confirmation. |
| `/delete-project <name>` | Deletes a project's saved state, after showing what will go and asking for confirmation. |

Claude also runs a skill when you ask in plain words, for example "save
where we are" or "where are we on the import work".

[ProjectSkills.md](ProjectSkills.md) describes every step of every skill.

## How it works

The skills keep two things in the root of your project, the directory the
session was started in:

- `PROJECTS.md` holds one entry per project: a title, where it stands, the
  next step, and a checklist of what is outstanding.
- `Projects/project_<name>.md` holds one note per project with what a new
  session cannot work out from the code: the decisions made and why, the
  design, the files that matter, and the traps found along the way.

Both are ordinary Markdown files that you can read and edit yourself. They
are kept in your project, not in Claude Code's own directories, so nothing
Claude Code cleans up can remove them.

Three rules run through all twelve skills:

- **A project is never finished.** More corrections and enhancements are
  always possible, so no skill marks a project as done or closed.
- **Nothing is deleted automatically.** Only `/delete-project` removes a
  project, and only after you confirm. `/archive-project` sets one aside
  and loses nothing, and `/merge-project` moves a project's whole content
  into another before removing it, after you confirm.
- **The skills only write records.** They change no application code and
  never commit, push, deploy or restart anything.

## Requirements

Claude Code. The skills are instructions in Markdown; there is no program to
build and nothing else to install.

`/resume-project` uses `git` or `svn` to compare the saved state with the
working copy, when the project uses one of them.

## Install

Clone the repository:

```
git clone https://github.com/blakemcbride/ClaudeCodeProjectSkill.git
cd ClaudeCodeProjectSkill
```

Then run the install script from the cloned directory.

On Linux or macOS:

```
./install.sh
```

On Windows:

```
powershell -ExecutionPolicy Bypass -File install.ps1
```

This copies the twelve skill directories to `~/.claude/skills`
(`%USERPROFILE%\.claude\skills` on Windows), where Claude Code looks for
skills, so they work in every project on your machine. If
`CLAUDE_CONFIG_DIR` is set, the script uses it in place of `~/.claude`.

For one project only, name the project:

```
./install.sh --project /path/to/your/project
```

```
powershell -ExecutionPolicy Bypass -File install.ps1 -Project C:\path\to\your\project
```

That installs into the project's own `.claude/skills`.

Start a new Claude Code session. `/skills` lists the twelve, and `/list-projects`
is a harmless first test: in a project with no `PROJECTS.md` it says so and
stops.

The script installs all twelve. They refer to each other by name.

### Installing with links instead of copies

If you would rather have the installed skills follow the cloned repository,
link the directories instead of copying them:

```
./install.sh --link
```

```
powershell -ExecutionPolicy Bypass -File install.ps1 -Link
```

A `git pull` then updates the installed skills as well. On Windows the links
are directory junctions, which need no special rights.

### Installing by hand

The scripts only copy or link directories. Without them:

```
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/
```

## Use

A typical session:

1. Start `claude` in your project.
2. Type `/resume-project <name>`, or `/new-project <name>` for work that has
   no record yet.
3. Do the work. Type `/save-project` whenever you want a checkpoint.
4. Type `/save-project` before you close the session.

The first `/save-project` in a project creates `PROJECTS.md` and `Projects/`.
If you want them under version control, add them yourself; the skills do not.

`/resume-project` and `/new-project` are meant to be the first thing typed in
a fresh session. A skill cannot clear the session it runs in, so when one of
them is typed in a session that already holds other work, it tells you to
run `/clear` or start `claude` again first. A question that only asks for
status, such as "where are we on the import work", is answered in any
session.

## Update

With copies, pull and run the install script again, with the same options as
before. It replaces each of the twelve installed skill directories:

```
git pull
./install.sh
```

With links, `git pull` is enough. Run the script again only when a pull
brings a new skill, which needs its own link.

## Remove

```
./install.sh --uninstall
```

```
powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall
```

Add `--project` (`-Project`) with the project's directory for a
one-project install.

This removes the skills only. `PROJECTS.md` and `Projects/` in your projects
are yours and are left alone.

## License

MIT. See [LICENSE](LICENSE).
