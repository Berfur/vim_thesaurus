"
" This scripts offers a popup menu with synonyms for the word under the cursor.
" Dependencies:
" * a version of vim who supports popup menu
" * another script bash to do the search
"   - the bash script needs a hunspell/myspell file with the synonims
"

if !has('popupwin')
  echoerr "Il tuo Vim non supporta i popup (manca +popupwin)."
  finish
endif

let g:sinonimi_script_path = expand('~/.local/bin/sinonimi.sh')

function! CercaSinonimi() abort
  let parola = expand('<cword>')

  let script = get(g:, 'sinonimi_script_path', '')

  if empty(script) || !filereadable(script)
    echoerr "Script per i sinonimi non trovato: " . script
    return
  endif

 " Esegui lo script e ottieni i sinonimi (lo script bash ritorna sempre un valore, vedi sotto)
  let g:sinonimi = systemlist(script . ' ' . shellescape(parola))

  " sinonimi.sh convert all words to lowercase
  " Controlla se la risposta è quella che indica che non sono stati trovati sinonimi
  if g:sinonimi == ['Voce "'.tolower(parola).'" non trovata.']
    call popup_create(['Sinonimi non trovati per: ' . parola], #{
      \ title: 'Avviso',
      \ border: [],
      \ padding: [0, 0, 0, 0],
      \ highlight: 'WarningMsg',
      \ time: 2000
      \ })
    return
  endif

  function! SinSelected(id, result) abort
	  if a:result == -1
		  return
	  endif
	  let index = a:result - 1
	  execute "normal! ciw" . g:sinonimi[index]
  endfunction

  call popup_menu(g:sinonimi, #{
	\ title: 'Sinonimi:',
	\ padding: [0,1,0,1],
	\ border: [],
	\ callback: 'SinSelected'
	\})

endfunction

nnoremap <leader>s :call CercaSinonimi()<CR>
