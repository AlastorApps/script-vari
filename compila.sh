#!/bin/bash

#Rapida compilazione di file in assembly senza dover scrivere entrambi i comandi.

# Controlla se è stato fornito un argomento
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 FILE (senza estensione)"
    exit 1
fi

FILE=$1

# Controlla se il file sorgente esiste
if [ ! -f "${FILE}.s" ]; then
    echo "Errore: Il file ${FILE}.s non esiste."
    exit 1
fi

# Compilazione e linking
as -o "${FILE}.o" "${FILE}.s"
if [ $? -ne 0 ]; then
    echo "Errore durante l'assemblaggio di ${FILE}.s"
    exit 1
fi

ld -o "${FILE}" "${FILE}.o"
if [ $? -ne 0 ]; then
    echo "Errore durante il linking di ${FILE}.o"
    exit 1
fi

echo "Assemblaggio e linking completati con successo. Esegui ./${FILE} per eseguire il programma."
