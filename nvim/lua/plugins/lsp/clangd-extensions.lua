return {
  -- :ClangdSwitchSourceHeader to switch between source/header
  --:ClangdAST to view the ast with the current line as the range,
  --:ClangdSymbolInfo with the cursor at the desired symbol.
  --:ClangdTypeHierarchy with the cursor over the desired type or a symbol of that type
  --:ClangdMemoryUsage. Preamble can be large so it is collapsed by default, to expand it use :ClangdMemoryUsage expand_preamble
  'p00f/clangd_extensions.nvim',
  event = 'VeryLazy',
  config = function()
    require("clangd_extensions").setup({
      ast = {
        -- These are unicode, should be available in any font
        -- role_icons = {
        --   type = "🄣",
        --   declaration = "🄓",
        --   expression = "🄔",
        --   statement = ";",
        --   specifier = "🄢",
        --   ["template argument"] = "🆃",
        -- },
        -- kind_icons = {
        --   Compound = "🄲",
        --   Recovery = "🅁",
        --   TranslationUnit = "🅄",
        --   PackExpansion = "🄿",
        --   TemplateTypeParm = "🅃",
        --   TemplateTemplateParm = "🅃",
        --   TemplateParamObject = "🅃",
        -- },
        -- These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },

        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },

        highlights = {
          detail = "Comment",
        },
      },
      memory_usage = {
        border = "double",
      },
      symbol_info = {
        border = "double",
      },
    })
  end
}
