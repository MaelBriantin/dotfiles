function amend --description 'Amend last commit and force push'
    echo "🎒 Adding all current work..."
    git add .
    git commit --amend --no-edit
    read -P "🥊 Force push? (y/N) " confirm
    test "$confirm" = "y" && git push -f
end
