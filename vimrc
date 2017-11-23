let dotfilepath="~/dotfiles"
let vimawesome=dotfilepath."/vim_runtime"
execute "set runtimepath+=".vimawesome

execute "source ".vimawesome."/vimrcs/basic.vim"
execute "source ".vimawesome."/vimrcs/filetypes.vim"
execute "source ".vimawesome."/vimrcs/plugins_config.vim"
execute "source ".vimawesome."/vimrcs/extended.vim"

" Make <leader>c open the pdf of the current tex file
au BufRead,BufNewFile *.cls set filetype=tex
au BufRead,BufNewFile *.intex set filetype=tex
au BufRead,BufNewFile *.tikz set filetype=tex
au BufRead,BufNewFile *.ftex set filetype=tex

augroup filetype_tex
    autocmd!
    autocmd Filetype tex map <leader>c :exe '!xdg-open ' . shellescape(expand('%:p:s/tex/pdf/')) . ' >> /dev/null 2>> /dev/null'<esc><cr>
    "autocmd Filetype tex inoremap <esc> <esc>:w!<cr>
augroup END

" Make syntastic use c++11
let g:syntastic_cpp_compiler_options = ' -std=c++11'

" Infect more
call pathogen#infect(dotfilepath.'/vim_perso/{}')

set noshowmode
function GetTupStatus()
    let l:tup_status_file = get(g:,'tup_status_file', "")
    let l:tup_status_timeout = get(g:, 'tup_status_timeout', "0.01s")
    let l:split_regex = "\\s*\\d\\+%" 
    " S'il y a des problemes avec le count, c'est peut-etre que l'on ne verifie pas le debut de la ligne
    :silent let l:result = split(system('timeout ' . l:tup_status_timeout .' tup todo ' . l:tup_status_file),l:split_regex) 
    let l:length = len(l:result) -1
    let l:error  = v:shell_error
    redraw
    if l:error ==# 1
        return ""
    elseif l:error ># 0
        return "[Compiling]"
    endif
    if l:length ># 0
        return "[" . l:length  . "]"
    endif
    return "[OK]"
endfunction

let s:active = get(g:lightline, 'active', {})
let s:left = get(s:active, 'left', [])

let s:left = s:left + [ ['tup'] ]
let s:active.left = s:left
let g:lightline.active = s:active

let s:comp_function = get(g:lightline, 'component_function', {})
let s:comp_function.tup = 'GetTupStatus'
let g:lightline.component_function = s:comp_function

iunmap $1
iunmap $2
iunmap $3
iunmap $4
iunmap $q
iunmap $e

map <leader>ss :setlocal spell! spelllang=fr<cr>

" Make possible to have project vimrc
set exrc
set secure
