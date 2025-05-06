# Uno script per avere i sinonimi per VIM (Italiano ma usabile per altre lingue)

## Contenuti
1. [Perché](#perche)
2. Prerequisiti
3. Installazione e configurazione
4
. [Da fare](#todo)

<a name="perche"></a>
## Perché
Vim supporta nativamente sia il controllo ortografico che la ricerca di sinonimi e contrari. Per farlo però è necessario avere dei file, specifici per vim, con queste liste di parole. Inoltre le scelte sono mostrate su buffers che nascondono completamente il testo su cui si sta lavorando. Personalmente preferirei averle a cursore e/o a puntatore.

Il problema più grosso è però doversi appoggiare a files specifici usati solo da vim Files che in Italiano comunque non ci sono. Preferirei un sistema che mi permetta di utilizzare il dizionario di sistema e quindi con l'uso tutto il sistema ne beneficerebbe.
Inoltre il dizionario dei sinonimi e contrari per la lingua italiana di vim non esiste.

Quindi la soluzione più vicina per qualità e completezza per me è LanguageTool. Peccato che la versione stand-alone (sia come server che come riga di comando) non supporti l'interrogazione di sinonimi e contrari (la versione in abbonamento è più performante ma nemmeno quella, mi risulta ti ridà i sinonimi via API).

Languagetool inoltre può essere usato da vim (anche come linter con ALE) e funziona bene anche se gli dai testo markdown.

Fortunatamente LibreOffice utilizza Hunspell/MySpell (quindi vocabolari condivisi) e c'è il supporto ai sinonimi, quindi esattamente come voglio: un sistema condiviso.


<a name="prereq"></a>
## Prerequisiti
Vim, compilato con il supporto per i popup, altrimenti ovviamente non funziona.
Serve un file di thesaurus nella lingua desiderata. Per l'italiano io ho usato quello che viene con MySpell/LibreOffice/Hunspell proprio perché così è usato da tutto il sistema. Il file è in formato testo.

Quindi come pre-requisti sono indispensabili:
* MySpell o Hunspell
* vim versione 8.2 o superiore

<a name="install"></a>
## Installazione e configurazione

L'installazione è banalissima.
Il file bash (.sh) va nel path, quindi in una di queste location:  
```
~/.local/bin/
~/bin/  
```
o se vi fidate direttamente in /usr/local/bin/.

Il file vim (.vim) va in ~/.vim/plugin/

Per configurarlo invece dovete verificare che i percorsi inseriti all'interno siano corretti. Sono comunque entrambi definiti come variabili all'inizio dello script. I percorsi da modificare sono 2:
1. nello script bash il percorso che punta al dizionario dei sinonimi di mythes che dovrebbe essere /usr/share/mythes/file.dat
2. uno nel file vim che punta allo script bash

<a name="todo"></a>
## Todo
* abilitare altre lingue (settando un parametro in chiamata)
* abilitare i contrari
* abilitare anche la possibilità di inserirne di nuovi
* usare più "dizionari" per diversificare i registri linguistici (termini specializzati, etc)
