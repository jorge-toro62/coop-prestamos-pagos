# 🧮 Sistema de Gestión de Préstamos y Pagos – Entorno de Desarrollo

## 📘 Descripción General
Este entorno contiene la configuración completa del sistema **Coop Préstamos Pagos**, desarrollado con:

- **Backend:** Django + Django REST Framework (DRF)
- **Frontend:** React + Vite + TypeScript
- **Base de datos:** SQLite (modo local, adaptable a MySQL)
- **Lenguaje:** Python 3.12 / Node.js 18+
- **Entorno:** Visual Studio Code / Git Bash

---

## ⚙️ Estructura del Proyecto

coop-prestamos-pagos/
└── entrega-uno/

├── documentacion/

└── entorno-desarrollo/

└── coop/

├── core/ # Proyecto principal de Django

├── frontend/ # Proyecto React (Vite + TypeScript)

├── db.sqlite3 # (no usada, solo referencia inicial)

├── manage.py # Comandos de Django

├── requirements.txt # Dependencias del backend

└── .gitignore # Reglas de exclusión


---

## ⚙️ Configuración de Base de Datos MySQL/MariaDB

En `core/settings.py` configura tus credenciales de conexión:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'coop_prestamos',      # nombre de la base de datos
        'USER': 'root',                # usuario MySQL/MariaDB
        'PASSWORD': 'tu_contraseña',   # contraseña
        'HOST': '127.0.0.1',
        'PORT': '3306',
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'"
        }
    }
}
```

---
## 🚀 Instalación y Ejecución

## 1️⃣ Clonar el repositorio
git clone https://github.com/JFabian2606/coop-prestamos-pagos.git
cd coop-prestamos-pagos/entrega-uno/entorno-desarrollo/coop

## 2️⃣ Configurar el entorno virtual y dependencias
python -m venv .venv
. .venv\Scripts\Activate.ps1
pip install -r requirements.txt

## 3️⃣ Crear y migrar la base de datos
python manage.py makemigrations
python manage.py migrate

## 4️⃣ Ejecutar el servidor Django
python manage.py runserver

---

## ⚛️ Frontend (React + Vite)
cd frontend/coop-frontend
npm install
npm run dev

---

## 🧠 Notas importantes

Asegúrate de tener MySQL o MariaDB instalado y corriendo.

Dependencia clave: mysqlclient incluida en requirements.txt.

Para despliegue, se recomienda usar Render (backend) y Netlify (frontend).
