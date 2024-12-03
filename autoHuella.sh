#!/bin/bash

# URL del servidor
URL="http://10.11.0.130"

# Archivo temporal para almacenar el índice actual
TEMP_FILE="/tmp/server_index.txt"
PREVIOUS_FILE="/tmp/previous_index.txt"

# Función para obtener el listado de archivos
function get_file_list() {
    curl -s "$URL" | grep -oP '(?<=href=")[^"]*' | grep -v '/$'
}

# Guardar el índice anterior
if [ -f "$TEMP_FILE" ]; then
    mv "$TEMP_FILE" "$PREVIOUS_FILE"
else
    touch "$PREVIOUS_FILE"
fi

# Obtener el índice actual y guardarlo
get_file_list > "$TEMP_FILE"

# Comparar índices para detectar nuevos archivos
NEW_FILES=$(comm -13 "$PREVIOUS_FILE" "$TEMP_FILE")

if [ -n "$NEW_FILES" ]; then
    echo "Se han subido nuevos archivos:"
    echo "$NEW_FILES"
else
    echo "No se han detectado nuevos archivos."
fi
