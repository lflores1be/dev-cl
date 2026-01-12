#!/bin/bash

DOMAINS=("vpn.bancoestado.cl" "vpn2.bancoestado.cl")
PORT=443
TIMEOUT=5
LOGIN_PATH="/login"
TEST_USER="dflores4@bancoestado.cl"
TEST_PASS="dP1gJhtG9m42TUIe"
FAILED_COUNT=0

for DOMAIN in "${DOMAINS[@]}"; do
    HTTP_CODE=$(curl -k -s --max-time $TIMEOUT -o /dev/null -w "%{http_code}" https://$DOMAIN:$PORT 2>/dev/null)

    if [[ "$HTTP_CODE" -ge 200 && "$HTTP_CODE" -le 399 ]]; then
        LOGIN_CODE=$(curl -k -s --max-time $TIMEOUT -o /dev/null -w "%{http_code}" -X POST -d "uname=$TEST_USER&pass=$TEST_PASS" "https://$DOMAIN:$PORT$LOGIN_PATH" 2>/dev/null)

        if [[ "$LOGIN_CODE" == "302" ]]; then
            echo "$DOMAIN: OK - Login Redirect (302)"
        elif [[ "$LOGIN_CODE" == "200" ]]; then
            echo "$DOMAIN: WARNING - Login Response (200)"
        else
            echo "$DOMAIN: FAIL - Login Error ($LOGIN_CODE)"
            FAILED_COUNT=$((FAILED_COUNT + 1))
        fi
    elif [[ "$HTTP_CODE" == "000" ]]; then
        echo "$DOMAIN: FAIL - Connection Refused/Timeout"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    else
        echo "$DOMAIN: FAIL - HTTP Error ($HTTP_CODE)"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
done

if [[ $FAILED_COUNT -eq ${#DOMAINS[@]} ]]; then
    echo "CRITICAL: No endpoints available."
    exit 1
else
    echo "Check completed. Failures: $FAILED_COUNT"
    exit 0
fi
