# 💻 Entorno de Desarrollo LAMP Personalizado (Vagrant)

Este repositorio contiene la configuración completa de una pila LAMP (Linux, Apache, MySQL/MariaDB, PHP) distribuida en una arquitectura de **dos niveles** utilizando **Vagrant** y **VirtualBox**.

El objetivo es separar el **Servidor Web/Aplicación** del **Servidor de Base de Datos** para replicar un entorno de producción realista.

---

## ⚙️ Configuración del Entorno (Alexandro)

El entorno se compone de dos Máquinas Virtuales (VMs) basadas en **Debian 12 (Bookworm)**:

| Componente | VM Name (Hostname) | IP Privada | Puertos Expuestos (Host -> VM) | Scripts de Provisionamiento |
| :--- | :--- | :--- | :--- | :--- |
| **Nivel Web/App** | `AlexandroApache` | `192.168.1.5` | `8080` (HTTP) | `Apache.sh` |
| **Nivel Base de Datos** | `AlexandroMysql` | `192.168.1.6` | `8081` (phpMyAdmin) y `3306` (MySQL) | `Mysql.sh` |

### Credenciales de Base de Datos

| Detalle | Valor |
| :--- | :--- |
| **Usuario BD** | `alexandro` |
| **Contraseña BD** | `alexandro` |
| **Base de Datos** | `gestion_usuarios` |

---

## 🚀 Instrucciones de Despliegue

Sigue estos pasos en tu máquina real (host) para levantar el entorno:

### 1. Requisitos Previos

Asegúrate de tener instalados los siguientes programas en tu sistema:

* **Vagrant:** Herramienta para la gestión de VMs.
* **VirtualBox:** Proveedor de virtualización.
* **Git:** Para clonar el repositorio.

### 2. Clonar el Repositorio

Abre tu terminal en la carpeta donde guardas tus proyectos y clona este repositorio:

```bash
git clone [https://github.com/TU_USUARIO/NOMBRE_DEL_REPOSITORIO.git](https://github.com/TU_USUARIO/NOMBRE_DEL_REPOSITORIO.git)
cd NOMBRE_DEL_REPOSITORIO

3. Levantar las Máquinas Virtuales
Ejecuta el comando principal de Vagrant. Esto descargará las imágenes de Debian, iniciará ambas VMs y ejecutará los scripts de aprovisionamiento:
vagrant up







