-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.plugins = {
  { "folke/tokyonight.nvim" },
  -- https://github.com/LunarVim/LunarVim/issues/1843#issuecomment-950328561
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
  },
  -- https://betterprogramming.pub/lunarvim-debugging-testing-python-code-fa84f804c469
 "mfussenegger/nvim-dap-python",
 "nvim-neotest/neotest",
 "nvim-neotest/neotest-python",
}

-- https://betterprogramming.pub/lunarvim-debugging-testing-python-code-fa84f804c469
lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function()
 require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)
