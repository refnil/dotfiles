let dotfilepath="~/dotfiles"
let vimawesome=dotfilepath."/vim_runtime"
execute "set runtimepath+=".vimawesome

execute "source ".vimawesome."/vimrcs/basic.vim"
execute "source ".vimawesome."/vimrcs/filetypes.vim"
execute "source ".vimawesome."/vimrcs/plugins_config.vim"
execute "source ".vimawesome."/vimrcs/extended.vim"

" Make <leader>c open the pdf of the current tex file
au BufRead,BufNewFile *.cls set filetype=tex
map <leader>c :exe '!xdg-open ' . shellescape(expand('%:p:s/tex/pdf/')) . ' >> /dev/null 2>> /dev/null'<esc><cr>
