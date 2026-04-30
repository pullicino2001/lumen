#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Firebase App Distribution — portable deploy script
#
# Copy this entire scripts/firebase-distribute/ folder to any project.
# The only project-specific config lives in .env (never committed).
#
# Usage:
#   ./scripts/firebase-distribute/distribute.sh
#   ./scripts/firebase-distribute/distribute.sh "Fixed slider edge bug"
# -----------------------------------------------------------------------------

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

# Load project-specific config
if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌  Missing $ENV_FILE — copy .env.example and fill it in."
  exit 1
fi
# shellcheck source=/dev/null
source "$ENV_FILE"

# Validate required vars
: "${FIREBASE_APP_ID:?FIREBASE_APP_ID not set in .env}"
: "${FIREBASE_TESTERS:?FIREBASE_TESTERS not set in .env}"

# Release notes: CLI arg takes priority, then .env, then git commit
RELEASE_NOTES="${1:-${FIREBASE_RELEASE_NOTES:-}}"
if [[ -z "$RELEASE_NOTES" ]]; then
  RELEASE_NOTES="$(git -C "$PROJECT_ROOT" log -1 --pretty=format:'%s' 2>/dev/null || echo 'Latest build')"
fi

APK_PATH="$PROJECT_ROOT/build/app/outputs/flutter-apk/app-release.apk"

echo "🔨  Building release APK..."
(cd "$PROJECT_ROOT" && flutter build apk --release)

echo ""
echo "🚀  Uploading to Firebase App Distribution..."
echo "    App:   $FIREBASE_APP_ID"
echo "    Notes: $RELEASE_NOTES"
echo "    To:    $FIREBASE_TESTERS"
echo ""

firebase appdistribution:distribute "$APK_PATH" \
  --app "$FIREBASE_APP_ID" \
  --release-notes "$RELEASE_NOTES" \
  --testers "$FIREBASE_TESTERS"

echo ""
echo "✅  Done. Check your phone for the install notification."
