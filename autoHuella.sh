#!/bin/bash

sudo apt-get update
sudo apt-get install inotify-tools -y

# Configuración interactiva
read -p "Ingresa la URL del servidor HTTP (por ejemplo, http://10.11.0.130/): " SERVER_URL
read -p "Ingresa la ruta del directorio destino en Debian (por ejemplo, /home/usuario/descargas): " DEST_DIR

# Crear directorio destino si no existe
mkdir -p "$DEST_DIR"

# Monitorear y descargar nuevos archivos
echo "Monitoreando nuevos archivos en el servidor $SERVER_URL ..."
while true; do
    # Obtener la lista de archivos del servidor
    FILES=$(wget -q -O - "$SERVER_URL" | grep -oP '(?<=href=")[^"]*' | grep -v '/$')

    for FILE in $FILES; do
        # Comprobar si el archivo ya existe en el destino
        if [[ ! -f "$DEST_DIR/$FILE" ]]; then
            echo "Nuevo archivo detectado: $FILE"
            wget -q -O "$DEST_DIR/$FILE" "$SERVER_URL/$FILE"

            if [[ $? -eq 0 ]]; then
                echo "Archivo descargado correctamente: $DEST_DIR/$FILE"
            else
                echo "Error al descargar el archivo: $FILE"
            fi
        fi
    done

    # Pausa de 5 segundos antes de verificar nuevamente
    sleep 5
done
