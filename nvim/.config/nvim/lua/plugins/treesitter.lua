-- nvim-treesitter (branche `main`, réécriture pour Neovim 0.12) :
-- ne gère plus que l'installation des parsers + les queries.
-- Le highlighting est natif (vim.treesitter.start). Requiert `tree-sitter` CLI.
vim.pack.add {
  gh('nvim-treesitter/nvim-treesitter', { version = 'main' }),
  gh 'nvim-treesitter/nvim-treesitter-textobjects', -- queries @function, @class… (utilisées par mini.ai)
}

local ensure = {
  -- langages principaux
  'typescript',
  'tsx',
  'javascript',
  'jsdoc',
  'php',
  'phpdoc',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'zig',
  'rust',
  'ron',
  -- web / config / divers
  'html',
  'css',
  'json',
  'json5',
  'yaml',
  'toml',
  'sql',
  'graphql',
  'dockerfile',
  'bash',
  'fish',
  'lua',
  'luadoc',
  'vim',
  'vimdoc',
  'query',
  'regex',
  'markdown',
  'markdown_inline',
  'diff',
  'git_config',
  'git_rebase',
  'gitcommit',
  'gitignore',
  'make',
  'blade',
  'twig',
  'svelte',
  'vue',
}

local ts = require 'nvim-treesitter'
-- Installation asynchrone des parsers manquants uniquement
local installed = ts.get_installed()
local missing = vim.tbl_filter(function(l) return not vim.list_contains(installed, l) end, ensure)
if #missing > 0 then ts.install(missing) end

-- Active highlighting + indentation treesitter pour tout buffer qui a un parser
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user-treesitter', { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang or not pcall(vim.treesitter.start, ev.buf, lang) then return end
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Installer à la volée un parser pour un langage non listé : :TSInstall <lang>
