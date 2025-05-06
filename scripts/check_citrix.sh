#!/bin/bash

# Script para verificar disponibilidad del servicio Citrix Gateway
# En el futuro se integrará verificación automática de login con las credenciales test / P@ssw0rd123.

DOMAINS=("vpn.bancoestado.cl")
PORT=443

echo "[*] Verificando disponibilidad del servicio Citrix..."

for DOMAIN in "${DOMAINS[@]}"; do
    echo -n "→ Probando $DOMAIN ... "

    if nc -z -w3 $DOMAIN $PORT 2>/dev/null; then
        echo "Disponible"
        echo "[+] Conectando a Citrix Gateway en https://$DOMAIN"
        exit 0
    else
        echo "No disponible"
    fi
done

echo "[!] Ningún endpoint Citrix está disponible actualmente."
exit 1
