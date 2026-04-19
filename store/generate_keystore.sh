#!/bin/bash
# Script de génération du keystore Android pour Noor
# À exécuter UNE SEULE FOIS - conservez le keystore en sécurité !

set -e

KEYSTORE_DIR="../android/keystore"
KEYSTORE_FILE="$KEYSTORE_DIR/noor-release.keystore"
KEY_ALIAS="noor-key"

mkdir -p "$KEYSTORE_DIR"

echo "================================================"
echo "  Génération du Keystore Android pour Noor"
echo "================================================"
echo ""
echo "⚠️  IMPORTANT: Conservez ce fichier en lieu sûr."
echo "   Sans lui, vous ne pourrez plus mettre à jour l'app."
echo ""

read -p "Mot de passe du keystore (min 6 caractères): " STORE_PASS
read -p "Mot de passe de la clé (min 6 caractères): " KEY_PASS
read -p "Votre nom complet: " FULL_NAME
read -p "Nom de votre organisation: " ORG
read -p "Ville: " CITY
read -p "Pays (ex: FR): " COUNTRY

keytool -genkey -v \
  -keystore "$KEYSTORE_FILE" \
  -alias "$KEY_ALIAS" \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storepass "$STORE_PASS" \
  -keypass "$KEY_PASS" \
  -dname "CN=$FULL_NAME, O=$ORG, L=$CITY, C=$COUNTRY"

echo ""
echo "✅ Keystore créé: $KEYSTORE_FILE"
echo ""

# Créer key.properties automatiquement
cat > "../android/key.properties" << EOF
storePassword=$STORE_PASS
keyPassword=$KEY_PASS
keyAlias=$KEY_ALIAS
storeFile=../keystore/noor-release.keystore
EOF

echo "✅ key.properties créé"
echo ""
echo "🔒 Actions requises:"
echo "   1. Sauvegardez $KEYSTORE_FILE dans un endroit sécurisé (cloud privé, USB...)"
echo "   2. Notez vos mots de passe dans un gestionnaire de mots de passe"
echo "   3. Vérifiez que keystore/ est dans .gitignore"
echo ""

# Vérifier .gitignore
if ! grep -q "keystore/" "../android/.gitignore" 2>/dev/null; then
  echo "keystore/" >> "../.gitignore"
  echo "android/key.properties" >> "../.gitignore"
  echo "✅ .gitignore mis à jour"
fi

echo "================================================"
echo "  Fingerprint SHA-1 de votre clé:"
keytool -list -v -keystore "$KEYSTORE_FILE" -alias "$KEY_ALIAS" \
  -storepass "$STORE_PASS" 2>/dev/null | grep "SHA1:" | head -1
echo "================================================"
