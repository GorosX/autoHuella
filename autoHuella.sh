#!/bin/bash

# Configuración
URL="http://tu-servidor.com/uploads/" # URL del directorio de archivos

# Descargar listado de archivos al directorio actual
echo "Obteniendo y descargando archivos desde $URL..."
wget -q -r -np -nd -A '*' "$URL"

# Confirmación
echo "Descarga completada. Los archivos se guardaron en el directorio actual."
