lua require('telescope').setup{ defaults = { file_ignore_patterns = {".git", "node_modules"} } }


nmap <C-p>f  :Telescope find_files hidden=true<cr>
xmap <C-p>f  :Telescope find_files hidden=true<cr>
nmap <C-p>g  :Telescope live_grep hidden=true<cr>
xmap <C-p>g  :Telescope live_grep hidden=true<cr>
nmap <C-p>c  :Telescope live_grep glob_pattern="!*test*" hidden=true<cr>
xmap <C-p>c  :Telescope live_grep glob_pattern="!*test*" hidden=true<cr>
nmap <C-p>d  :Telescope grep_string hidden=true<cr>
xmap <C-p>d  :Telescope grep_string hidden=true<cr>

