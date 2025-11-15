function rebase --description "Stash, rebase on branch, then apply stash"
    if test (count $argv) -eq 0
        echo "❌ Usage: rebase <branch-name>"
        return 1
    end
    
    set target_branch $argv[1]
    set status_output (git status --porcelain)
    
    if test -n "$status_output"
        echo "💾 Saving current work..."
        git stash
        set has_stash true
    else
        set has_stash false
    end
    
    # Rebase
    echo "🐕 Fetching new data..."
    git fetch origin $target_branch
    if git rebase origin/$target_branch
        if test "$has_stash" = true
            echo "⏏️ Restoring saved work..."
            git stash pop
        end
    else
        echo "🚨 Rebase failed. Fix conflicts, then: git stash pop"
        return 1
    end
    echo "✅ Actual branch successfully rebased with $target_branch"
end
