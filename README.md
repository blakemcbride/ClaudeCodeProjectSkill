# Claude Code Project Skills

Six [Claude Code](https://claude.com/claude-code) skills that keep the state
of each piece of work in plain files in your project, so a fresh session can
pick the work up with nothing lost.

A Claude Code session that stays open for weeks loses detail every time its
context is compacted. These skills replace the long-lived session with a
written record: you save where a project stands, close the session whenever
you like, and start the next one by reading the record back.

It also saves tokens. A long or reopened session carries its whole history,
and that history is sent to the model again on every turn. A fresh session
that reads a project's saved state starts with only the few kilobytes that
matter.

> This is an independent project. It is not made or supported by Anthropic.

## The skills

| Skill | What it does |
|---|---|
| `/save-project` | Saves where the project stands right now. It can be run at any time, including in the middle of work, and the work then continues. |
| `/resume-project <name>` | In a fresh session, reads the project's saved state, checks it against version control, reports where things stand, and continues the work. |
| `/new-project <name>` | Alias for `/resume-project`. |
| `/list-projects [words]` | Lists the names of the recorded projects. Changes nothing. |
| `/describe-project <name>` | Shows the detail of one project from its saved state. Changes nothing. |
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

Three rules run through all six skills:

- **A project is never finished.** More corrections and enhancements are
  always possible, so no skill marks a project as done or closed.
- **Nothing is deleted automatically.** Only `/delete-project` removes a
  project, and only after you confirm.
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

Then put the six skill directories where Claude Code looks for skills.

For every project on your machine:

```
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/
```

For one project only, run this from the cloned directory:

```
mkdir -p /path/to/your/project/.claude/skills
cp -r skills/* /path/to/your/project/.claude/skills/
```

Start a new Claude Code session. `/skills` lists the six, and `/list-projects`
is a harmless first test: in a project with no `PROJECTS.md` it says so and
stops.

Install all six. They refer to each other by name.

### Installing with links instead of copies

If you would rather have the installed skills follow the cloned repository,
link the directories instead of copying them:

```
mkdir -p ~/.claude/skills
for s in skills/*; do ln -s "$PWD/$s" ~/.claude/skills/; done
```

A `git pull` then updates the installed skills as well.

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

With copies, pull and copy again:

```
git pull
cp -r skills/* ~/.claude/skills/
```

With links, `git pull` is enough.

## Remove

```
cd ~/.claude/skills
rm -r new-project resume-project save-project list-projects describe-project delete-project
```

This removes the skills only. `PROJECTS.md` and `Projects/` in your projects
are yours and are left alone.

## License

MIT. See [LICENSE](LICENSE).
