#!/bin/bash

# Fix Repository Errors for Cursor Background Agents
# This script resolves common repository configuration issues

echo "=== Cursor Background Agent Repository Fix Script ==="
echo ""

# Get current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch: $CURRENT_BRANCH"

# Check if branch has upstream tracking
if ! git rev-parse --abbrev-ref --symbolic-full-name @{u} &>/dev/null; then
    echo "⚠️  Branch '$CURRENT_BRANCH' has no upstream tracking"
    
    # Check if branch exists on remote
    if git ls-remote --heads origin "$CURRENT_BRANCH" | grep -q "$CURRENT_BRANCH"; then
        echo "✓ Branch exists on remote, setting up tracking..."
        git branch --set-upstream-to="origin/$CURRENT_BRANCH" "$CURRENT_BRANCH"
    else
        echo "✗ Branch doesn't exist on remote, pushing..."
        git push -u origin "$CURRENT_BRANCH"
    fi
    
    echo "✓ Branch tracking configured"
else
    echo "✓ Branch has upstream tracking configured"
fi

echo ""

# Check repository state
FILE_COUNT=$(find . -type f -not -path "./.git/*" | wc -l)
if [ "$FILE_COUNT" -eq 0 ]; then
    echo "⚠️  Repository is empty (no files found)"
    echo "   Consider restoring files from origin/main if needed:"
    echo "   git checkout origin/main -- ."
else
    echo "✓ Repository contains $FILE_COUNT files"
fi

echo ""

# Verify git configuration
echo "Git configuration:"
echo "  User: $(git config user.name) <$(git config user.email)>"

echo ""

# Check for any git errors
if git status &>/dev/null; then
    echo "✓ Git repository is healthy"
else
    echo "✗ Git repository has errors"
    exit 1
fi

echo ""
echo "=== Repository fix complete ==="