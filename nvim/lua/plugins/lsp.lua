return {}

-- one day get back to LSPs. But do it from scratch. Main annoyance: diagnostic virtual text everywhere in my face
--[[
return {
  {
    "williamboman/mason.nvim",
    enabled = true,
    config = function()
      require("mason").setup({})
    end
  },
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    config = function()
      local lspc = require("lspconfig")
      lspc.ts_ls.setup({
        exclude = "node_modules",
        on_attach = function(client)
          print("lua_ls on_attach")
          client.server_capabilities.diagnosticProvider = false
        end
      })

      lspc.lua_ls.setup({
        on_attach = function(client)
          client.server_capabilities.diagnosticProvider = false
        end
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = true,
  }
}
--]]
