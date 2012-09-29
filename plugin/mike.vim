" Custom settings, the way I like things...

" Folding should always be done logically
set foldmethod=syntax
" Allow up to 8 columns to indicate folds
set foldcolumn=8
" On start, fold nothing
set foldlevel=99
" Line numbering on
set number
" Case insensitive, smart case style
set ignorecase
" Searches in lower case are treated as case insensitive. Adding one capital letter makes it case sensitive
set smartcase
" Automatically reload changes on disk (assuming there were no changes made in the buffer)
set autoread
" Write before switching buffers
set autowrite

" Display options
" Options that depend on the UI (win32, gtk, console)
if has("gui_running")
	if has("gui_gtk2")
		set guifont=Lucida\ Typewriter\ 11
	elseif has("gui_win32")
		set guifont=Consolas:h9
		" Fullscreen in windows
		au GUIEnter * simalt ~x 
	endif
	colorscheme delek2
else
	set laststatus=2
	" Best mouse tracking
	set ttymouse=xterm2
	" Use the mouse in (a)ll modes
	set mouse=a
	if &t_Co == 256
		colorscheme delek2
	else
		colorscheme delek
	endif
endif

" Statusline
set statusline=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%q      "quickfix / locationlist
"set statusline+=%{cfi#get_func_name()} "function name (uses the current-func-info plugin)
set statusline+=\ %{StlShowFunc()} "function name (uses the current-func-info plugin)
set statusline+=%=      "left/right separator
set statusline+=%c:%v,  "cursor column:virtual column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

" Don't overwrite our statusline with StlShowFunc's
let stlshowfunc_stlnofunc=&statusline
let stlshowfunc_stlfunc=&statusline

" Tabs are shown as a 4 space indent
set tabstop=4
" Automatic indent uses 4 spaces
set shiftwidth=4
" Use tabs, not spaces for indentation
set noexpandtab

" Easier searching using 'gf'
set path+=./inc,../inc,../../inc,../../../inc,../../../../inc,./include,../include,../../include,../../../include,../../../../include,
set browsedir=buffer
set tag+=../tags,../../tags,../../../tags,../../../../tags

" Mimic bash- tabs expand as far as they can go, and then show a list of the options
set wildmode=longest,list

" Remove the toolbar
set guioptions-=T

" CScope options
" Display 2 entries from the file name (dir/file)
set cscopepathcomp=2
" The following searches use the quickfix windows (replace, not append)
set cscopequickfix=s-,c-,d-,i-,t-,e-

" Show where spaces and tabs are mixed
let g:c_space_errors = 1

" Don't prompt for comments in ClearCase
let g:ccaseNoComment = 1

" Missed sudos
cmap w!! %!sudo tee > /dev/null %

" Pretty Print
map <f9> :%!`cleartool pwv -root`/vobs/CMS_INTEGRATION/msa/build/useful_stuff/indent-msl.sh<CR>
" Pretty print the visual highlight
map <leader><f9> :!`cleartool pwv -root`/vobs/CMS_INTEGRATION/msa/build/useful_stuff/indent-msl.sh<CR>

" Lookup the current highlight 
map <leader>hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#") . " BG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"bg#")<CR>

" Disable wrapping
:map <leader>w :set nowrap! <CR>

" Load cscope from the current view
map <f8> :cscope kill -1<CR>:let $CSCOPE_DB= system('cleartool pwv -root')[:-2] . "/vobs/CMS_INTEGRATION/msa/build/cscope.out"<CR>:cscope add $CSCOPE_DB<CR>:let $CSCOPE_DB= system('cleartool pwv -root')[:-2] . "/vobs/CMS_INTEGRATION/msa/build/cscope.py.out"<CR>:cscope add $CSCOPE_DB<CR>

" Quicklist scrolling
map <leader><PageDown> :cnext<CR>
map <leader><PageUp> :cprevious<CR>

" Grep on windows using grep instead of findstr
set grepprg=grep\ -nH

" Buffer tabbing
map <leader><Tab> :confirm bnext<CR>
map <leader><leader><Tab> :confirm bprevious<CR>

behave mswin
if has("win32")
	source $VIMRUNTIME/mswin.vim
