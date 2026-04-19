#!/bin/bash
# Script de build release — Noor Islamic App
# Usage: ./store/build_release.sh [android|ios|all]

set -e

PLATFORM=${1:-"all"}
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //')
BUILD_NUMBER=$(echo $VERSION | sed 's/.*+//')
VERSION_NAME=$(echo $VERSION | sed 's/+.*//')
OUTPUT_DIR="build/releases"

echo "╔══════════════════════════════════════════╗"
echo "║      NOOR — Build Release v$VERSION_NAME        ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# Vérifications préalables
check_prerequisites() {
  echo "🔍 Vérification des prérequis..."

  if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter non trouvé. Installez Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
  fi

  FLUTTER_VERSION=$(flutter --version 2>&1 | head -1)
  echo "   ✅ $FLUTTER_VERSION"

  if [ ! -f "android/key.properties" ] && [ "$PLATFORM" != "ios" ]; then
    echo "   ⚠️  android/key.properties manquant. Build Android avec keystore debug."
    echo "      Exécutez store/generate_keystore.sh pour créer votre keystore."
  fi

  echo ""
}

# Nettoyage et préparation
prepare_build() {
  echo "🧹 Nettoyage du projet..."
  flutter clean
  echo ""

  echo "📦 Récupération des dépendances..."
  flutter pub get
  echo ""

  mkdir -p "$OUTPUT_DIR"
}

# Build Android AAB (Google Play)
build_android() {
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🤖 BUILD ANDROID — App Bundle (.aab)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # Analyse statique
  echo "🔎 Analyse du code..."
  flutter analyze --no-fatal-infos
  echo ""

  # Build release AAB
  echo "🏗️  Compilation AAB release..."
  flutter build appbundle \
    --release \
    --build-name="$VERSION_NAME" \
    --build-number="$BUILD_NUMBER" \
    --dart-define=APP_ENV=production \
    --obfuscate \
    --split-debug-info="$OUTPUT_DIR/android-debug-symbols"

  AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
  if [ -f "$AAB_PATH" ]; then
    cp "$AAB_PATH" "$OUTPUT_DIR/noor-v${VERSION_NAME}-${BUILD_NUMBER}.aab"
    AAB_SIZE=$(du -sh "$OUTPUT_DIR/noor-v${VERSION_NAME}-${BUILD_NUMBER}.aab" | cut -f1)
    echo ""
    echo "✅ AAB créé : $OUTPUT_DIR/noor-v${VERSION_NAME}-${BUILD_NUMBER}.aab ($AAB_SIZE)"
  fi

  # Build APK universel (optionnel, pour test direct)
  echo ""
  echo "🏗️  Compilation APK universel (test)..."
  flutter build apk \
    --release \
    --build-name="$VERSION_NAME" \
    --build-number="$BUILD_NUMBER"

  APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
  if [ -f "$APK_PATH" ]; then
    cp "$APK_PATH" "$OUTPUT_DIR/noor-v${VERSION_NAME}-universal.apk"
    APK_SIZE=$(du -sh "$OUTPUT_DIR/noor-v${VERSION_NAME}-universal.apk" | cut -f1)
    echo "✅ APK créé : $OUTPUT_DIR/noor-v${VERSION_NAME}-universal.apk ($APK_SIZE)"
  fi

  echo ""
  echo "📋 Prochaine étape Android:"
  echo "   1. Connectez-vous à https://play.google.com/console"
  echo "   2. Créez l'app si nécessaire (Bundle ID: com.noor.app)"
  echo "   3. Uploadez le fichier .aab dans Production > Create new release"
  echo ""
}

# Build iOS IPA (App Store)
build_ios() {
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🍎 BUILD iOS — Archive Xcode"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "⚠️  Le build iOS nécessite un Mac avec Xcode installé."
    echo "   Skipping iOS build."
    return 0
  fi

  # Vérifier Xcode
  if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode non trouvé. Installez Xcode depuis le Mac App Store."
    exit 1
  fi

  echo "🔎 Analyse du code..."
  flutter analyze --no-fatal-infos

  echo ""
  echo "🏗️  Compilation iOS release..."
  flutter build ios \
    --release \
    --build-name="$VERSION_NAME" \
    --build-number="$BUILD_NUMBER" \
    --no-codesign

  echo ""
  echo "📦 Création de l'archive Xcode..."
  cd ios && pod install --repo-update && cd ..

  echo ""
  echo "✅ Build iOS terminé."
  echo ""
  echo "📋 Prochaine étape iOS (depuis Xcode):"
  echo "   1. Ouvrez ios/Runner.xcworkspace dans Xcode"
  echo "   2. Configurez votre Team dans Signing & Capabilities"
  echo "   3. Product > Archive"
  echo "   4. Window > Organizer > Distribute App > App Store Connect"
  echo ""
}

# Rapport final
print_summary() {
  echo "╔══════════════════════════════════════════╗"
  echo "║           RÉSUMÉ DU BUILD                ║"
  echo "╚══════════════════════════════════════════╝"
  echo ""
  echo "📁 Fichiers générés dans : $OUTPUT_DIR/"
  ls -lh "$OUTPUT_DIR/" 2>/dev/null | tail -n +2 | awk '{print "   "$NF" ("$5")"}'
  echo ""
  echo "🔗 Liens utiles:"
  echo "   Google Play Console : https://play.google.com/console"
  echo "   App Store Connect   : https://appstoreconnect.apple.com"
  echo "   Privacy Policy      : store/privacy_policy.html"
  echo ""
  echo "✨ Build terminé avec succès !"
}

# Exécution
check_prerequisites
prepare_build

case "$PLATFORM" in
  "android") build_android ;;
  "ios") build_ios ;;
  "all") build_android; build_ios ;;
  *)
    echo "Usage: $0 [android|ios|all]"
    exit 1
    ;;
esac

print_summary
