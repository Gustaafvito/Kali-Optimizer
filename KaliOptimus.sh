#!/bin/bash

# ====================================================================
# 🐉 KALI OPTIMIZER v2.0
#
# Descripción: Herramienta avanzada para reparación de repositorios,
#              solución de firmas GPG inválidas y actualización completa.
#
# Autor: Gustaafvito
# GitHub: https://github.com/Gustaafvito
# Licencia: MIT
# ====================================================================

# --- Definición de Colores ANSI ---
RESET='\033[0m'
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'

# --- Configuración Interna ---
KALI_BRANCH="kali-rolling"
KALI_REPO_LINE="deb https://kali.download/kali ${KALI_BRANCH} main non-free contrib"
KEYRING_POOL_URL="https://http.kali.org/kali/pool/main/k/kali-archive-keyring/"
KEYRING_DEB_TEMP_PATH="/tmp/kali-archive-keyring_latest.deb"

# --- Función de Banner ---
print_banner() {
    clear
    echo -e "${BLUE}"
    echo "██╗  ██╗ █████╗ ██╗     ██╗"
    echo "██║ ██╔╝██╔══██╗██║     ██║"
    echo "█████╔╝ ███████║██║     ██║"
    echo "██╔═██╗ ██╔══██║██║     ██║"
    echo "██║  ██╗██║  ██║███████╗██║"
    echo "╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝"
    echo -e "${RESET}"
    echo -e "${BOLD}  🐉 KALI OPTIMIZER & REPAIR v2.0${RESET}"
    echo -e "${CYAN}  by Gustaafvito (github.com/Gustaafvito)${RESET}"
    echo ""
}

# --- Función para pasos ---
print_step() {
    echo -e "\n${BLUE}[*] PASO $1: $2${RESET}"
    echo -e "${BLUE}---------------------------------------------------${RESET}"
}

# INICIO DEL SCRIPT
print_banner

# --- PASO 0: Verificaciones Previas ---
if [ "$(id -u)" -ne 0 ]; then
   echo -e "${BOLD_RED}[!] ERROR: Necesitas ser ROOT.${RESET}"
   echo -e "${YELLOW}Ejecuta: sudo ./KaliOptimus.sh${RESET}"
   exit 1
fi

echo -e "Verificando conexión a internet..."
if ! curl --silent --head --fail "https://kali.download/kali/" &> /dev/null; then
    echo -e "${BOLD_RED}[!] ERROR: Sin conexión a internet o DNS fallando.${RESET}"; exit 1
fi
echo -e "${GREEN}[✔] Conexión estable.${RESET}"


# --- PASO 1: Configurar Repositorios ---
print_step 1 "Restaurando Repositorios Oficiales"
SOURCES_FILE="/etc/apt/sources.list"

# Backup silencioso
if [ -f "${SOURCES_FILE}" ]; then
    cp -a "${SOURCES_FILE}" "${SOURCES_FILE}.backup_$(date +%F)"
fi

echo -e "Escribiendo fuentes oficiales en ${SOURCES_FILE}..."
echo "${KALI_REPO_LINE}" | tee "${SOURCES_FILE}" > /dev/null
echo -e "${GREEN}[✔] Sources.list reparado.${RESET}"


# --- PASO 2: Limpieza de Claves GPG ---
print_step 2 "Purgando Claves GPG corruptas"
rm -f /etc/apt/trusted.gpg.d/kali-archive-keyring.gpg
rm -f /etc/apt/trusted.gpg
echo -e "${GREEN}[✔] Claves antiguas eliminadas.${RESET}"


# --- PASO 3: Descarga Manual de Keyring ---
print_step 3 "Obteniendo últimas firmas de Kali"
echo -e "Buscando última versión en servidores..."

# Lógica inteligente para encontrar el .deb
LATEST_KEYRING_DEB=$(curl -s "${KEYRING_POOL_URL}" | grep -oE 'href="kali-archive-keyring_[0-9._-]+_all\.deb"' | cut -d'"' -f2 | sort -V | tail -n 1)

if [ -z "$LATEST_KEYRING_DEB" ]; then
    echo -e "${RED}[!] No se pudo encontrar el keyring online. Saltando reparación manual.${RESET}"
    SKIP_KEYRING=true
else
    FULL_URL="${KEYRING_POOL_URL}${LATEST_KEYRING_DEB}"
    echo -e "Descargando: ${BOLD}${LATEST_KEYRING_DEB}${RESET}"
    curl --silent --location --output "${KEYRING_DEB_TEMP_PATH}" "${FULL_URL}"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✔] Descarga completada. Instalando...${RESET}"
        dpkg -i "${KEYRING_DEB_TEMP_PATH}" > /dev/null 2>&1
        rm -f "${KEYRING_DEB_TEMP_PATH}"
        echo -e "${GREEN}[✔] Keyring instalado correctamente.${RESET}"
    else
        echo -e "${RED}[!] Fallo en la descarga.${RESET}"
    fi
fi


# --- PASO 4: Reparación y Actualización ---
print_step 4 "Actualización del Sistema (Full Upgrade)"

echo -e "${YELLOW}[*] Refrescando lista de paquetes...${RESET}"
apt-get update

echo -e "${YELLOW}[*] Corrigiendo instalaciones rotas previas...${RESET}"
apt-get install -f -y > /dev/null 2>&1

echo -e "${BOLD_YELLOW}[!] Iniciando Actualización Completa (Esto puede tardar)...${RESET}"
# Se usa full-upgrade con confirmación automática (-y)
apt-get full-upgrade -y

if [ $? -eq 0 ]; then
    UPGRADE_STATUS="${GREEN}EXITOSO${RESET}"
else
    UPGRADE_STATUS="${RED}CON ERRORES${RESET}"
fi


# --- PASO 5: Limpieza Final ---
print_step 5 "Limpieza de basura del sistema"
apt-get autoremove -y
apt-get autoclean -y
apt-get clean


# --- FINAL ---
echo -e "\n${BLUE}===================================================${RESET}"
echo -e "   ESTADO FINAL: ${UPGRADE_STATUS}"
echo -e "${BLUE}===================================================${RESET}"
echo -e "Se recomienda reiniciar el sistema si hubo actualizaciones de Kernel."
echo -e "${BOLD}Comando sugerido: reboot${RESET}"
echo ""

exit 0
