let s:tags = "tags"
let s:node_id_map = "node-id-map"
let s:type_map = "type-map"

function! typo#generate(input)
    let rustc = system("which rustc")
    let rustroot = fnamemodify(rustc, ":h:h")
    let cmdline = "!typo --sysroot ".rustroot
    let cmdline = cmdline . " --tags " . s:tags
    let cmdline = cmdline . " --node-id-map " . s:node_id_map
    let cmdline = cmdline . " --type-map " . s:type_map
    let cmdline = cmdline . " " . a:input

    " FIXME: cargo hack
    let cmdline = cmdline . " -L ./target"
    let cmdline = cmdline . " -L ./target/deps"

    execute cmdline
endfunction

" pos: zero-based offset. usually it is `line2byte(line(".")) + col(".") - 2`.
function! typo#find_node_id(filename, pos)
    let cur_start = -1
    let cur_end = -1
    let cur_id = -1
    for line in readfile(s:node_id_map)
        let words = split(line, '\t')
        if len(words) != 4
            continue
        endif
        let [fn, start, end, nid] = words
        if fn != a:filename
            continue
        endif
        if start <= a:pos && a:pos < end
            if cur_start == -1 || (cur_start <= start && end <= cur_end)
                let cur_start = start
                let cur_end = end
                let cur_id = nid
            endif
        endif
    endfor
    return cur_id
endfunction

function! typo#find_type(nid)
    for line in readfile(s:type_map)
        let words = split(line, '\t')
        if len(words) != 2
            continue
        endif
        let [nid, ty] = words
        if nid == a:nid
            return ty
        endif
    endfor
    return ''
endfunction

function typo#find_cur_type()
    let f = expand("%")
    let pos = line2byte(line(".")) + col(".") - 2
    let nid = typo#find_node_id(f, pos)
    let ty = typo#find_type(nid)
    return ty
endfunction
