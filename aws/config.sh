#!/bin/bash
# ============================================================
# CONFIGURACIÓN AWS — GenAI Game Lab
# Despliegue del videojuego como sitio web estático en Amazon S3
# ============================================================

# Región de AWS
export AWS_DEFAULT_REGION="us-east-1"

# Obtener automáticamente el ID de la cuenta activa de AWS
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Bucket S3 con nombre globalmente único
export S3_BUCKET="genia-game-${AWS_ACCOUNT_ID}"

# URL pública del videojuego
export GAME_URL="http://${S3_BUCKET}.s3-website-${AWS_DEFAULT_REGION}.amazonaws.com/index.html"

echo "✓ Config cargada"
echo "  Bucket:  s3://$S3_BUCKET"
echo "  Región:  $AWS_DEFAULT_REGION"
echo "  URL:     $GAME_URL"
