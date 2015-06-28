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
" do incremental searching
set incsearch

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Automatically reload changes on disk (assuming there were no changes made in the buffer)
set autoread
" Write before switching buffers
set autowrite
" keep 50 lines of command line history
set history=500
" show the cursor position all the time
set ruler
" display incomplete commands
set showcmd

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else
  set autoindent		" always set autoindenting on
endif " has("autocmd")
"
" I might move to solarized (http://ethanschoonover.com/solarized/vim-colors-solarized) soon. Until then, since I haven't changed PuTTY colors (and neither has anyone else), we'll set the override that uses estimates.
if ((! has("gui_win32")) && &t_Co == 256)
	if (!exists("$SOLARIZED"))
		let g:solarized_termcolors=256
	endif
endif
let g:solarized_contrast = "high"


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
	colorscheme solarized
	set background=dark
else
	" Best mouse tracking
	set ttymouse=xterm2
	" Use the mouse in (a)ll modes
	set mouse=a
	if &t_Co == 256
		if (exists("$SOLARIZED"))
			colorscheme solarized
			set background=dark
		else
			colorscheme delek2
		endif
	else
		colorscheme delek
	endif
endif
" Always show a statusbar
set laststatus=2

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
set statusline+=\ %{exists('g:loaded_StlShowFunc')?StlShowFunc():''} "function name (uses the current-func-info plugin)
"Don't use this, since it shows the previous function if we're between functions. StlShowFunc gets it right.
"set statusline+=\ %{tagbar#currenttag('[%s]\ ','')}
set statusline+=%=      "left/right separator
set statusline+=\ %{exists('g:loaded_Timestamp')?TimestampGetDelta():''} "Delta 
set statusline+=\ %{exists('g:loaded_fugitive')?fugitive#statusline():''} " Current git branch
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
set tag+=./tags;

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
map <f9> :%!indent --blank-before-sizeof --blank-lines-after-commas --blank-lines-after-declarations --blank-lines-after-procedures --brace-indent0 --braces-after-func-def-line --braces-after-func-def-line --braces-after-if-line --braces-after-struct-decl-line --case-brace-indentation0 --case-indentation8 --cuddle-do-while --declaration-indentation16 --dont-break-function-decl-args --dont-break-function-decl-args-end --dont-break-procedure-type --dont-cuddle-else --indent-level8 -l999 --no-space-after-parentheses --space-after-for --space-after-while --space-special-semicolon --space-after-if --swallow-optional-blank-lines --use-tabs<CR>

" Pretty print the visual highlight
map <leader><f9> :!indent --blank-before-sizeof --blank-lines-after-commas --blank-lines-after-declarations --blank-lines-after-procedures --brace-indent0 --braces-after-func-def-line --braces-after-func-def-line --braces-after-if-line --braces-after-struct-decl-line --case-brace-indentation0 --case-indentation8 --cuddle-do-while --declaration-indentation16 --dont-break-function-decl-args --dont-break-function-decl-args-end --dont-break-procedure-type --dont-cuddle-else --indent-level8 -l999 --no-space-after-parentheses --space-after-for --space-after-while --space-special-semicolon --space-after-if --swallow-optional-blank-lines --use-tabs<CR>

" Lookup the current highlight 
map <leader>hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#") . " BG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"bg#")<CR>

" Disable wrapping
:map <leader>w :set nowrap! <CR>

" Quicklist scrolling
map <leader><PageDown> :cnext<CR>
map <leader><PageUp> :cprevious<CR>

" Grep on windows using grep instead of findstr
set grepprg=grep\ -nH

" Buffer tabbing
"map <leader><Tab> :confirm bnext<CR>
"map <leader><leader><Tab> :confirm bprevious<CR>
" Use minibufexpl's functions instead of bnext. This way we won't select "real" buffers in special windows
map <leader><Tab> :confirm MBEbn<CR>
map <leader><leader><Tab> :confirm MBEbp<CR>
" Wrap around (this is the default for bnext, but not for MBEbn)
let g:miniBufExplCycleArround=1

behave mswin
if has("win32")
	source $VIMRUNTIME/mswin.vim
else
	" Just take a few things that we know we want...
	set backspace=indent,eol,start whichwrap+=<,>,[,]
	" Windows (not xterm) handling
	behave mswin
endif

" <leader>q toggles the quickfix window
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    botright copen 10
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
	%s/[“”]/"/ge
	%s/[‘’]/'/ge
	%s/ç/c/ge
	%s/[éë]/e/ge
	%s/ü/u/ge
	%s/[äâ]/a/ge
	%s/[óö]/o/ge
	%s/©/(c)/ge
	%s/—/-/ge
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

" Tagbar instead of taglist, which is horribly out of date
:imap <F8> :TagbarToggle<CR>
:map <F8> :TagbarToggle<CR>
" Open on the left side (like source insight)
let g:tagbar_left = 1
" Save some screen
let g:tagbar_compact = 1

" Ignore Fusion build warnings
set errorformat^=%-G%.%#library.mk.%#
set errorformat^=%-G%.%#libraries.mk%.%#
set errorformat^=%-G%.%#platform.mk%.%#

" Errorformat for KW files [modified by awk -F";" 'BEGIN {OFS=";";} {print $5,$2,$3,$7 " " $18 " (" $8 ") " $12}' ]
set errorformat+=%IStyle;%f;%l;%c;%m,%WWarning;%f;%l;%c;%m,%EError;%f;%l;%c;%m,%ECritical;%f;%l;%c;%m,%ESevere;%f;%l;%c;%m,%IInvestigate;%f;%l%c;%m

" Errorformat for MSL Python Unit Tests; ignore all lines starting with \.*NDS
set errorformat^=%-G.%#NDS%.%#

" Allow longer lines than the default 79 in python
let g:syntastic_python_checker_args = "--max-line-length=131"

" Ignore the special marks; only show the user defined local (a-z) and global (A-Z) marks
let g:showmarks_include="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

" Undo tree browser
nnoremap <F6> :GundoToggle<CR>

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
let g:ctrlp_user_command = ['cscope.files', 'cat %s/cscope.files']

" Persistent undo
set undofile

" Only sync from master to slave. It seems the other way isn't working right now
let g:LogViewer_SyncAll = 0

" Gitgutter is a bit slow sometimes
let g:gitgutter_enabled = 0 

" From http://vim.wikia.com/wiki/Autoloading_Cscope_Database; search parent directories for cscope DB
function! LoadCscope()
	let db = findfile("cscope.out", ".;")
	if (!empty(db))
		let path = strpart(db, 0, match(db, "/cscope.out$"))
		set nocscopeverbose " suppress 'duplicate connection' error
		exe "cs add " . db . " " . path
		set cscopeverbose
	endif
endfunction
au BufEnter /* call LoadCscope()

" Ignore line length in python files
let g:syntastic_python_pylint_args="--disable C0301"
let g:syntastic_python_flake8_args="--max-line-length=999"

