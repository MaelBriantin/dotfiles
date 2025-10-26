function rebase-develop --description 'Stash changes, update develop, rebase current branch, and restore stash'
    # Save current state
    set -l stash_name "rebase_$(date +%Y%m%d_%H%M%S)"
    set -l current_branch (git rev-parse --abbrev-ref HEAD)
    
    git add .
    set -l stash_output (git stash push -m "$stash_name" 2>&1)
    set -l has_stash (string match -q "*Saved working directory*" -- $stash_output; echo $status)
    
    # Update develop branch
    git switch develop || return 1
    git pull || return 1
    git switch $current_branch || return 1
    
    # Perform rebase
    if git rebase develop
        echo "✓ Rebase successful"
        
        # Restore stash if one was created
        if test $has_stash -eq 0
            set -l stash_ref (git stash list | string match -r "^(stash@\{\d+\}).*$stash_name" | string split ':' -f1)
            if test -n "$stash_ref"
                git stash pop $stash_ref
                echo "✓ Stash '$stash_name' applied"
            else
                echo "⚠ Stash '$stash_name' not found"
            end
        end
    else
        echo "✗ Rebase conflicts detected"
        echo ""
        echo "To resolve:"
        echo "  1. Fix conflicts in your editor"
        echo "  2. git add <resolved-files>"
        echo "  3. git rebase --continue"
        test $has_stash -eq 0; and echo "  4. git stash pop  # Apply stash '$stash_name'"
        echo ""
        echo "To abort: git rebase --abort"
        return 1
    end
end
