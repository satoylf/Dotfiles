--TODO: Dbee (sql test) + sqlite;

--NOTE: "mfussenegger/nvim-jdtls", "nvim-bqf", "jaq", "numb", "neogit", "diffviewnvim", "rust-toolsnvim", "crates", "gopher.nvim", "nvimdapgo"
-- "typescript", "gpt", "copilot", "neoAi"

------------------------------------------------------------------------------------------------------------------- 
lvim.plugins = {
  {
    "mawkler/modicator.nvim",
    event = "ColorScheme",
  },
  "stevearc/dressing.nvim",
  "AckslD/swenv.nvim",
  "tanvirtin/monokai.nvim",
  "sainnhe/sonokai",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "opalmay/vim-smoothie",
  {
    "j-hui/fidget.nvim",
    branch = "legacy",
  },
  "windwp/nvim-ts-autotag",
  "kylechui/nvim-surround",
  "christianchiarulli/harpoon",
  "NvChad/nvim-colorizer.lua",
  "moll/vim-bbye",
  "folke/todo-comments.nvim",
  "windwp/nvim-spectre",
  "f-person/git-blame.nvim",
  "ruifm/gitlinker.nvim",
  "mattn/vim-gist",
  "mattn/webapi-vim",
  {
    "lvimuser/lsp-inlayhints.nvim",
    branch = "anticonceal",
  },
  { "christianchiarulli/telescope-tabs", branch = "chris" },
  "neanias/everforest-nvim",
  "ellisonleao/gruvbox.nvim",
  "rmehri01/onenord.nvim",
  "AlexvZyl/nordic.nvim",
  "Mofiqul/dracula.nvim",
  "catppuccin/nvim",
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  "mfussenegger/nvim-jdtls"
}
