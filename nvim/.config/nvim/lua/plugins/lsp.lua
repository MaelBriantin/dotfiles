-- LSP natif Neovim 0.12 :
--   • nvim-lspconfig fournit uniquement des configs par défaut (dossier lsp/*.lua)
--   • on surcharge avec vim.lsp.config() et on active avec vim.lsp.enable()
--   • mason installe les binaires (serveurs, formatters, linters, debuggers)
--   • Rust est géré par rustaceanvim (rust-analyzer via rustup)
vim.pack.add {
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  gh 'folke/lazydev.nvim',
  gh('mrcjkb/rustaceanvim', { version = vim.version.range '*' }),
}

require('mason').setup()

-- ── Outils installés via mason (noms de paquets mason) ──────────────────
-- zls et rust-analyzer ne sont PAS ici : ils doivent coller à la version de
-- ta toolchain (zig / rustup), installe-les avec elle.
require('mason-tool-installer').setup {
  ensure_installed = {
    -- LSP
    'lua-language-server',
    'vtsls',
    'eslint-lsp',
    'intelephense',
    'gopls',
    'json-lsp',
    'yaml-language-server',
    'taplo',
    'copilot-language-server',
    -- Formatters
    'stylua',
    'prettierd',
    'gofumpt',
    'goimports',
    'php-cs-fixer',
    -- Linters
    'golangci-lint',
    'phpstan',
    -- Debuggers
    'delve',
    'codelldb',
    'js-debug-adapter',
    'php-debug-adapter',
  },
  run_on_start = true,
}

-- ── Serveurs à activer + surcharges ─────────────────────────────────────
-- Le nom = nom de config nvim-lspconfig (:h lspconfig-all).
local servers = {
  lua_ls = {
    settings = { Lua = { completion = { callSnippet = 'Replace' }, hint = { enable = true } } },
  },

  -- TypeScript / JavaScript. Alternative native ultra-rapide : 'tsgo'
  -- (TypeScript 7) — remplace vtsls par tsgo ici et dans mason si tu veux tester.
  vtsls = {
    settings = {
      vtsls = { autoUseWorkspaceTsdk = true, experimental = { completion = { enableServerSideFuzzyMatch = true } } },
      typescript = {
        updateImportsOnFileMove = { enabled = 'always' },
        inlayHints = {
          parameterNames = { enabled = 'literals' },
          variableTypes = { enabled = false },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
    },
  },
  eslint = {},

  intelephense = {
    -- Clé de licence (optionnelle) : ~/intelephense/licence.txt
    settings = { intelephense = { files = { maxSize = 5000000 } } },
  },

  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        usePlaceholders = true,
        staticcheck = true,
        semanticTokens = true,
        analyses = { unusedparams = true, unusedwrite = true, nilness = true, shadow = true },
        codelenses = { test = true, tidy = true, upgrade_dependency = true, generate = true },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  },

  zls = {
    settings = { zls = { enable_build_on_save = true, semantic_tokens = 'partial' } },
  },

  jsonls = {},
  yamlls = {},
  taplo = {},
}

for name, cfg in pairs(servers) do
  if next(cfg) then vim.lsp.config(name, cfg) end
end

-- N'active que les serveurs dont le binaire existe (évite les erreurs au
-- premier lancement, pendant que mason installe). Réessaie après install.
local function enable_available()
  for name in pairs(servers) do
    local cmd = (vim.lsp.config[name] or {}).cmd
    local bin = type(cmd) == 'table' and cmd[1] or nil
    if type(cmd) == 'function' or (bin and vim.fn.executable(bin) == 1) then vim.lsp.enable(name) end
  end
end
enable_available()
vim.api.nvim_create_autocmd('User', { pattern = 'MasonToolsUpdateCompleted', callback = vim.schedule_wrap(enable_available) })

-- lazydev : complétion de l'API Neovim quand on édite la config
require('lazydev').setup { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } }

-- ── Rust : rustaceanvim (gère rust-analyzer, tests, debug, macros…) ─────
vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        cargo = { allFeatures = true },
        check = { command = 'clippy' },
        inlayHints = { closureReturnTypeHints = { enable = 'with_block' } },
      },
    },
  },
}

-- ── Keymaps quand un serveur s'attache ──────────────────────────────────
-- Les defaults natifs (grn, gra, grr, gri, grt, gO, K…) sont déjà là ;
-- on ajoute des variantes fzf-lua + quelques extras.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    local fzf = require 'fzf-lua'
    local function map(keys, fn, desc, mode) vim.keymap.set(mode or 'n', keys, fn, { buffer = ev.buf, desc = 'LSP : ' .. desc }) end

    map('gd', fzf.lsp_definitions, 'Définition')
    map('gD', vim.lsp.buf.declaration, 'Déclaration')
    map('grr', fzf.lsp_references, 'Références')
    map('gri', fzf.lsp_implementations, 'Implémentations')
    map('grt', fzf.lsp_typedefs, 'Type definition')
    map('gra', fzf.lsp_code_actions, 'Code action', { 'n', 'x' })
    map('<leader>ci', fzf.lsp_incoming_calls, 'Appels entrants')
    map('<leader>co', fzf.lsp_outgoing_calls, 'Appels sortants')
    map('<leader>cr', vim.lsp.buf.rename, 'Renommer')
    map('<leader>cl', vim.lsp.codelens.run, 'Codelens')

    if client:supports_method 'textDocument/inlayHint' then
      map(
        '<leader>uh',
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = ev.buf }, { bufnr = ev.buf }) end,
        'Toggle inlay hints'
      )
    end

    -- Surligne les autres occurrences du symbole sous le curseur
    if client:supports_method 'textDocument/documentHighlight' then
      local hl = vim.api.nvim_create_augroup('user-lsp-hl-' .. ev.buf, { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { group = hl, buffer = ev.buf, callback = vim.lsp.buf.document_highlight })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { group = hl, buffer = ev.buf, callback = vim.lsp.buf.clear_references })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = hl,
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.clear_references()
          pcall(vim.api.nvim_del_augroup_by_id, hl)
        end,
      })
    end

    -- Codelens (ex: "run test" en Go) rafraîchis automatiquement
    if client:supports_method 'textDocument/codeLens' then vim.lsp.codelens.enable(true, { bufnr = ev.buf }) end
  end,
})

-- Rust : surcharges spécifiques rustaceanvim
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function(ev)
    local function map(keys, cmd, desc) vim.keymap.set('n', keys, cmd, { buffer = ev.buf, desc = 'Rust : ' .. desc }) end
    map('gra', function() vim.cmd.RustLsp 'codeAction' end, 'Code action (groupées)')
    map('K', function() vim.cmd.RustLsp { 'hover', 'actions' } end, 'Hover actions')
    map('<leader>ce', function() vim.cmd.RustLsp 'explainError' end, 'Expliquer l’erreur')
    map('<leader>cm', function() vim.cmd.RustLsp 'expandMacro' end, 'Expand macro')
    map('<leader>cR', function() vim.cmd.RustLsp 'runnables' end, 'Runnables')
  end,
})
