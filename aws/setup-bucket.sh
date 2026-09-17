#!/bin/bash
# ============================================================
# setup-bucket.sh — Crea y configura el bucket S3 una sola vez
# Ejecuta esto ANTES de la demo (solo la primera vez)
# Uso: ./aws/setup-bucket.sh
# ============================================================

set -e
source "$(dirname "$0")/config.sh"

echo ""
echo "🪣 Preparando bucket S3: $S3_BUCKET"

# Crear el bucket solo si todavía no existe en la cuenta activa.
if aws s3api head-bucket --bucket "$S3_BUCKET" 2>/dev/null; then
  echo "✓ El bucket ya existe; se reutilizará."
else
  if [ "$AWS_DEFAULT_REGION" = "us-east-1" ]; then
    aws s3api create-bucket \
      --bucket "$S3_BUCKET" \
      --region "$AWS_DEFAULT_REGION"
  else
    aws s3api create-bucket \
      --bucket "$S3_BUCKET" \
      --region "$AWS_DEFAULT_REGION" \
      --create-bucket-configuration LocationConstraint="$AWS_DEFAULT_REGION"
  fi
fi

echo "🔓 Desactivando bloqueo de acceso público..."
aws s3api delete-public-access-block \
  --bucket "$S3_BUCKET"

echo "📋 Aplicando política de lectura pública..."
aws s3api put-bucket-policy \
  --bucket "$S3_BUCKET" \
  --policy "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [{
      \"Sid\": \"PublicRead\",
      \"Effect\": \"Allow\",
      \"Principal\": \"*\",
      \"Action\": \"s3:GetObject\",
      \"Resource\": \"arn:aws:s3:::${S3_BUCKET}/*\"
    }]
  }"

echo "🌐 Habilitando sitio web estático..."
aws s3api put-bucket-website \
  --bucket "$S3_BUCKET" \
  --website-configuration '{
    "IndexDocument": {"Suffix": "index.html"},
    "ErrorDocument": {"Key": "index.html"}
  }'

echo ""
echo "✅ Bucket listo para la demo"
echo ""
echo "   URL del juego: $GAME_URL"
echo ""
echo "   Ahora puedes usar ./aws/deploy.sh para subir el juego"
echo ""
