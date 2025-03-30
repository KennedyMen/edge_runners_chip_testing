" Toggle current fold
exmap togglefold obcommand editor:toggle-fold
nmap zo :togglefold<CR>

" Unfold all sections
exmap unfoldall obcommand editor:unfold-all
nmap zR :unfoldall<CR>

" Fold less (i.e. unfold one level)
exmap foldreduce obcommand editor:fold-less
nmap zr :foldreduce<CR>

" Fold all sections
exmap foldall obcommand editor:fold-all
nmap zM :foldall<CR>

" Fold more (i.e. collapse one additional header level)
exmap foldmore obcommand editor:fold-more
nmap zm :foldmore<CR>

" Map arrow keys to incremental folding:
" Left arrow: fold more (collapse further)
" Right arrow: fold less (expand one level)
nmap <Left>  :foldmore<CR>
nmap <Right> :foldreduce<CR>
" Make Alt-Enter follow link
exmap followLink obcommand editor:follow-link
nmap &c& :followLink
nmap <A-CR> lBl&c&
" Fix for unfolding of folded lines when curor is hovered over
exmap upSkipFold jsfile mdHelpers.js {moveUpSkipFold()}
exmap downSkipFold jsfile mdHelpers.js {moveDownSkipFold()}
nmap k :upSkipFold<CR>
nmap j :downSkipFold<CR>
