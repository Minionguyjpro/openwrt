# Commit Comparison Guide

This guide explains how to compare commits between your OpenWRT fork and the upstream OpenWRT repository.

## Overview

The `compare_commits.sh` script provides an easy way to:
- Compare any two commits in your repository
- Compare your fork with the upstream OpenWRT repository
- Identify differences between branches
- Find common ancestors between commits

## Prerequisites

- Git must be installed
- You must be in the OpenWRT repository directory
- Internet connection (for fetching upstream changes)

## Usage

### Basic Usage

```bash
# Compare current branch with upstream OpenWRT
./scripts/compare_commits.sh

# Compare a specific commit with upstream
./scripts/compare_commits.sh d07058c

# Compare two specific commits
./scripts/compare_commits.sh commit1 commit2
```

### Examples

#### Example 1: Compare Current State with Upstream

```bash
./scripts/compare_commits.sh
```

This will:
- Fetch the latest changes from upstream OpenWRT
- Show commits unique to your fork
- Show commits in upstream not in your fork
- Display file differences

#### Example 2: Compare Specific Commit with Upstream

```bash
./scripts/compare_commits.sh d07058c
```

This compares the specific commit `d07058c` against upstream/master.

#### Example 3: Compare Two Commits

```bash
./scripts/compare_commits.sh HEAD~5 HEAD
```

This compares the current HEAD with 5 commits back in history.

## Output Explanation

The script provides several sections of output:

### 1. Commit Details
Shows detailed information about each commit including:
- Commit hash
- Author and date
- Commit message
- Files changed

### 2. Common Ancestor
If comparing with upstream, shows the common ancestor commit where your fork diverged.

### 3. Unique Commits
Lists commits that exist in one branch but not the other:
- **Commits in fork not in upstream**: Your changes
- **Commits in upstream not in fork**: Upstream changes you don't have

### 4. File Differences
Shows:
- List of files that changed between commits
- Statistics (additions/deletions)
- Whether commits are related

## Manual Comparison

If you prefer to use git commands directly:

### View Commit Details

```bash
# Show detailed info about a commit
git show d07058c

# Show commit with file statistics
git show --stat d07058c

# Show full diff for a commit
git show d07058c
```

### Compare Commits

```bash
# Show differences between two commits
git diff commit1 commit2

# Show only changed file names
git diff --name-only commit1 commit2

# Show statistics
git diff --stat commit1 commit2
```

### Compare with Upstream

```bash
# Add upstream remote (if not already added)
git remote add upstream https://github.com/openwrt/openwrt.git

# Fetch upstream changes
git fetch upstream

# See commits in your fork not in upstream
git log HEAD ^upstream/master --oneline

# See commits in upstream not in your fork
git log upstream/master ^HEAD --oneline

# Find common ancestor
git merge-base HEAD upstream/master
```

### View Commit History

```bash
# View recent commit history
git log --oneline -20

# View commits with file changes
git log --stat -10

# View commits in a date range
git log --since="2025-01-01" --until="2025-12-31"

# View commits by author
git log --author="username"
```

## Understanding the Fork

Your OpenWRT fork was created from the upstream OpenWRT project. The main commit that added all OpenWRT files is `d07058c`.

To understand what changes exist between your fork and upstream:

1. **Check your current branch:**
   ```bash
   git branch
   ```

2. **View recent commits:**
   ```bash
   git log --oneline -10
   ```

3. **Compare with upstream:**
   ```bash
   ./scripts/compare_commits.sh d07058c
   ```

## Troubleshooting

### "Remote 'upstream' not found"
The script will automatically add the upstream remote. If you see this warning, it's normal and will be resolved automatically.

### "Not in a git repository"
Make sure you're running the script from within the OpenWRT repository directory:
```bash
cd /path/to/openwrt
./scripts/compare_commits.sh
```

### "No common ancestor found"
This means the commits are from completely different repositories or histories. This can happen if comparing unrelated branches.

## Advanced Usage

### Comparing Specific Files

```bash
# Compare a specific file between commits
git diff commit1 commit2 -- path/to/file

# Show file at specific commit
git show commit1:path/to/file
```

### Creating Patches

```bash
# Create a patch file for differences
git diff commit1 commit2 > changes.patch

# Apply a patch
git apply changes.patch
```

### Viewing Branch Differences

```bash
# Compare current branch with another branch
git diff branch-name

# Compare with upstream main branch
git diff upstream/master
```

## Additional Resources

- [OpenWRT Development Guide](https://openwrt.org/docs/guide-developer/start)
- [Git Documentation](https://git-scm.com/doc)
- [OpenWRT GitHub](https://github.com/openwrt/openwrt)

## Notes

- The comparison script requires internet access to fetch upstream changes
- Large repositories may take time to compare
- The script shows a maximum of 50 files in the diff summary for readability