else
	" Just take a few things that we know we want...
	set backspace=indent,eol,start whichwrap+=<,>,[,]
endif

" <leader>q toggles the quickfix window
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction
nmap <silent><leader>q :QFix<CR>

" Convert all sorts of fancy prints to basic ASCII. Used for e-book conversions
function! ToAscii()
	normal mZ
	%s///ge
	%s/\n\n\+/\r/ge
	%s/\t/ /ge
	%s/  \+/ /ge
	%s/[��]/"/ge
	%s/[��]/'/ge
	%s/�/c/ge
	%s/[��]/e/ge
	%s/�/u/ge
	%s/[��]/a/ge
	%s/[��]/o/ge
	%s/�/(c)/ge
	%s/�/-/ge
	normal `Z
endfunction


" <leader>z folds on the current search term
map <silent><leader>z :set foldexpr=getline(v:lnum)!~@/ foldlevel=0 foldmethod=expr<CR>
" Space expands or closes a fold
nnoremap <silent><space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<cr>
" Search shouldn't open a fold
set foldopen-=search

" For eclipsed files, we can't delete the original and rename, b/c it will undo the eclipse
set backupcopy=yes

" Switch to the current directory automatically
"set autochdir

" BufExplorer
:imap <F3> <ESC>:BufExplorer<CR>
:map <F3> :BufExplorer<CR>

" NERDTree
:imap <F4> <ESC>:NERDTreeToggle<CR>
:map <F4> :NERDTreeToggle<CR>
" Don't use the fancy unicode arrows
let g:NERDTreeDirArrows=0
" Default size is 60 characters instead of 31
let g:NERDTreeWinSize=60 
" Load NERDTree if no files were specified
" autocmd vimenter * if !argc() | NERDTree | endif

" GDB for MOR
if !has("win32")
" set gdbprg=/view/mmiller_ms_comp/vobs/FUSIONOS/BLD_PACE_BCM_MIPS4K_LNUX_VIASAT_01/platform_cfg/linux/compiler/mips4k_gcc_x86_linux_01/bin/mipsel-linux-uclibc-gdb
endif

" Ignore Fusion build warnings
set errorformat^=%-G%.%#library.mk.%#
set errorformat^=%-G%.%#libraries.mk%.%#
set errorformat^=%-G%.%#platform.mk%.%#
"set makeprg=cd\ `cleartool\ pwv\ -root`/vobs/CMS_INTEGRATION/msa/build\ ;\ ./makecomponent.sh\ --extra\ \"--cfg_avds=msl_avds_upc.cfg\ --cfg_stream=msl_streams_CI_BSKYB_HD_PVR.cfg\"

" Errorformat for KW files [modified by awk -F";" 'BEGIN {OFS=";";} {print $5,$2,$3,$7 " " $18 " (" $8 ") " $12}' ]
set errorformat+=%IStyle;%f;%l;%c;%m,%WWarning;%f;%l;%c;%m,%EError;%f;%l;%c;%m,%ECritical;%f;%l;%c;%m,%ESevere;%f;%l;%c;%m,%IInvestigate;%f;%l%c;%m

" Errorformat for MSL Python Unit Tests; ignore all lines starting with \.*NDS
set errorformat^=%-G.%#NDS%.%#

" Allow longer lines than the default 79 in python
let g:syntastic_python_checker_args = "--max-line-length=131"

" Ignore the special marks; only show the user defined local (a-z) and global (A-Z) marks
let g:showmarks_include="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

" Undo tree browser
nnoremap <F5> :GundoToggle<CR>

" Per project local files are named .vimrc.local, not _vimrc_local
let g:local_vimrc = ".vimrc.local"

" Reverse the sort with the best match on the top (right above the prompt)
let g:CommandTMatchWindowReverse=1
" Ignore these files
set wildignore+=*~,*.pyc

" YankRing quickview
nnoremap <silent> <F2> :YRShow<cr>
inoremap <silent> <F2> <ESC>:YRShow<cr>

" Tweaks for Ctrl-P
let g:ctrlp_use_caching=1
let g:ctrlp_follow_symlinks=1
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_clear_cache_on_exit=0
let g:ctrlp_working_path_mode='' 
let g:ctrlp_map = '<leader>p'

" Persistent undo
set undofile

