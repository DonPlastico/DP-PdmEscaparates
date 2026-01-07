-- =================================================================
-- CONFIGURACIÓN DEL NÚCLEO (METADATA)
-- =================================================================
-- Versión del motor de FXServer (Cerulean es estable y moderno)
fx_version 'cerulean'

-- Juego soportado (GTA V)
game 'gta5'

-- Metadatos del recurso (Información visible en la consola o monitor)
author 'DP-Scripts'
description 'Script de escaparate PDM para Cardealers con multi-framework y localización'
version '1.2.0'

-- =================================================================
-- DEPENDENCIAS (RECURSOS REQUERIDOS)
-- =================================================================

-- El script esperará a que estos recursos inicien antes de arrancar.
-- Esto evita errores de "QBCore is nil" al iniciar el servidor.
dependencies {
    'qb-core', -- Framework principal
    'oxmysql' -- Conector de Base de Datos
}

-- =================================================================
-- INTERFAZ DE USUARIO (UI / NUI)
-- =================================================================

-- Archivo HTML principal que actúa como "página web" del menú
ui_page 'ui/index.html'

-- Lista de todos los archivos estáticos que el jugador debe descargar.
-- (HTML, CSS, JS, Fuentes, Imágenes, etc.)
files {'ui/index.html', 'ui/style.css', 'ui/script.js'}

-- =================================================================
-- SCRIPTS DE LÓGICA (ORDEN DE CARGA)
-- =================================================================

-- Scripts compartidos (Se cargan en Cliente Y Servidor simultáneamente).
-- Ideal para Configuración y Tablas de traducción.
shared_scripts {'config.lua'}

-- Scripts del Servidor (Base de Datos, Seguridad, Permisos).
-- Nadie puede ver este código desde el juego.
server_scripts {'server/sv_main.lua'}

-- Scripts del Cliente (Spawns, Menús, Interacción, Teclas).
-- Este código se ejecuta en el PC del jugador.
client_scripts {'client/cl_main.lua'}
