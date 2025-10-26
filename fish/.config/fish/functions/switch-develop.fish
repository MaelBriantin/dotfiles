function switch-develop --description 'Stash changes, switch to develop, and pull latest'
    git add .
    and git stash
    and git switch develop
    and git pull
end
