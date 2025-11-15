function feat --description "create a feat/ branch"
    if test (count $argv) -eq 0
        echo "❌ Usage: feat <branch-name>"
        return 1
    end
    echo "✅ New branch 'feat/$argv' created"
    git switch --create feat/$argv
end
