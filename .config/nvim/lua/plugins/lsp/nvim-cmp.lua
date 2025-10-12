return {
  'hrsh7th/nvim-cmp',
  enabled = true,
  event = { 'InsertEnter' },
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp',                event = 'InsertEnter' },
    { 'hrsh7th/cmp-nvim-lua',                event = 'InsertEnter' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help', event = 'InsertEnter' },
    { 'hrsh7th/cmp-buffer',                  event = 'InsertEnter' },
    { 'ray-x/cmp-treesitter',                event = 'InsertEnter' },
    { 'hrsh7th/cmp-path',                    event = { 'InsertEnter', 'CmdlineEnter' } },
    { 'saadparwaiz1/cmp_luasnip',            event = 'InsertEnter' },
    { 'octaltree/cmp-look',                  event = 'InsertEnter' },
    -- { 'chrisgrieser/cmp_yanky',            event = 'InsertEnter' },
  },
  --
  config = function()
    -- ╭───────────────╮
    -- │ LOAD SNIPPETS │
    -- ╰───────────────╯
    require('luasnip/loaders/from_lua').load { paths = { '~/.config/nvim/snippets/' } }
    require('luasnip/loaders/from_vscode').lazy_load()

    -- ╭────────────────╮
    -- │ COMPLETEOPTION │
    -- ╰────────────────╯
    vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

    -- ╭────────────╮
    -- │ KIND ICONS │
    -- ╰────────────╯
    local kind_icons = {
      Class = ' ',
      Color = ' ',
      Comment = '//',
      Constant = ' ',
      Constructor = ' ',
      Enum = ' ',
      EnumMember = ' ',
      Event = '',
      Field = '󰄶 ',
      File = ' ',
      Folder = ' ',
      Function = 'ƒ ',
      Interface = ' ',
      Keyword = '󰌆 ',
      Method = ' ',
      Module = '󰏗 ',
      Operator = '󰆕 ',
      Property = ' ',
      Reference = ' ',
      Snippet = ' ',
      String = '󱌯 ',
      Struct = ' ',
      Text = ' ',
      TypeParameter = '󰅲 ',
      Unit = ' ',
      Value = '󰎠 ',
      Variable = '󰀫',
    }

    -- ╭──────────────╮
    -- │ LOAD LUASNIP │
    -- ╰──────────────╯
    local luasnip = require 'luasnip'

    -- ╭──────────╮
    -- │ LOAD CMP │
    -- ╰──────────╯
    local cmp = require 'cmp'

    -- ╭───────────╮
    -- │ CMP SETUP │
    -- ╰───────────╯
    cmp.setup {
      enabled = function()
        local ft = vim.bo.filetype
        -- Disable completions in text files
        if ft == "text" or ft == "txt" then
          return false
        end
        return true
      end,
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = {
          border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
          winhighlight = 'Normal:CmpPmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
        },
        documentation = {
          border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
          winhighlight = 'Normal:CmpPmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
        },
      },
      view = {
        entries = {
          name = 'custom',
          selection_order = 'near_cursor',
          follow_cursor = true,
        },
      },
      mapping = cmp.mapping.preset.insert {
        -- ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        -- ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        -- ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        -- ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-k>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        ['<C-j>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping {
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        },
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        -- ['<CR>'] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         if luasnip.expandable() then
        --             luasnip.expand()
        --         else
        --             cmp.confirm({
        --                 select = true,
        --             })
        --         end
        --     else
        --         fallback()
        --     end
        -- end),
        ['<C-CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        -- { name = 'cmp_yanky' },
        { name = 'nvim_lua' },
        { name = 'treesitter' },
        {
          name = 'look',
          keyword_length = 3,
          option = {
            convert_case = true,
            loud = true,
          },
          max_item_count = 5,
        },
      },
      formatting = {
        fields = { 'abbr', 'kind', 'menu' },
        format = function(entry, vim_item)
          -- Kind icons
          -- This concatenates the icons with the name of the item kind
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
          -- Trim text function
          function trim(text)
            local max = 40
            if text and text:len(1, max) > max then
              text = text:sub(1, max) .. '...'
            end
            return text
          end

          vim_item.abbr = trim(vim_item.abbr)
          -- Source
          vim_item.menu = ({
            nvim_lsp = '( LSP )',
            nvim_lsp_signature_help = '( Signature )',
            luasnip = '( LuaSnip )',
            buffer = '( Buffer )',
            -- cmp_yanky = '( Yanky )',
            path = '( Path )',
            nvim_lua = '( Lua )',
            treesitter = '( Treesitter )',
            look = '( Look )',
            -- cmdline = '(CMDLine)',
          })[entry.source.name]
          return vim_item
        end,
      },
      sorting = {
        comparators = {
          -- require("clangd_extensions.cmp_scores"),
          cmp.config.compare.score,
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.recently_used,
          cmp.config.compare.length,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.order,
        },
      },
      experimental = {
        ghost_text = true,
      },
    }
  end,
}
