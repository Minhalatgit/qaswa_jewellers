#!/usr/bin/env bash
# Diffs the current branch against dev and prints a structured review summary.
# Usage: .cursor/scripts/pr-review.sh [base-branch]
# Defaults base branch to 'dev' if not provided.

BASE="${1:-dev}"
CURRENT=$(git branch --show-current)

if [[ -z "$CURRENT" ]]; then
  echo "ERROR: Not inside a git repository or no branch checked out."
  exit 1
fi

if [[ "$CURRENT" == "$BASE" ]]; then
  echo "ERROR: You are already on '$BASE'. Check out a feature branch first."
  exit 1
fi

echo "============================================"
echo "  PR Review: $CURRENT -> $BASE"
echo "============================================"
echo ""

echo "--- Commits in this branch ---"
git log "$BASE".."$CURRENT" --oneline
echo ""

echo "--- Files changed ---"
git diff "$BASE"..."$CURRENT" --stat
echo ""

echo "--- Full diff ---"
git diff "$BASE"..."$CURRENT"
