return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    -- Ejecuta el comando build solo en sistemas Unix (Linux/macOS)
    build = function()
      -- Solo ejecutar en MacOS o Linux
      if vim.fn.has("win32") ~= 1 then
        return "make tiktoken"
      end
    end,
    opts = {
      -- Configuración básica
      debug = false,  -- Habilitar logging para depuración
      proxy = nil,    -- Configura un proxy si es necesario
      model = "claude-sonnet-4",  -- Modelo de Anthropic a utilizar
    },
  },
}
