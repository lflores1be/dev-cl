# Descripción

Este repositorio contiene una página de login para empleados (carpeta `dev`) y varios scripts de monitoreo y auditoría ubicados en la carpeta `scripts`.

El objetivo es proporcionar herramientas sencillas para comprobar la disponibilidad de servicios internos, volcar la base de datos de empleados, auditar intentos de acceso y realizar comprobaciones remotas básicas.

---

# Estructura del repositorio

```
dev-cl/
├─ dev/                # Página de login y recursos web
└─ scripts/            # Scripts de monitoreo y auditoría (bash, python, powershell)
```

---

# Contenido principal

## Carpeta `dev`

* Página de login para empleados.

## Carpeta `scripts`

* **Verificación de Citrix Gateway (bash)**

  * Comprueba conectividad a los servicios de Citrix.
  * Nota: En el futuro se integrará verificación automática de login.

* **Volcado de base de datos (bash)**

  * Genera un `mysqldump` de la base de datos `empleados_db` utilizando variables de entorno para conexión (`DB_HOST`, `DB_USER`, `DB_PASS`).

* **Auditoría de accesos fallidos (bash)**

  * Analiza `/var/log/auth.log` y muestra las IPs con más intentos fallidos, además de las IPs que superen un umbral configurable (`THRESHOLD`).

* **Chequeo de servicios internos (Python)**

  * Comprueba la conectividad a varios servicios (`empleados-portal`, `database`, `ldap`)

* **Comprobación RDP y prueba de conexión remota (PowerShell)**

  * Verifica si el puerto RDP está abierto y además intenta una conexión remota con credenciales.

---

# Requisitos y dependencias

* `bash`, `nc` (netcat), `mysqldump` para scripts bash.
* Python 3 para el script de verificación de servicios.
* PowerShell (Windows / PowerShell Core) para el script RDP.
* Permisos adecuados para leer logs (`/var/log/auth.log`) y para ejecutar `mysqldump`.

---

# Uso rápido

## Ejecutar un script bash

```bash
cd scripts
chmod +x script_name.sh
./script_name.sh
```

## Ejecutar el volcado de la base de datos (ejemplo)

```bash
export DB_HOST=mi.host.bd
export DB_USER=backup_user
export DB_PASS="mi_pass_seguro"
./dump_db.sh
```

## Ejecutar el script Python

```bash
python3 check_services.py
```

## Ejecutar PowerShell (Windows o PowerShell Core)

```powershell
pwsh .\check_rdp.ps1 -TargetHost 18.228.74.153 -Port 3389
```
