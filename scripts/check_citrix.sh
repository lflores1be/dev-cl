#!/bin/bash

# Script para verificar disponibilidad del servicio Citrix Gateway
# Verificación mejorada con solicitud HTTP.
# En el futuro se integrará verificación automática de login con las credenciales test / P@ssw0rd123.

DOMAINS=("vpn.bancoestado.cl" "vpn2.bancoestado.cl")
PORT=443
TIMEOUT=5
FAILED_COUNT=0

echo "[*] Verificando disponibilidad del servicio Citrix..."

for DOMAIN in "${DOMAINS[@]}"; do
    echo -n "→ Probando https://$DOMAIN:$PORT ... "

    HTTP_CODE=$(curl -k -s --max-time $TIMEOUT -o /dev/null -w "%{http_code}" https://$DOMAIN:$PORT 2>/dev/null)
    
    if [[ "$HTTP_CODE" -ge 200 && "$HTTP_CODE" -le 399 ]]; then
        echo "Disponible (Código HTTP: $HTTP_CODE)"
    elif [[ "$HTTP_CODE" == "000" ]]; then
        echo "Fallo conexion. El servicio web no responde."
        FAILED_COUNT=$((FAILED_COUNT + 1))
    else
        echo "No disponible (Código HTTP: $HTTP_CODE)"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
done

if [[ $FAILED_COUNT -eq ${#DOMAINS[@]} ]]; then
    echo "[*] Fallo crítico: Ningún endpoint Citrix está disponible."
    exit 1
else
    echo "[*] Verificación completada . $FAILED_COUNT de ${#DOMAINS[@]} endpoints fallaron."
    exit 0
fi
