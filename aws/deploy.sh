#!/bin/bash
# ============================================================
# deploy.sh — Publica el juego en Amazon S3
# Uso: ./aws/deploy.sh
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$SCRIPT_DIR/config.sh"

GAME_FILE="$PROJECT_DIR/index.html"

if [ ! -f "$GAME_FILE" ]; then
  echo "❌ No encontré index.html en: $PROJECT_DIR"
  exit 1
fi

echo ""
echo "🚀 Subiendo juego a Amazon S3..."

aws s3 cp "$GAME_FILE" "s3://$S3_BUCKET/index.html" \
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

# Abrir automáticamente en el navegador cuando sea posible
if command -v open &>/dev/null; then
  open "$GAME_URL"
elif command -v xdg-open &>/dev/null; then
  xdg-open "$GAME_URL"
elif command -v start &>/dev/null; then
  start "$GAME_URL"
fi
