function clean-dsstore --description 'Remove all .DS_Store files in the current directory'
    echo "🧹Cleaning .DS_Store files in "(pwd)"..."
    find . -name '.DS_Store' -type f -delete 2>/dev/null
    echo "✅ All .DS_Store files removed"
    
    # Check Finder settings
    set -l network_setting (defaults read com.apple.desktopservices DSDontWriteNetworkStores 2>/dev/null)
    set -l usb_setting (defaults read com.apple.desktopservices DSDontWriteUSBStores 2>/dev/null)
    
    if test "$network_setting" != "1" -o "$usb_setting" != "1"
        echo ""
        echo "Finder can still create .DS_Store files on external/network volumes"
        echo "To disable:"
        echo "  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true"
        echo "  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true"
        echo "  killall Finder"
    end
end
