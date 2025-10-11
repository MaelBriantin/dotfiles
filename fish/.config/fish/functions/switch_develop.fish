function switch_develop --description 'Stash changes, switch to develop, and pull latest changes'
    git add .
    git stash
    git switch develop
    git pull
end
