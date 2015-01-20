call pathogen#infect()

filetype plugin indent on
set nocp
set tabstop=4
set expandtab
set smarttab
set autoindent
set smartindent
set shiftwidth=4
set shiftround
set number
set hlsearch
set incsearch
set foldmethod=indent
set foldlevel=99
set nocompatible
syntax enable

set background=dark

" Configure the colorscheme based on the terminal
if &term =~ "xterm"
   colorscheme solarized
else
   colorscheme railscasts
endif

let perl_include_pod=1

set laststatus=2

"Use TAB to complete when typing words, else inserts TABs as usual.
"Uses dictionary and source files to find matching words to complete.

"See help completion for source,
"Note: usual completion is on <C-n> but more trouble to press all the time.
"Never type the same word twice and maybe learn a new spellings!
"Use the Linux dictionary when spelling is in doubt.
"Window users can copy the file to their machine.
function! Tab_Or_Complete()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-N>"
    else
        return "\<Tab>"
    endif
endfunction
"inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
set dictionary="/usr/dict/words"
augroup filetypedetect
    " Mail
    autocmd BufRead,BufNewFile *mutt-*  set textwidth=70
    " Template Toolkit
    autocmd BufRead,BufNewFile *.tt set filetype=html
    " Jade templates
    autocmd BufRead,BufNewFile *.jade set filetype=jade
augroup END

nnoremap <leader>pt :%! myperltidy
nmap <leader><Up> ddkP
nmap <leader><Down> ddp
vmap <C-Up> xkp`[V`]
vmap <C-Down> xp`[V`]

nnoremap <leader>j :JavaSearchContext
nnoremap <leader>i :JavaImport
nnoremap <leader>c :JavaCorrect

nnoremap - maO<esc>`a
nnoremap _ mao<esc>`a

let g:tracServerList = {}       
let g:tracServerList['Vim Trac - vimtrac user'] = 'http://vimtracuser:wibble@www.ascetinteractive.com.au/vimtrac/login/xmlrpc'
let g:tracServerList['imtrac'] = 'http://alex:auGheix2@www.intermine.org/login/xmlrpc' 

function! s:RunShellCommand(cmdline)
  botright lwindow
  lexpr system(escape(a:cmdline,'%#'))
  lopen
  1
endfunction

" Open NERDTree for ruby, perl, python, coffee, java, less and js
autocmd vimenter *.rb,*.pl,*.py,*.coffee,*.java,*.less,*.js NERDTree
" Go to previous (last accessed) window.
autocmd VimEnter * wincmd p
" On exit, also close NERDTree
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()


map <C-n> :NERDTreeToggle<CR>
map <C-h> :NERDTreeFind<CR>

" taken from https://github.com/scrooloose/nerdtree/issues/21
" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

""""""""""""""""""""""""""
" Python section
""""""""""""""""""""""""""

let python_highlight_all = 1
au FileType python syn keyword True None False self

""""""""""""""""""""""""""
" Perl section
""""""""""""""""""""""""""

autocmd BufRead,BufNewFile *.pl,*.t,*.pm
      \ command! -complete=file -nargs=+ Test call s:RunShellCommand('prove -v '.<q-args> )
autocmd BufRead,BufNewFile *.pl,*.t,*.pm
      \ command! -complete=file -nargs=+ LiveTest call s:RunShellCommand('RELEASE_TESTING=1 prove -v '.<q-args>)

""""""""""""""""""""""""""
" Ruby section
""""""""""""""""""""""""""

autocmd BufRead,BufNewFile *.rb
    \ command! -complete=file Test call s:RunShellCommand('rake test')
autocmd BufRead,BufNewFile *.rb
    \ command! -complete=file LiveTest call s:RunShellCommand('rake live_tests')

""""""""""""""""""""""""""
" Coffee-Script section
""""""""""""""""""""""""""

" Use two-space indentation.
au BufNewFile,BufReadPost *.coffee,Cakefile setl cc=100 foldmethod=indent ts=2 sw=2
" Make files on write to catch errors
au BufWritePost *.coffee,Cakefile make!
let coffee_linter = './node_modules/coffeelint/bin/coffeelint'
let coffee_lint_options = '-f ./coffeelint.json'
let coffee_make_options = '-o /tmp'

""""""""""""""""""""""""""
" JSON section
""""""""""""""""""""""""""
au BufWritePost *.json ! cat <afile> | json_pp | echo 'ok'

""""""""""""""""""""""""""
" Jade section
""""""""""""""""""""""""""

au BufNewFile,BufReadPost *.jade setl foldmethod=indent ts=2 sw=2

""""""""""""""""""""""""""
" JS Section
""""""""""""""""""""""""""

au Filetype javascript setlocal ts=2 sts=2 sw=2 expandtab

""""""""""""""""""""""""""
" Markdown section
""""""""""""""""""""""""""

au BufNewFile,BufReadPost *.md setl syntax=markdown
au FileType markdown setl ts=4 sw=4 cc=100 tw=80

" Store all swap files in central location
set backupdir=~/.vim/tmp,~/.tmp,/tmp
set directory=~/.vim/tmp,~/.tmp,/tmp

" Show whitespace by default, toggle with leader-s
set listchars=tab:>-,trail:.,eol:$
nmap <silent> <leader>s :set nolist!<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Makes directories if they do not exist on write.
" See: http://stackoverflow.com/questions/4292733/vim-creating-parent-directories-on-save
""""""""""""""""""""""""""""""""""""""""""""""""""
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction

augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
