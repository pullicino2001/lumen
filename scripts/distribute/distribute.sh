#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Build → Discord (direct APK attachment)
#
# Builds a split-per-abi release APK and attaches the arm64 slice directly
# to a Discord webhook — no GitHub redirect, no stalled downloads.
#
# Usage:
#   ./scripts/distribute/distribute.sh
#   ./scripts/distribute/distribute.sh "Fixed slider edge bug"
# -----------------------------------------------------------------------------

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌  Missing $ENV_FILE — copy .env.example and fill it in."
  exit 1
fi
# shellcheck source=/dev/null
source "$ENV_FILE"

: "${DISCORD_WEBHOOK:?DISCORD_WEBHOOK not set in .env}"
: "${APP_NAME:?APP_NAME not set in .env}"

TAG="build-$(date +%Y%m%d-%H%M%S)"
RELEASE_NOTES="${1:-$(git -C "$PROJECT_ROOT" log -1 --pretty=format:'%s' 2>/dev/null || echo 'Latest build')}"

APK_DIR="$PROJECT_ROOT/build/app/outputs/flutter-apk"
APK_PATH="$APK_DIR/app-arm64-v8a-release.apk"
APK_FILENAME="$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')-${TAG}-arm64.apk"

# ── 1. Build ──────────────────────────────────────────────────────────────────
echo "🔨  Building $APP_NAME split-per-abi release APK..."
(cd "$PROJECT_ROOT" && flutter build apk --release --split-per-abi)
echo ""

if [[ ! -f "$APK_PATH" ]]; then
  echo "❌  arm64 APK not found at $APK_PATH"
  exit 1
fi

APK_SIZE=$(du -sh "$APK_PATH" | cut -f1)
echo "📦  arm64 APK: $APK_SIZE  →  $APK_FILENAME"
echo ""

# ── 2. Attach to Discord ──────────────────────────────────────────────────────
echo "💬  Posting to Discord..."

PAYLOAD=$(python3 -c "
import json
print(json.dumps({
    'content': '📱 **${APP_NAME}** \`${TAG}\`',
    'embeds': [{
        'description': '''${RELEASE_NOTES}''',
        'color': 0xD4821E,
        'footer': {'text': 'arm64-v8a • ${APK_SIZE}'}
    }]
}))
")

curl -s -X POST "$DISCORD_WEBHOOK" \
  -F "payload_json=$PAYLOAD" \
  -F "file=@${APK_PATH};filename=${APK_FILENAME}" \
  > /dev/null

echo ""
echo "✅  Done — $APK_FILENAME posted to Discord."
