function rebase_develop --description 'Stash changes with timestamp, update develop, rebase current branch on develop, and pop stash if rebase succeeds'
    set -l stash_name "gsr_$(date +%Y%m%d_%H%M%S)"

    git add .
    set -l stash_output (git stash push -m "$stash_name")

    set -l stash_created 0
    if echo $stash_output | grep -q "Saved working directory"
        set stash_created 1
    end

    set -l current_branch (git rev-parse --abbrev-ref HEAD)

    git switch develop
    git pull

    git switch $current_branch

    if git rebase develop
        if test $stash_created -eq 1
            set -l stash_ref (git stash list | grep "$stash_name" | awk -F: '{print $1}')
            if test -n "$stash_ref"
                git stash pop $stash_ref
                echo "Success: successfully rebased and applied stash '$stash_name'."
            else
                echo "Success: successfully rebased, but stash '$stash_name' not found."
            end
        else
            echo "Success: successfully rebased. No stash was created."
        end
    else
        echo "Rebase encountered conflicts. Please resolve them, then:"
        echo "  1. git add <resolved_files>"
        echo "  2. git rebase --continue"
        if test $stash_created -eq 1
            echo "  3. git stash pop (find stash with name '$stash_name' if needed)"
        end
        echo "To abort the rebase, use: git rebase --abort"
    end
end
