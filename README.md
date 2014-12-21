typo.vim is a small Vim plugin for Rust programmers.

# Setup

Add [`typo` executable][typo] to your `$PATH`.

Add the following lines to your `~/.vimrc`:

```vim
" `:Typo` command generates ctags table and type table.
" NOTE: you must run this where `"%"` is crate root.
command! Typo call typo#generate(expand("%"))

" `<Leader>z` prints type of node underlying current cursor.
nnoremap <silent> <Leader>z :echo typo#find_cur_type()<CR>
```

# TODOs

-   Find crate root automatically (like Cargo does)

[typo]: https://github.com/klutzy/typo
