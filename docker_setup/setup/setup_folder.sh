#!/bin/bash

# Variabili
ROOT_DIR="/docker"
CONTAINERS_DIR="${ROOT_DIR}/containers"
TARGET_GROUP="docker"

# 1. Crea le cartelle se non esistono
echo "Verifica e creazione delle directory: ${CONTAINERS_DIR}"
sudo mkdir -p "${CONTAINERS_DIR}"

# Verifica se il gruppo esiste
if ! getent group "${TARGET_GROUP}" >/dev/null; then
    echo "Errore: Il gruppo '${TARGET_GROUP}' non esiste. Crealo prima di eseguire lo script."
    exit 1
fi

# 2. Assegna la proprietà del gruppo "docker" alla directory radice in modo ricorsivo
echo "Assegnazione del gruppo '${TARGET_GROUP}' a ${ROOT_DIR} (ricorsivo)"
sudo chgrp -R "${TARGET_GROUP}" "${ROOT_DIR}"

# 3. Imposta i permessi rwx (7) per il proprietario (u) e il gruppo (g) su /docker
#    Permessi: u=rwx (7), g=rwx (7), o=rx (5) -> 775
#    -R: ricorsivo
echo "Assegnazione dei permessi 775 a ${ROOT_DIR} (ricorsivo)"
sudo chmod -R 775 "${ROOT_DIR}"

# 4. Imposta lo Sticky Bit con SGID (Set Group ID) su /docker
#    L'opzione 's' nella posizione del gruppo (g) imposta SGID.
#    Quando SGID è attivo su una directory, i nuovi file/sottocartelle creati al suo interno
#    ereditano automaticamente il gruppo della cartella padre (in questo caso, 'docker').
#    Il comando 'g+s' aggiunge l'SGID senza modificare gli altri permessi.
echo "Impostazione di SGID (Set Group ID) sulla cartella ${ROOT_DIR} per ereditarietà del gruppo"
sudo chmod g+s "${ROOT_DIR}"

echo "Configurazione completata per ${ROOT_DIR}."
