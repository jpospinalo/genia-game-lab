#!/bin/bash
# ============================================================
# deploy.sh — Publica index.html en AWS S3
# Uso: ./aws/deploy.sh
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/config.sh"

GAME_FILE="$PROJECT_ROOT/index.html"

if [ ! -f "$GAME_FILE" ]; then
  echo "❌ No encontré index.html en la raíz del proyecto."
  exit 1
fi

echo ""
echo "🚀 Subiendo juego a AWS S3..."

# El acceso público se controla desde la política del bucket.
aws s3 cp "$GAME_FILE" "s3://$S3_BUCKET/index.html" \
  --content-type "text/html" \
  --cache-control "no-cache"

echo ""
echo "✅ Juego desplegado"
echo ""
echo "   URL pública: $GAME_URL"
echo ""

# Abrir la URL automáticamente cuando el sistema lo permita.
if command -v open &>/dev/null; then
  open "$GAME_URL"
elif command -v xdg-open &>/dev/null; then
  xdg-open "$GAME_URL"
fi
