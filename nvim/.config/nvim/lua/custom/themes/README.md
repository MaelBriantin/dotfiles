# Themes Configuration

This directory contains modular theme configurations for Neovim.

## Available Themes

- **carbonfox.lua** - Carbonfox theme from nightfox.nvim (dark, carbon-inspired colors)
- **github-dark.lua** - GitHub Dark Dimmed theme (dark with dimmed UI elements)

## How to Switch Themes

To change your active theme:

1. Open the theme file you want to use (e.g., `carbonfox.lua`)
2. Set `lazy = false` in the configuration
3. Open the other theme files and set `lazy = true` in their configurations

Example in `carbonfox.lua`:
```lua
return {
  'EdenEast/nightfox.nvim',
  name = 'nightfox',
  lazy = false,  -- ← Active theme
  priority = 1000,
  -- ...
}
```

Example in `github-dark.lua`:
```lua
return {
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  lazy = true,  -- ← Inactive theme
  priority = 1000,
  -- ...
}
```

## Adding New Themes

To add a new theme:

1. Create a new `.lua` file in this directory
2. Follow the structure of existing theme files
3. Set `lazy = false` if you want it active, or `lazy = true` to keep it available but inactive
4. Customize the theme options and highlight groups as needed

## Note

Only one theme should have `lazy = false` at a time. All others should have `lazy = true`.
