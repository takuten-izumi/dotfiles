set colorcolumn=80              " 80列目に線を入れる
set vb t_vb=                    " ベルをオフにする
set title                       " タイトルにpathが表示される
set number                      " 文頭に行数を表示する
set autoread                    " 編集中に別のところで編集されたら自動で読み込みます。
"set cursorline                  " 今いる行をハイライト
set hidden                      " 保存しなくてもバッファの切り替えができる
set mouse=a                     " マウスでカーソルの位置を指定できる
set noswapfile                  " swapファイルは使いません
set scrolloff=8                 " スクロール時に余白を取るようになる
set splitbelow                  " splitすると下に分かれる
set splitright                  " splitすると右に分かれる
set tags=.tags;~                " ctagsを遡って検索
set wildmenu wildmode=longest,full              " 補完の形を決める（vim互換性）
set autoindent                  " 改行したりした時にインデントを保持してくれます。
set expandtab                   " タブを押すと空白が挿入されるようにする
set nowrap                      " 折り返しをしない
set shiftwidth=4                " vimのインデントでいくつ空白を挿入するか
set softtabstop=4               " tabを押した時に空白何個分のインデントをとるか。
set tabstop=4                   " 一個のタブを空白何個分にとるか。
set incsearch                   " 文字検索時にリアルタイムで検索
set smartcase                   " 大文字小文字を区別せずに検索
set hlsearch                    " 検索した文字がハイライトされる
set showcmd                     " 入力中のコマンドを表示する
set whichwrap=b,s,h,l,<,>,[,]   " 行末、行頭で行を跨ぐことができる
set ttimeoutlen=10              " キーコードシーケンスが終了するのを待つ時間を短くする

syntax enable                   " 文字のハイライトをオンにする
colorscheme evening

"ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>
 
" プラグイン
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
let g:airline#extensions#tabline#enabled = 1
call plug#end()

"functions
" vimでC++をコンパイルして実行する
function! Cpprun()
    :w
    :!g++ % -o %:r.out
    :!./%:r.out
endfunction

command! Cpprun call Cpprun()
noremap <F2> :Cpprun<CR><CR>

" vimでpythonをRunする
function! Pythonrun()
    :w
    :!python %
endfunction

command! Pythonrun call Pythonrun()
noremap <F3> :Pythonrun<CR><CR>
 
" normalモードにした時に自動でclang-formatをしてくれる
function! s:clang_format()
    if executable('clang-format')
        let now_line = line(".")
        :%! clang-format -style=file
        exec ":" . now_line
    endif
endfunction

if executable('clang-format')
   augroup cpp_clang_format
       autocmd!
       autocmd BufWrite,FileWritePre,FileAppendPre *.[ch]pp call s:clang_format()
   augroup END
endif

" C++テンプレートを読み込む
function! Template_cpp()
    :w
    :r ~/Templates/cpp.cpp
endfunction

command! Tempcpp call Template_cpp()

"中括弧を展開した時にインデントを付け足す
function! AddIndentWhenEnter()
    if getline(".")[col(".")-1] == "}" && getline(".")[col(".")-2] == "{"
        return "\n\t\n\<UP>\<END>"
    else
        return "\n"
    endif
endfunction

"keymap
inoremap <silent> <expr> <CR> AddIndentWhenEnter()
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
"inoremap < <><LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap ` ``<LEFT>
