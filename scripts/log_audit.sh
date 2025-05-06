#!/bin/bash

# Script de auditoría básica de accesos fallidos

echo "[*] Analizando logs del sistema..."
LOG_FILE="/var/log/auth.log"
THRESHOLD=5

echo "[+] Intentos fallidos por IP:"
awk '/Failed password/ {print $(NF-3)}' $LOG_FILE | sort | uniq -c | sort -nr | head -n 10

echo "[*] IPs con más de $THRESHOLD intentos:"
awk '/Failed password/ {print $(NF-3)}' $LOG_FILE | sort | uniq -c | awk -v threshold=$THRESHOLD '$1 > threshold {print $2}'
