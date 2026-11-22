#!/bin/sh
# Install, update or remove the project skills on Linux or macOS.
# Run it from a clone of the repository:  ./install.sh --help

set -eu

usage() {
    cat <<'EOF'
Usage: ./install.sh [--link] [--project DIR] [--uninstall]

  (no option)     Copy the skills into ~/.claude/skills, for every project.
                  Run it again after "git pull" to update them.
  --link          Link the skills instead of copying them, so that
                  "git pull" updates the installed skills as well.
  --project DIR   Install into DIR/.claude/skills, for that project only.
  --uninstall     Remove the skills. PROJECTS.md and Projects/ in your
                  projects are left alone.
  -h, --help      Show this text.

If CLAUDE_CONFIG_DIR is set, it is used in place of ~/.claude.
EOF
}

mode=copy
project=

while [ $# -gt 0 ]; do
    case $1 in
        --link) mode="link" ;;
        --uninstall) mode=uninstall ;;
        --project)
            [ $# -ge 2 ] || { echo "install.sh: --project needs a directory" >&2; exit 2; }
            project=$2
            shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "install.sh: unknown option: $1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

src=$(cd "$(dirname "$0")" && pwd -P)/skills
[ -d "$src" ] || { echo "install.sh: no skills directory beside this script" >&2; exit 1; }

if [ -n "$project" ]; then
    [ -d "$project" ] || { echo "install.sh: not a directory: $project" >&2; exit 1; }
    dest=$(cd "$project" && pwd -P)/.claude/skills
else
    dest=${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills
fi

if [ "$mode" != uninstall ]; then
    mkdir -p "$dest"
    if [ "$(cd "$dest" && pwd -P)" = "$src" ]; then
        echo "install.sh: $dest is this repository's own skills directory" >&2
        exit 1
    fi
fi

# Remove one installed skill: a link is unlinked, a directory is deleted.
remove() {
    target=$dest/$1
    if [ -L "$target" ]; then
        rm -f "${target:?}"
    elif [ -e "$target" ]; then
        rm -rf "${target:?}"
    else
        return 1
    fi
}

count=0
for dir in "$src"/*/; do
    [ -f "${dir}SKILL.md" ] || continue
    name=$(basename "$dir")
    case $mode in
        copy)
            remove "$name" || true
            cp -R "$src/$name" "$dest/$name" ;;
        link)
            remove "$name" || true
            ln -s "$src/$name" "$dest/$name" ;;
        uninstall)
            remove "$name" || continue ;;
    esac
    count=$((count + 1))
done

case $mode in
    copy) echo "Copied $count skills to $dest" ;;
    link) echo "Linked $count skills in $dest to $src" ;;
    uninstall) echo "Removed $count skills from $dest" ;;
esac
[ "$mode" = uninstall ] || echo "Start a new Claude Code session; /skills lists them."
