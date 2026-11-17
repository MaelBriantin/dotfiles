function amend --description 'Amend last commit and force push'
    # Parse arguments
    set -l auto_confirm false
    for arg in $argv
        switch $arg
            case -y --yes
                set auto_confirm true
        end
    end

    echo "🎒 Adding all current work..."
    git add .
    git commit --amend --no-edit

    if test $auto_confirm = true
        echo "🥊 Force pushing..."
        git push --force-with-lease
    else
        read -P "🥊 Force push? (y/N) " confirm
        test "$confirm" = "y" && git push --force-with-lease
    end
end
