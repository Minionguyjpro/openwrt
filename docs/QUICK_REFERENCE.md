# Quick Reference: Commit Comparison

This is a quick reference guide for comparing commits in your OpenWRT fork.

## Quick Start

```bash
# Compare with upstream (default)
./scripts/compare_commits.sh

# Compare specific commit with upstream
./scripts/compare_commits.sh <commit-hash>

# Compare two specific commits
./scripts/compare_commits.sh <commit1> <commit2>
```

## Common Use Cases

### 1. Check what's different between your fork and upstream
```bash
./scripts/compare_commits.sh
```

### 2. See what changed in a specific commit
```bash
git show <commit-hash>
```

### 3. Compare your main commit with upstream
```bash
./scripts/compare_commits.sh d07058c
```

### 4. View commit history
```bash
git log --oneline -20
```

### 5. See files changed between two commits
```bash
git diff --name-only commit1 commit2
```

## Understanding Output

- **Green [SUCCESS]**: Operation completed successfully
- **Blue [INFO]**: Informational messages
- **Yellow [WARNING]**: Non-critical issues (e.g., missing remote)
- **Red [ERROR]**: Critical errors

## Quick Git Commands

```bash
# View current branch
git branch

# View all remotes
git remote -v

# View recent commits
git log --oneline -10

# Show detailed commit info
git show <commit-hash>

# Compare files between commits
git diff commit1 commit2 -- file/path

# Find commits by author
git log --author="name"

# Find commits by date
git log --since="2025-01-01"
```

## Files in This Repository

- **scripts/compare_commits.sh**: Main comparison script
- **docs/COMMIT_COMPARISON.md**: Comprehensive guide with examples
- **README.md**: Main repository documentation

## Need Help?

See the full [Commit Comparison Guide](COMMIT_COMPARISON.md) for detailed information and troubleshooting.
