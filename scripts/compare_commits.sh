#!/bin/bash
# Script to compare commits between fork and upstream OpenWRT
# Usage: ./scripts/compare_commits.sh [commit1] [commit2]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if remote exists
check_remote() {
    local remote=$1
    if ! git remote | grep -q "^${remote}$"; then
        print_warning "Remote '${remote}' not found. Adding it now..."
        if [ "$remote" == "upstream" ]; then
            git remote add upstream https://github.com/openwrt/openwrt.git
            print_success "Added upstream remote"
        fi
    fi
}

# Function to display commit information
show_commit_info() {
    local commit=$1
    local label=$2
    
    echo ""
    echo "========================================"
    echo "$label"
    echo "========================================"
    git --no-pager show --stat --format=fuller "$commit"
    echo ""
}

# Function to compare two commits
compare_commits() {
    local commit1=$1
    local commit2=$2
    
    print_info "Comparing commits:"
    echo "  Commit 1: $commit1"
    echo "  Commit 2: $commit2"
    echo ""
    
    # Show info for both commits
    show_commit_info "$commit1" "COMMIT 1 DETAILS"
    show_commit_info "$commit2" "COMMIT 2 DETAILS"
    
    # Show diff between commits
    echo "========================================"
    echo "DIFFERENCES BETWEEN COMMITS"
    echo "========================================"
    echo ""
    
    print_info "Files changed between commits:"
    git --no-pager diff --name-status "$commit1" "$commit2" | head -50
    echo ""
    
    print_info "Statistics:"
    git --no-pager diff --stat "$commit1" "$commit2" | tail -10
    echo ""
    
    # Check if commits are related
    if git merge-base --is-ancestor "$commit1" "$commit2" 2>/dev/null; then
        print_info "$commit1 is an ancestor of $commit2"
    elif git merge-base --is-ancestor "$commit2" "$commit1" 2>/dev/null; then
        print_info "$commit2 is an ancestor of $commit1"
    else
        print_warning "Commits are not directly related (different branches)"
    fi
}

# Function to compare with upstream
compare_with_upstream() {
    local local_commit=${1:-HEAD}
    
    check_remote "upstream"
    
    print_info "Fetching upstream..."
    git fetch upstream
    
    print_info "Comparing $local_commit with upstream/master"
    
    # Find common ancestor
    local merge_base=$(git merge-base "$local_commit" upstream/master 2>/dev/null || echo "none")
    
    if [ "$merge_base" != "none" ]; then
        print_info "Common ancestor: $merge_base"
        show_commit_info "$merge_base" "COMMON ANCESTOR"
    else
        print_warning "No common ancestor found"
    fi
    
    # Show what's in fork but not in upstream
    echo "========================================"
    echo "COMMITS IN FORK NOT IN UPSTREAM"
    echo "========================================"
    git --no-pager log --oneline "$local_commit" ^upstream/master | head -20
    echo ""
    
    # Show what's in upstream but not in fork
    echo "========================================"
    echo "COMMITS IN UPSTREAM NOT IN FORK"
    echo "========================================"
    git --no-pager log --oneline upstream/master ^"$local_commit" | head -20
    echo ""
    
    # Compare files
    compare_commits "$local_commit" "upstream/master"
}

# Main script logic
main() {
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository!"
        exit 1
    fi
    
    print_info "OpenWRT Commit Comparison Tool"
    echo ""
    
    # Parse arguments
    if [ $# -eq 0 ]; then
        # No arguments: compare current branch with upstream
        print_info "No arguments provided. Comparing current branch with upstream..."
        compare_with_upstream HEAD
    elif [ $# -eq 1 ]; then
        # One argument: compare with upstream
        compare_with_upstream "$1"
    elif [ $# -eq 2 ]; then
        # Two arguments: compare two specific commits
        compare_commits "$1" "$2"
    else
        print_error "Too many arguments!"
        echo "Usage:"
        echo "  $0                    # Compare current branch with upstream"
        echo "  $0 <commit>           # Compare specific commit with upstream"
        echo "  $0 <commit1> <commit2> # Compare two specific commits"
        exit 1
    fi
    
    print_success "Comparison complete!"
}

# Run main function
main "$@"
