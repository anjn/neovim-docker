-- Auto install jetpack
local jetpackfile = vim.fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
local jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if vim.fn.filereadable(jetpackfile) == 0 then
    vim.fn.system(string.format('curl -fsSLo %s --create-dirs %s', jetpackfile, jetpackurl))
end

vim.cmd [[ let g:python3_host_prog = '/usr/bin/python3' ]]
vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]
vim.cmd [[ set updatetime=100 ]]

vim.cmd('packadd vim-jetpack')
require('jetpack.packer').add {
    { 'tani/vim-jetpack', opt = 1 },
    'junegunn/fzf.vim',
    'MunifTanjim/nui.nvim',
    -- colorscheme
    'EdenEast/nightfox.nvim',
    'folke/tokyonight.nvim',
    { "bluz71/vim-moonfly-colors", as = "moonfly" },
    'jacoborus/tender.vim',
    -- mason
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    -- lsp
    'neovim/nvim-lspconfig',
    -- nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/nvim-cmp',
    -- vsnip
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',
    -- lspsaga
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
    {
        "glepnir/lspsaga.nvim",
        opt = true,
        branch = "main",
        event = "LspAttach",
        config = function()
            require("lspsaga").setup({})
        end,
    },

    'onsails/lspkind.nvim',
    'j-hui/fidget.nvim',
    'folke/lsp-colors.nvim',

    -- telescope
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim',
      run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    },
    { 'nvim-telescope/telescope.nvim', tag = '0.1.1' },

    "kkharji/sqlite.lua",
    { "nvim-telescope/telescope-frecency.nvim",
      config = function()
          require"telescope".load_extension("frecency")
      end,
    },

    -- lualine
    'nvim-lualine/lualine.nvim',
  
    { 'stevearc/aerial.nvim',
      config = function() require('aerial').setup() end
    },
  
    { "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
    },
  
    -- display
    'myusuf3/numbers.vim',
    'petertriho/nvim-scrollbar',
    'lukas-reineke/indent-blankline.nvim',
    'airblade/vim-gitgutter',
  
    -- clipboard
    'gbprod/yanky.nvim',
    'AckslD/nvim-neoclip.lua',
  
    -- edit
    'numToStr/Comment.nvim',
    'windwp/nvim-autopairs',
    'deris/vim-rengbang',
}

-- colorscheme
require("tokyonight").setup {
    style = "night",
}

vim.cmd [[
try
colorscheme nightfox
catch /^Vim\%((\a\+)\)\=:E185/
colorscheme default
set background=dark
endtry
]]

vim.cmd [[ hi Comment gui=NONE ]] -- disable italic

-- mason
require('mason').setup()
require("mason-lspconfig").setup {
    automatic_installation = true,
}
require('mason-lspconfig').setup_handlers({ function(server)
    require('lspconfig')[server].setup {
        on_attach = function(client, bufnr)
            local bufopts = { noremap=true, silent=true, buffer=bufnr }
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        end,
        capabilities = require('cmp_nvim_lsp').default_capabilities()
    }
end })

-- lspconfig
require'lspconfig'.clangd.setup {
    filetypes = { "c", "cpp", "hpp" },
}
require'lspconfig'.pyright.setup {}

-- nvim-cmp
local cmp = require'cmp'
local lspkind = require('lspkind')

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'nvim_lsp_signature_help' },
    },
    formatting = {
        format = lspkind.cmp_format({})
    },
})

-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "markdown", "markdown_inline" },
    auto_install = true,
}

-- lsp
require"fidget".setup {}

require('lualine').setup {
    options = {
        theme = 'moonfly',
    },
}

require("neo-tree").setup {}

-- scrollbar
require("scrollbar").setup {
    excluded_buftypes = {
        "terminal",
    },
    excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
        "noice",
        "neo-tree",
        "aerial",
    },
}

-- number
vim.cmd [[ let g:numbers_exclude = ['neo-tree', 'aerial', 'terminal'] ]]

-- indent-blankline
vim.opt.list = true

require("indent_blankline").setup {}

-- edit
require('neoclip').setup {}
vim.cmd [[ lua require('telescope').load_extension('neoclip') ]]

require("yanky").setup {}
vim.cmd [[ lua require("telescope").load_extension("yank_history") ]]

require('Comment').setup {}
require("nvim-autopairs").setup {}

-- options
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
-- tab/indent
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- search
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts)

-- keymap
keymap("n", "tc", ":tabedit<Return>", opts)
keymap("n", "tn", ":tabNext<Return>", opts)
keymap("n", "tp", ":tabprevious<Return>", opts)

keymap("n", "tt", "<cmd>terminal bash<cr>", opts)
keymap("n", "tx", "<cmd>belowright new<CR><cmd>terminal bash<cr>", opts)

keymap("n", ",t", ":Neotree toggle<Return>", opts)

keymap('n', ',f', '<cmd>lua require("telescope.builtin").find_files()<cr>', {noremap = true})
keymap('n', ',b', '<cmd>lua require("telescope.builtin").buffers()<cr>', {noremap = true})
keymap('n', ',h', '<cmd>lua require("telescope.builtin").help_tags()<cr>', {noremap = true})
keymap('n', ',y', '<cmd>lua require("telescope").extensions.neoclip.default()<cr>', {noremap = true})
keymap('n', ',p', '<cmd>lua require("telescope").extensions.yank_history.yank_history()<cr>', {noremap = true})
keymap('n', ',a', '<cmd>AerialToggle<cr>', {noremap = true})

keymap('n', '<c-n>', '<Plug>(YankyCycleForward)', opts)
keymap('n', '<c-p>', '<Plug>(YankyCycleBackward)', opts)

-- terminal
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
    pattern = '*',
    callback = function(args)
        vim.cmd [[ setlocal norelativenumber ]]
        vim.cmd [[ setlocal nonumber ]]
        vim.cmd [[ startinsert ]]
    end,
})
