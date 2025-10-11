function push_amend --description 'Amend the last commit with all changes and force push'
    git add .
    git commit --amend --no-edit
    git push -f
end
