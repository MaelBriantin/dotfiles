-- Svelte 5 support with TypeScript and runes autocompletion
return {
  {
    'L3MON4D3/LuaSnip',
    config = function()
      local ls = require('luasnip')
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local fmt = require('luasnip.extras.fmt').fmt

      -- Add Svelte 5 runes snippets
      ls.add_snippets('svelte', {
        s('$props', fmt('let {{ {} }} = $props();', { i(1, 'prop') })),
        s('$state', fmt('let {} = $state({});', { i(1, 'count'), i(2, '0') })),
        s('$derived', fmt('let {} = $derived({});', { i(1, 'value'), i(2, 'expression') })),
        s('$effect', fmt('$effect(() => {{\n\t{}\n}});', { i(1, '// effect code') })),
        s('$bindable', fmt('let {{ {} = $bindable() }} = $props();', { i(1, 'value') })),
        s('$inspect', fmt('$inspect({});', { i(1, 'value') })),
        s('$host', t('$host()')),
      })

      -- Also add them to TypeScript in script tags
      ls.add_snippets('typescript', {
        s('$props', fmt('let {{ {} }} = $props();', { i(1, 'prop') })),
        s('$state', fmt('let {} = $state({});', { i(1, 'count'), i(2, '0') })),
        s('$derived', fmt('let {} = $derived({});', { i(1, 'value'), i(2, 'expression') })),
        s('$effect', fmt('$effect(() => {{\n\t{}\n}});', { i(1, '// effect code') })),
        s('$bindable', fmt('let {{ {} = $bindable() }} = $props();', { i(1, 'value') })),
        s('$inspect', fmt('$inspect({});', { i(1, 'value') })),
        s('$host', t('$host()')),
      })
    end,
  },
}
