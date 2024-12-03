#!/bin/bash

# Solicitar la URL del servidor
read -p "Introduce la dirección del servidor (por ejemplo, 192.168.1.100): " SERVER_IP

# Construir la URL completa con el puerto 8080
URL="http://$SERVER_IP:8080/"

# Intervalo de verificación (en segundos)
INTERVALO=10

# Crear el archivo de registro de archivos descargados
REGISTRO=".descargados_simple.txt"
touch "$REGISTRO"

echo "Monitoreando $URL para detectar archivos nuevos..."

# Ciclo infinito para monitorear archivos nuevos
while true; do
    # Obtener listado de archivos en el servidor
    wget -q -O - "$URL" | grep -oP '(?<=href=")[^"]*' > .archivos.txt

    # Procesar cada archivo encontrado
    while read -r ARCHIVO; do
        # Si el archivo no está en el registro, se descarga
        if ! grep -qx "$ARCHIVO" "$REGISTRO"; then
            echo "Descargando archivo nuevo: $ARCHIVO"
            wget -q "$URL$ARCHIVO" -O "$ARCHIVO"
            echo "$ARCHIVO" >> "$REGISTRO"
        fi
    done < .archivos.txt

    # Esperar antes de la siguiente verificación
    sleep "$INTERVALO"
done
