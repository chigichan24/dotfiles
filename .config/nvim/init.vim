call plug#begin()

" List your plugins here
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'

call plug#end()


lua << END
require('lualine').setup {
  options = {
    theme = 'everforest'
  }
}
require('gitsigns').setup()
END

set number
set cursorline
set ruler
set showcmd
set showmatch
set hlsearch
set whichwrap=b,s,h,l,<,>,[,],~
set hidden
set ts=2 sts=0 sw=2 et
set smartindent
set cindent
set noswapfile
set fileencodings=utf-8,euc-jp,ucs-bom,iso-2022-jp,sjis,cp932,latin1
set nowrap
