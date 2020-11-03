syntax clear
syntax case match
set concealcursor=nc
set conceallevel=3

"*****************************************************************************
"** General columns, and their order                                        **
"*****************************************************************************

" Add any highlights that should be noted even in the main text prints
" This has to be first, b/c vim is annoying.

syntax match csvOther /,[[:alnum:]_]\+=[^,]\+,/ms=s+1,me=e-1 contains=csvDuration,csvIpSrc
syntax match csvTimestamp /^[^,]*,/me=e-1
syntax match csvFCID /,FCID=[^,]*,/me=e-1,ms=s+1,hs=s+5
syntax match csvIpSrc /,ipSrc=[^,]*,/me=e-1,ms=s+1 ",hs=s+6 
syntax match csvIpDst /,ipDst=[^,]*,/me=e-1,ms=s+1 ",hs=s+6
syntax match csvHttpMethod /,httpMethod=[^,]*,/me=e-1,ms=s+1
syntax match csvUrl /,url=[^,]*,/me=e-1,ms=s+1,hs=s+4
syntax match csvDuration /,duration=[^,]*,/ms=s+10,he=e-1 contains=csvLongTime
syntax match csvRequestTime /,request_time=[^,]*,/ms=s+9,he=e-1 contains=csvLongTime
syntax match csvUpstreamResponseTime /,upstream_response_time=[^,]*,/ms=s+9,he=e-1 contains=csvLongTime
syntax match csvLongTime /=[1-9]\+\.[[:digit:]]*,/ms=s+1,me=e-1 

" syntax match csvKeys /,[[:alnum:]]\+=/ms=s+1,me=e+1
highlight link csvOther Comment
highlight link csvTimestamp Type
highlight link csvFCID Type
highlight link csvUrl String
highlight link csvDuration Type
highlight link csvRequestTime Type
highlight link csvUpstreamResponseTime Type
highlight csvLongTime ctermbg=Red ctermfg=White

"highlight link csvKeys Comment
"syntax match ndsHeaders /^\(PASSED\|FAILED\)\?NDS:.* > /me=e-3 contains=ndsPythonTimestamp,ndsProcess,ndsThread,ndsLogger,ndsModule,ndsFunction,ndsFCID,ndsLine,ndsError,ndsWarning,ndsInfo,ndsDebug
"syntax match ndsPass /^PASSED/ 
"syntax match ndsFail /^FAILED/ 
"syntax match ndsPythonTimestamp /\^\d\{2\}\/\d\{2\}\/\d\{2\} \d\{2\}:\d\{2\}:\d\{2\} / contained
"syntax match ndsProcess /<p:\d\+ / contained
"syntax match ndsThread /T:[[:alnum:]._]\+ / contained
"syntax match ndsLogger /t:[[:alnum:]._]\+ / contained
"syntax match ndsModule /M:[[:alnum:]._]\+ / contained
"syntax match ndsFunction /F:[[:alnum:]._]\+ / contained
"syntax match ndsFCID /FCID:[[:alnum:]._]\+ / contained
"syntax match ndsLine /L:[0-9]\+/ contained
"syntax match ndsError /!ERROR */he=e-1 contained
"syntax match ndsWarning /!WARNING */he=e-1 contained
"syntax match ndsInfo /!INFO */he=e-1 contained
"syntax match ndsDebug /!DEBUG */he=e-1 contained
"syntax match ndsText / > .*$/ms=s+3 contains=r_ok_fail,step

"highlight ndsPass guibg=Green ctermbg=Green ctermfg=White
"highlight ndsFail guibg=Red guifg=White ctermbg=Red ctermfg=White

"highlight link ndsPythonTimestamp Type
"highlight link ndsProcess Comment
"highlight link ndsThread Comment
"highlight link ndsLogger Type
"highlight link ndsModule Type
"highlight link ndsFunction Type
"highlight link ndsFCID Comment
"highlight link ndsLine Type
"highlight link ndsText String
"highlight ndsError guibg=Red guifg=White ctermbg=Red ctermfg=White
"highlight ndsWarning guibg=LightRed ctermbg=LightRed ctermfg=Black
"highlight ndsInfo ctermfg=White
"highlight ndsDebug ctermfg=Gray

syntax match r_ok_fail /r\.ok = False/ contained
highlight r_ok_fail ctermfg=Red
syntax match step /=========== STEP:.* ===============/ contained
highlight step ctermbg=White


set nowrap
"set linebreak

map <silent> <leader>ch :call ToggleGroupConceal('csvIpSrc')<CR>:call ToggleGroupConceal('csvIpDst')<CR>:call ToggleGroupConceal('csvHttpMethod')<CR>
map <silent> <leader>cd :call ToggleGroupConceal('ndsProcess')<CR>:call ToggleGroupConceal('ndsThread')<CR>:call ToggleGroupConceal('ndsFCID')<CR>
" Thanks to 'Al' at stackoverflow for this function:
" http://stackoverflow.com/questions/3853631/toggling-the-concealed-attribute-for-a-syntax-highlight-in-vim
function! ToggleGroupConceal(group)
	" Get the existing syntax definition
	redir => syntax_def
	exe 'silent syn list' a:group
	redir END
	" Split into multiple lines
	let lines = split(syntax_def, "\n")
	" Clear the existing syntax definitions
	exe 'syn clear' a:group
	for line in lines
		" Only parse the lines that mention the desired group
		" (so don't try to parse the "--- Syntax items ---" line)
		if line =~ a:group
			" Get the required bits (the syntax type and the full definition)
			let matcher = a:group . '\s\+xxx\s\+\(\k\+\)\s\+\(.*\)'
			let type = substitute(line, matcher, '\1', '')
			let definition = substitute(line, matcher, '\2', '')
			" Either add or remove 'conceal' from the definition
			if definition =~ 'conceal'
				let definition = substitute(definition, ' conceal\>', '', '')
				exe 'syn' type a:group definition
			else
				exe 'syn' type a:group definition 'conceal'
			endif
		endif
	endfor
	" Redefine the syntaxes which also match at the beginning, to prevent priority conflicts
"	exe 'syntax match ndsFatal /^.*!FA\?TA\?L.*$/' 
	"exe 'syntax match ndsError /^.*!ERRO\?R\?.*$/'
"	exe 'syntax match ndsWarning /^.*!WA\?RN.*$/'
"	exe 'syntax match ndsCaution /^.* !CTN .*$/'
endfunction

