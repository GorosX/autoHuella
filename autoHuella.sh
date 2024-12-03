#!/bin/bash

# Solicitar la URL del servidor
read -p "Introduce la dirección del servidor (por ejemplo, 192.168.1.100): " SERVER_IP

# Construir la URL completa con el puerto 8080
URL="http://$SERVER_IP:8080/"

# Confirmación de la URL
echo "Conectando al servidor en $URL..."

# Descargar archivos al directorio actual
wget -q -r -np -nd -A '*' "$URL"

# Verificar si la descarga fue exitosa
if [ $? -eq 0 ]; then
    echo "Descarga completada. Los archivos se guardaron en el directorio actual."
else
    echo "Ocurrió un error durante la descarga. Verifica la URL o la conectividad."
fi
