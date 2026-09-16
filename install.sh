#!/usr/bin/env bash
# One-time setup for the shared sales skills repo.
# Safe to re-run any time.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"
BACKUP_DIR="$SKILLS_DIR/.pre-sales-repo-backup"

mkdir -p "$SKILLS_DIR"

link() {
  # $1 = source path, relative to this repo. $2 = destination name, directly under ~/.claude/skills
  # (Claude Code expects every skill flat at ~/.claude/skills/<name>/SKILL.md — no extra nesting.)
  local src="$REPO_DIR/$1"
  local dest="$SKILLS_DIR/$2"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    # A real folder already exists there (not one of our symlinks from a previous run) —
    # back it up instead of clobbering it. Common the first time this runs, if a skill of
    # the same name came pre-installed.
    mkdir -p "$BACKUP_DIR"
    echo "  '$2' already exists and isn't ours — backing it up to $BACKUP_DIR/$2"
    mv "$dest" "$BACKUP_DIR/$2"
  fi

  ln -sfn "$src" "$dest"
  echo "  linked $2"
}

echo "Linking skills from $REPO_DIR into $SKILLS_DIR ..."

# Discovery layer
link "skills/icp-onboarding"          "icp-onboarding"
link "skills/icp-prompt-builder"      "icp-prompt-builder"
link "skills/lead-generator-assistant" "lead-generator-assistant"

# Deep-dive layer — these replace any pre-installed, unmodified versions of the same
# name with this repo's curated/modified ones (see README for what was changed and why).
link "sales"                    "sales"
link "skills/sales-prospect"    "sales-prospect"
link "skills/sales-contacts"    "sales-contacts"
link "skills/sales-competitors" "sales-competitors"
link "skills/sales-objections"  "sales-objections"
link "skills/sales-research"    "sales-research"
link "skills/sales-qualify"     "sales-qualify"

echo
if [ -d "$BACKUP_DIR" ]; then
  echo "Anything replaced above was backed up, not deleted — see: $BACKUP_DIR"
fi
echo "Done. You will not need to run this again unless a new skill gets added to the repo —"
echo "updates to existing skills and the shared ICP happen automatically the next time you use them."
