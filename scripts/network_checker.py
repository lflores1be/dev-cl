#!/usr/bin/env python3

import os
import socket

SERVICES = {
    "empleados-portal": ("10.220.4.12", 8080),
    "database": ("10.220.4.50", 3306),
    "ldap": ("10.220.4.100", 389),
}

def check_service(name, ip, port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.settimeout(2)
        try:
            sock.connect((ip, port))
            print(f"[+] {name} ({ip}:{port}) está ACTIVO.")
        except socket.error:
            print(f"[-] {name} ({ip}:{port}) no responde.")

print("[*] Verificando servicios internos...")
for service, (ip, port) in SERVICES.items():
    check_service(service, ip, port)