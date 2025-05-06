#!/bin/bash

echo "[*] Iniciando volcado de la base de datos de empleados..."

# Parámetros de conexión a la base de datos (a configurar en el entorno)
DB_HOST=${DB_HOST:-"<DB_HOST>"}
DB_USER=${DB_USER:-"<DB_USER>"}
DB_PASS=${DB_PASS:-"<DB_PASS>"}
DB_NAME=${DB_NAME:-"empleados_db"}

# Generar el volcado
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > empleados_dump.sql

if [ $? -eq 0 ]; then
    echo "[+] Volcado completado. Archivo guardado como empleados_dump.sql"
else
    echo "[-] Error al generar el volcado de la base de datos."
fi
