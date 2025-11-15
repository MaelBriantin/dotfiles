function restore --description "Run git restore"
    set status_output (git status --porcelain)
    if test -n "$status_output"
      if test (count $argv) -eq 0
          echo "🚨 With no args, all the actual tree will be restored"
          read -P "Restore all? (y/N) " confirm
          test "$confirm" = "y" && git restore .
          echo "✅ All the current tree has been restored"
          return 1
      end
      
      set target_file $argv[1]
      set status_output (git status --porcelain)
      
      # Restore
      git restore $argv[1]
          return 1
    else
      echo "🤷‍♂️ Nothing to restore..."
      return 1
    end
end
