#!/bin/bash

# Configuración
WINDOWS_IP="192.168.1.100"  # Cambia a la IP de tu máquina Windows
WINDOWS_PORT="8080"
DEBIAN_DOWNLOAD_DIR="/tmp/downloaded_files"  # Directorio temporal para guardar archivos
MYSQL_USER="tu_usuario"                      # Usuario de MySQL
MYSQL_PASSWORD="tu_contraseña"               # Contraseña de MySQL
MYSQL_DATABASE="tu_base_de_datos"            # Nombre de la base de datos
MYSQL_TABLE="tu_tabla"                       # Tabla para insertar los datos

# Crear directorio temporal si no existe
mkdir -p "$DEBIAN_DOWNLOAD_DIR"

# Obtener lista de archivos del servidor Windows
echo "Obteniendo lista de archivos del servidor Windows..."
wget -q -O - "http://$WINDOWS_IP:$WINDOWS_PORT" | \
grep -oP '(?<=href=")[^"]+' > "$DEBIAN_DOWNLOAD_DIR/file_list.txt"

# Descargar archivos
echo "Descargando archivos desde el servidor Windows..."
while IFS= read -r file; do
    if [[ $file != *"/"* ]]; then  # Evitar directorios o rutas completas
        wget -q "http://$WINDOWS_IP:$WINDOWS_PORT/$file" -P "$DEBIAN_DOWNLOAD_DIR"
        echo "Archivo descargado: $file"
    fi
done < "$DEBIAN_DOWNLOAD_DIR/file_list.txt"

# Procesar e insertar archivos en la base de datos
echo "Procesando archivos e insertando en la base de datos..."
for filepath in "$DEBIAN_DOWNLOAD_DIR"/*; do
    if [[ -f $filepath ]]; then
        filename=$(basename "$filepath")
        filecontent=$(cat "$filepath" | sed 's/"/\\"/g')  # Escapar comillas dobles
        mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -D "$MYSQL_DATABASE" -e \
            "INSERT INTO $MYSQL_TABLE (filename, content) VALUES (\"$filename\", \"$filecontent\");"
        echo "Archivo insertado en la base de datos: $filename"
    fi
done

# Limpiar archivos descargados
echo "Limpiando archivos temporales..."
rm -r "$DEBIAN_DOWNLOAD_DIR"

echo "Proceso completado."
