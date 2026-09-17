#!/bin/bash
set -e

# ============================================================
# DESPLIEGUE — GenAI Game Lab
#
# Uso:
#   ./aws/deploy.sh           -> publica index.html
#   ./aws/deploy.sh starter   -> publica starter.html como index.html
#   ./aws/deploy.sh final     -> publica final.html como index.html
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Cargar configuración AWS
source "${SCRIPT_DIR}/config.sh"

# Seleccionar versión
VERSION="${1:-index}"

case "$VERSION" in
  index)
    SOURCE_FILE="${PROJECT_DIR}/index.html"
    LABEL="index.html (demo)"
    ;;
  starter)
    SOURCE_FILE="${PROJECT_DIR}/starter.html"
    LABEL="starter.html (versión base)"
    ;;
  final)
    SOURCE_FILE="${PROJECT_DIR}/final.html"
    LABEL="final.html (versión final)"
    ;;
  *)
    echo "❌ Versión no válida: $VERSION"
    echo ""
    echo "Uso:"
    echo "  ./aws/deploy.sh"
    echo "  ./aws/deploy.sh starter"
    echo "  ./aws/deploy.sh final"
    exit 1
    ;;
esac

# Verificar archivo
if [ ! -f "$SOURCE_FILE" ]; then
  echo "❌ No se encontró el archivo:"
  echo "   $SOURCE_FILE"
  exit 1
fi

echo ""
echo "🚀 Desplegando GenAI Game Lab"
echo "   Fuente:  $LABEL"
echo "   Destino: s3://${S3_BUCKET}/index.html"
echo ""

# Publicar SIEMPRE como index.html para conservar la misma URL
aws s3 cp "$SOURCE_FILE" "s3://${S3_BUCKET}/index.html" \
  --content-type "text/html" \
  --cache-control "no-cache"

echo ""
echo "✅ Juego desplegado correctamente"
echo ""
echo "============================================================"
echo "🌐 URL DEL JUEGO"
echo "$GAME_URL"
echo "============================================================"
echo ""

# Abrir URL automáticamente cuando sea posible
if command -v open >/dev/null 2>&1; then
  open "$GAME_URL"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$GAME_URL"
elif command -v start >/dev/null 2>&1; then
  start "$GAME_URL"
fi
