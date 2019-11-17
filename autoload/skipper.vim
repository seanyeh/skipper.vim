let g:skipper_cursor = line('.')
let g:skipper_key = "s"

if !exists('g:skipper_enabled')
    let g:skipper_enabled = 0
endif

function! s:setup_range(start, key)
    let i = a:start
    while i <= a:start + 26
        let c = nr2char(i)
        exe ':sign define '.c.' text='.c

        let num = i - a:start + 1

        " e.g. noremap sa 3j^
        exe 'noremap '.g:skipper_key.c.' '.num.a:key.'^'

        let i += 1
    endwhile
endfunction!

if !exists('g:skipper_loaded')
    let g:skipper_loaded = 1
    call s:setup_range(65, "k")
    call s:setup_range(97, "j")
endif

function! skipper#toggle_enable()
    if g:skipper_enabled
        let g:skipper_enabled = 0
        sign unplace *
    else
        let g:skipper_enabled = 1
        :call skipper#skipper()
    endif
endfunction

function! skipper#skipper()
    if !g:skipper_enabled
        return
    endif

    let new_line = line('.')

    if new_line != g:skipper_cursor
        let g:skipper_cursor = new_line

        call s:show_gutter(new_line)
    endif
endfunction

function! s:num_to_key(n)
    let start = 65
    if a:n < 0
        let start = 97
    endif

    if a:n == 0
        return ''
    endif

    let delta = abs(a:n)

    if delta > 26
        return ''
    else
        return nr2char(start + delta - 1)
    endif
endfunction

function! s:show_gutter(line)
    sign unplace *

    let row = max([a:line - 26, line('w0')])
    let end_row = min([a:line + 26, line('w$')])

    while row <= end_row
        let c = s:num_to_key(a:line - row)

        if c != ''
            exe ":sign place ".row." line=".row." name=".c
        endif

        let row += 1
    endwhile
endfunction
