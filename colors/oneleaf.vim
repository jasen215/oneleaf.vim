" Vim color file
" Maintainer: Jasen <jasen215@gmail.com>
" Last Change: 2023-05-05
"
" This color file is a fork of the "summerfruit" color scheme.
" it can be used on 88- and 256-color xterms. The colors are translated
"
" Thanks  Armin Ronacher

set background=light
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif

let g:colors_name="oneleaf"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
    " functions {{{
    " returns an approximate grey index for the given grey level
    fun <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual grey level represented by the grey index
    fun <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " returns the palette index for the given grey index
    fun <SID>grey_color(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " returns an approximate color index for the given color level
    fun <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual color level for the given color index
    fun <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " returns the palette index for the given R/G/B color indices
    fun <SID>rgb_color(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " returns the palette index to approximate the given R/G/B color levels
    fun <SID>color(r, g, b)
        " get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " get the closest color
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " there are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " use the grey
                return <SID>grey_color(l:gx)
            else
                " use the color
                return <SID>rgb_color(l:x, l:y, l:z)
            endif
        else
            " only one possibility
            return <SID>rgb_color(l:x, l:y, l:z)
        endif
    endfun

    " returns the palette index to approximate the 'rrggbb' hex string
    fun <SID>rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>color(l:r, l:g, l:b)
    endfun

    " sets the highlighting for the given group
    fun <SID>X(group, fg, bg, attr)
        " export highlight command list
        " let str = "hi " . a:group
        if a:fg != ""
            " let str = str . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
        endif
        if a:bg != ""
            " let str = str .  " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
        endif
        if a:attr != ""
            " let str = str .  " gui=" . a:attr . " cterm=" . a:attr
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
        " echom str
    endfun
    " }}}

    " export highlight command list to file
    " redir! > ~/cc.txt
    " Global
    call <SID>X("Normal", "000000", "ffffff", "")
    call <SID>X("NonText", "000000", "ffffff", "")
    call <SID>X("Visual", "ffffff", "00afff", "")

    " Search
    call <SID>X("Search", "800000", "ffae00", "")
    call <SID>X("IncSearch", "800000", "ffae00", "")

    " Interface Elements
    call <SID>X("StatusLine", "ffffff", "0F80FF", "bold")
    call <SID>X("StatusLineNC", "CCCCCC", "FFFFFF", "")
    " call <SID>X("VertSplit", "9b9b9b", "9b9b9b", "")
    call <SID>X("Folded", "3c78a2", "c3daea", "")
    call <SID>X("IncSearch", "708090", "f0e68c", "")
    call <SID>X("Pmenu", "ffffff", "cb2f27", "")
    call <SID>X("SignColumn", "", "", "")
    call <SID>X("CursorLine", "", "eeeeee", "")
    call <SID>X("LineNr", "e1d5c0", "ffffff", "")
    call <SID>X("MatchParen", "", "", "")

    " Specials
    call <SID>X("Todo", "e50808", "dbf3cd", "bold")
    call <SID>X("Title", "000000", "", "")
    call <SID>X("Special", "996633", "", "")

    " Syntax Elements
    call <SID>X("String", "ff6600", "", "")
    call <SID>X("Constant", "0086d2", "", "")
    call <SID>X("Number", "0000ff", "", "")
    call <SID>X("SignColumn", "", "ffffff", "")
    call <SID>X("Statement", "996633", "", "")
    call <SID>X("Function", "9520af", "", "")
    call <SID>X("PreProc", "b52264", "", "")
    call <SID>X("Comment", "3c802c", "", "italic")
    call <SID>X("Type", "b52264", "", "")
    call <SID>X("Error", "ffffff", "d40000", "")
    call <SID>X("Identifier", "996633", "", "")
    call <SID>X("Label", "ff0086", "", "")
    " call <SID>X("Operator", "ff0000", "", "")

    " Python Highlighting
    call <SID>X("pythonCoding", "ff0086", "", "")
    call <SID>X("pythonRun", "ff0086", "", "")
    call <SID>X("pythonBuiltinObj", "2b6ba2", "", "")
    call <SID>X("pythonBuiltinFunc", "2b6ba2", "", "")
    call <SID>X("pythonException", "ee0000", "", "")
    call <SID>X("pythonExClass", "66cd66", "", "")
    call <SID>X("pythonSpaceError", "", "", "")
    call <SID>X("pythonDocTest", "2f5f49", "", "")
    call <SID>X("pythonDocTest2", "3b916a", "", "")
    call <SID>X("pythonFunction", "ee0000", "", "")
    call <SID>X("pythonClass", "ff0086", "", "")

    " HTML Highlighting
    call <SID>X("htmlTag", "00bdec", "", "")
    call <SID>X("htmlEndTag", "00bdec", "", "")
    call <SID>X("htmlSpecialTagName", "4aa04a", "", "")
    call <SID>X("htmlTagName", "4aa04a", "", "")
    call <SID>X("htmlTagN", "4aa04a", "", "")

    " Jinja Highlighting
    call <SID>X("jinjaTagBlock", "ff0007", "fbf4c7", "bold")
    call <SID>X("jinjaVarBlock", "ff0007", "fbf4c7", "")
    call <SID>X("jinjaString", "0086d2", "fbf4c7", "")
    call <SID>X("jinjaNumber", "bf0945", "fbf4c7", "bold")
    call <SID>X("jinjaStatement", "fb660a", "fbf4c7", "bold")
    call <SID>X("jinjaComment", "008800", "002300", "italic")
    call <SID>X("jinjaFilter", "ff0086", "fbf4c7", "")
    call <SID>X("jinjaRaw", "aaaaaa", "fbf4c7", "")
    call <SID>X("jinjaOperator", "ffffff", "fbf4c7", "")
    call <SID>X("jinjaVariable", "92cd35", "fbf4c7", "")
    call <SID>X("jinjaAttribute", "dd7700", "fbf4c7", "")
    call <SID>X("jinjaSpecial", "008ffd", "fbf4c7", "")


    " call <SID>X("Pmenu", "000000", "f0f0f0", "")
    call <SID>X("Pmenu", "eeeeee", "4e4e4e", "")
    call <SID>X("PmenuSel", "585858", "eeeeee", "")
    call <SID>X("PmenuSbar", "", "d0d0d0", "")
    call <SID>X("PmenuThumb", "", "00afff", "")

    if has('nvim')
        " Float window
        call <SID>X("NormalFloat", "000000", "dadada", "")
        call <SID>X("FloatBorder", "000000", "dadada", "")
        " Nvim Tree
        call <SID>X("NvimTreeFolderIcon", "808080", "ffffff", "")
        call <SID>X("NvimTreeFileIcon", "808080", "ffffff", "")
        call <SID>X("FloatTitle", "000000", "e0e0e0", "")
        " Diagnostic
		call <SID>X("DiagnosticError", "000000", "ffcc99", "")
        call <SID>X("DiagnosticWarn", "000000", "cccc99", "")
        call <SID>X("DiagnosticInfo", "000000", "99ffff", "")
        call <SID>X("DiagnosticHint", "000000", "33ccff", "")
        call <SID>X("DiagnosticOk", "000000", "ccff99", "")
    	call <SID>X("DiagnosticDeprecated", "000000", "c5def5", "")
    	call <SID>X("DiagnosticUnnecessary", "000000", "6c757d", "")
        " Lazy
        
    	call <SID>X("LazyButton", "", "eeeeee", "")
    	call <SID>X("LazyNormal", "", "dadada", "")
    endif

    " indent-blankline.
    call <SID>X("IblIndent", "e0e0e0", "", "")
    " redir END

    " delete functions {{{:
    delf <SID>X
    delf <SID>rgb
    delf <SID>color
    delf <SID>rgb_color
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_color
    delf <SID>grey_level
    delf <SID>grey_number
    " }}}
endif

hi def link NvimTreeIndentMarker Directory
hi def link TelescopeSelection Pmenu

" vim: set fdl=0 fdm=marker:
