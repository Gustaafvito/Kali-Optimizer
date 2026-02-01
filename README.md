# 🐉 Kali Optimizer v2.0

![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Kali Linux](https://img.shields.io/badge/OS-Kali%20Linux-5C1F87?style=for-the-badge&logo=kali-linux&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=for-the-badge)

> **Herramienta automatizada de reparación, mantenimiento y optimización para Kali Linux.**

**Kali Optimizer** es un script de Bash avanzado diseñado para solucionar los problemas más comunes en la gestión de paquetes de Kali Linux. No solo actualiza el sistema, sino que **repara repositorios rotos, soluciona errores de firmas GPG y limpia el sistema** de forma inteligente.

---

## ⚡ Características Principales

| Función | Descripción |
| :--- | :--- |
| 🗝️ **Reparación GPG** | Detecta y soluciona errores de firmas inválidas (`NO_PUBKEY`) descargando manualmente el último `kali-archive-keyring`. |
| 📡 **Reset de Sources** | Restaura `/etc/apt/sources.list` a los repositorios oficiales de Kali Rolling, eliminando líneas corruptas. |
| 🛡️ **Refuerzo APT** | Intenta reinstalar componentes críticos (`apt-transport-https`, `ca-certificates`) antes de actualizar. |
| 🚀 **Full Upgrade** | Realiza una actualización completa (`full-upgrade`) forzando IPv4 para mayor estabilidad. |
| 🧹 **Limpieza Profunda** | Elimina paquetes huérfanos, dependencias rotas y limpia la caché de APT automáticamente. |
| 🎨 **Interfaz Visual** | Salida coloreada y estructurada para facilitar la lectura del progreso. |

---

## 🛠️ Instalación y Uso

### 1. Clonar el repositorio
```bash
git clone [https://github.com/Gustaafvito/Kali-Optimizer.git](https://github.com/Gustaafvito/Kali-Optimizer.git)
cd Kali-Optimizer
```
2. Dar permisos de ejecución
```Bash
chmod +x KaliOptimus.sh
```
3. Ejecutar (como Root)
```Bash
sudo ./KaliOptimus.sh
```

🔍 Solución de Problemas (Troubleshooting)
<details> <summary>🔻 <b>Haz clic aquí para ver soluciones a errores comunes</b></summary>


Error: "Method https has died unexpectedly!"
Si el script falla durante la descarga, suele ser un problema de red o corrupción en las librerías SSL.

Solución 1: Intenta cambiar de red (usa los datos móviles si estás en WiFi corporativo).

Solución 2: Ejecuta manualmente:

Bash
sudo apt --fix-broken install
sudo dpkg --configure -a
Fallo al descargar el Keyring
El script intenta "scrapear" la web oficial de Kali para bajar el último .deb. Si la web de Kali cambia su estructura HTML, este paso podría fallar.

Solución: Abre un Issue en este repositorio para que pueda actualizar el patrón de búsqueda.

</details>

📋 Requisitos
Sistema Operativo: Kali Linux (Rolling Release).

Conexión a Internet activa.

Privilegios de Root / Sudo.

Dependencias (preinstaladas habitualmente): curl, grep, dpkg, apt.

📄 Licencia
Este proyecto se distribuye bajo la Licencia MIT. Eres libre de usarlo, modificarlo y distribuirlo. Consulta el archivo LICENSE para más detalles.

<div align="center"> <sub>Desarrollado con 💀 por <a href="https://github.com/Gustaafvito">Gustaafvito</a></sub> </div>

