"
" This scripts offers a popup menu with synonyms for the word under the cursor.
" It works like a frontend to other scripts working to search for the synonims/contraries
" Dependencies:
" * a version of vim who supports popup menu
" * another script bash to do the search
"   - the bash script needs a hunspell/myspell file with the synonims
"

" let's check if we have popups available
if !has('popupwin')
  echoerr "Il tuo Vim non supporta i popup (manca +popupwin)."
  finish
endif

" choose your backend
" todo: make it parametric?
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

  " the backend will convert all searched words to lowercase
  " Here we raise an alarm if we cannot find the word
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
  " here we raise an alarm in case the backend return an error
  " Todo: create a fallback message in case the backend return an error

  " The function to substitute the word under the cursor with the one selected from the popup menu
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
