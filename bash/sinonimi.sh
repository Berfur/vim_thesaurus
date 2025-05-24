#!/bin/bash
#
# sinonimi.sh
# Versione 1.0
#
# Script per interrogare il dizionario di Mythes/Hunspell per avere i sinonimi
#
#
#

# Percorso al file del dizionario MyThes
DIZ="/usr/share/mythes/th_it_IT_v2.dat"

# Verifica che il file esista
if [ ! -f "$DIZ" ]; then
    echo "Errore: Dizionario non trovato in $DIZ"
    exit 1
fi

# Parola da cercare, la trasformo in minuscolo a prescindere
PAROLA=$(echo "$1" | tr '[:upper:]' '[:lower:]')

# Cerca la riga iniziale della voce
START=$(grep -n "^$PAROLA|" "$DIZ" | cut -d: -f1)

if [ -z "$START" ]; then
    echo "Errore: Voce \"$PAROLA\" non trovata."
    exit 1
fi

# Ottieni quante righe seguire (quante accezioni)
N_ACCEZIONI=$(sed -n "${START}p" "$DIZ" | cut -d'|' -f2)

# echo "Sinonimi per '$PAROLA', linea n° $START ($N_ACCEZIONI accezioni):"

# Cicla le righe successive per ogni accezione
for ((i=1; i<=N_ACCEZIONI; i++)); do
    LINESIN=$((START + i))
    LINE=$(sed -n "${LINESIN}p" "$DIZ")
    DESCR=$(echo "$LINE" | cut -d'|' -f1)
    SIN_LINE=$(echo "$LINE" | cut -d'|' -f2-)

    IFS='|'
    read -ra TERMS <<< "$SIN_LINE"
    for term in "${TERMS[@]}"; do
	    SINONIMI+=("$term")   
    done
done

if [ "${#SINONIMI[@]}" > 0 ]; then
#    echo "Sinonimi totali: ${#SINONIMI[@]}"
    printf '%s\n' "${SINONIMI[@]}"
else
    echo "Errore: Sinonimi non trovati"
fi
