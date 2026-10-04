#!/bin/bash

# 1. Definimos tu objetivo
TARGET="https://ejemplo.com"

echo "[*] Calculando el tamaño base de las respuestas de error..."

# 2. Usamos curl para enviar un método HTTP que no existe (ej: "INVENTO")
# -s : Modo silencioso (no muestra la barra de progreso)
# -w '%{size_download}' : Extrae matemáticamente el tamaño exacto de los bytes descargados
# -o /dev/null : Tira el código HTML a la basura, solo queremos el número
RUIDO_SIZE=$(curl -s -X INVENTO $TARGET -w '%{size_download}' -o /dev/null)

echo "[+] Tamaño de bloqueo detectado: $RUIDO_SIZE bytes. Iniciando ffuf..."

# 3. Lanzamos ffuf inyectando la variable $RUIDO_SIZE directamente en -fs
ffuf -u $TARGET \
-w /usr/share/wordlists/http_simple_methods_flat.txt:METHOD \
-w /usr/share/wordlists/headers_wordlist_flat.txt:HEADER \
-X METHOD \
-H "HEADER: valor-prueba" \
-mc all \
-fs $RUIDO_SIZE \
-of csv -o headersvalid.csv
