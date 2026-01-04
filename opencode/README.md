# OpenCode Configuration

OpenCode configuration with Neovim-inspired keybinds and macOS integration.

## Installation

From the dotfiles directory:

```bash
cd ~/dotfiles
stow opencode
```

## Configuration

- **Theme:** one-dark
- **Model:** Claude Sonnet 4.5 (Anthropic)
- **Leader key:** `space`

## Keybindings

### Session Management (Space Leader)

| Keybind | Action | Description |
|---------|--------|-------------|
| `space + n` | New session | Start a fresh conversation |
| `space + l` | List sessions | Browse and resume previous sessions |
| `space + c` | Compact session | Summarize and compress current session |
| `space + x` | Export session | Export conversation to Markdown |
| `space + s` | Share session | Generate shareable link |
| `space + g` | Timeline | View session timeline/history |
| `space + q` | Exit | Quit OpenCode |

### Navigation & UI

| Keybind | Action | Description |
|---------|--------|-------------|
| `space + e` | Open editor | Open external editor for composing |
| `space + m` | Model list | Switch between AI models |
| `space + t` | Theme list | Change color theme |
| `space + a` | Agent list | View and select agents |
| `space + b` | Toggle sidebar | Show/hide sidebar |
| `space + h` | Toggle details | Show/hide tool execution details |
| `cmd + p` | Command palette | Quick access to all commands |

### Messages & History

| Keybind | Action | Description |
|---------|--------|-------------|
| `space + u` | Undo message | Remove last message and revert changes |
| `space + r` | Redo message | Restore previously undone message |
| `space + y` | Copy message | Copy message content |
| `ctrl + u` | Half page up | Scroll up (Neovim-style) |
| `ctrl + d` | Half page down | Scroll down (Neovim-style) |
| `pageup` | Page up | Scroll up one full page |
| `pagedown` | Page down | Scroll down one full page |
| `home` | First message | Jump to start of conversation |
| `end` | Last message | Jump to end of conversation |

### Input Editing (macOS-style)

| Keybind | Action | Description |
|---------|--------|-------------|
| `cmd + z` | Undo | Undo text input |
| `cmd + shift + z` | Redo | Redo text input |
| `cmd + v` | Paste | Paste from clipboard |
| `cmd + k` | Clear input | Clear current input |
| `ctrl + a` | Line home | Move to start of line |
| `ctrl + e` | Line end | Move to end of line |
| `ctrl + w` | Delete word | Delete previous word |
| `ctrl + k` | Kill to end | Delete to end of line |

### Agents

| Keybind | Action | Description |
|---------|--------|-------------|
| `tab` | Cycle agents | Switch between Build/Plan modes |
| `shift + tab` | Cycle reverse | Switch agents in reverse |

## File References

Use `@` to reference files in your messages:

```
How is auth handled in @src/api/index.ts?
```

OpenCode will fuzzy search for files and automatically include their content.

## Shell Commands

Start a message with `!` to run shell commands:

```
!ls -la
```

The output will be added to the conversation context.

## Philosophy

This configuration follows a hybrid approach:

- **Space leader** → OpenCode navigation and session management (Neovim-inspired)
- **Cmd/Super** → Text editing and system shortcuts (macOS-native)
- **Tab** → Quick agent switching
- **Ctrl** → Scrolling and advanced navigation

This design provides:
- Familiar Neovim muscle memory for navigation
- Native macOS feel for text editing
- No conflicts with terminal shortcuts
- Maximum ergonomics and productivity

## Customization

The configuration file is located at:
- Source: `~/dotfiles/opencode/.config/opencode/opencode.json`
- Symlink: `~/.config/opencode/opencode.json`

Edit the source file and changes will be reflected immediately. OpenCode automatically reloads configuration changes.

## Notes

- The `package.json`, `node_modules/`, and other auto-managed files in `~/.config/opencode/` are not stowed
- Only the `opencode.json` configuration file is version controlled
- LSP servers are auto-enabled based on file extensions
- Code formatters are auto-detected from your project

## Troubleshooting

### Restowing

If you need to restow the configuration:

```bash
cd ~/dotfiles
stow -D opencode  # Unstow
stow opencode     # Restow
```

### Verifying Symlink

Check that the symlink is correct:

```bash
ls -la ~/.config/opencode/opencode.json
# Should show: opencode.json -> ../../dotfiles/opencode/.config/opencode/opencode.json
```

### Testing Keybinds

Launch OpenCode and try:
- `space + m` → Should open model list
- `space + t` → Should open theme list
- `space + n` → Should start new session

## Resources

- [OpenCode Documentation](https://opencode.ai/docs)
- [Keybinds Reference](https://opencode.ai/docs/keybinds)
- [Themes](https://opencode.ai/docs/themes)
- [Configuration Guide](https://opencode.ai/docs/config)
