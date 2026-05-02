#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Build → GitHub Release → Discord notification
#
# Portable: copy scripts/distribute/ to any Flutter project.
# Project-specific config lives only in .env (gitignored).
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

: "${GITHUB_TOKEN:?GITHUB_TOKEN not set in .env}"
: "${GITHUB_REPO:?GITHUB_REPO not set in .env}"
: "${DISCORD_WEBHOOK:?DISCORD_WEBHOOK not set in .env}"
: "${APP_NAME:?APP_NAME not set in .env}"

APK_PATH="$PROJECT_ROOT/build/app/outputs/flutter-apk/app-release.apk"
TAG="build-$(date +%Y%m%d-%H%M%S)"
RELEASE_NOTES="${1:-$(git -C "$PROJECT_ROOT" log -1 --pretty=format:'%s' 2>/dev/null || echo 'Latest build')}"
APK_FILENAME="$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')-${TAG}.apk"   # e.g. lumen-build-20260501-120000.apk

# ── 1. Build ─────────────────────────────────────────────────────────────────
echo "🔨  Building $APP_NAME release APK..."
(cd "$PROJECT_ROOT" && flutter build apk --release)
echo ""

# ── 2. Create GitHub release ─────────────────────────────────────────────────
echo "📦  Creating GitHub release $TAG..."
RELEASE_JSON=$(TAG="$TAG" NOTES="$RELEASE_NOTES" python3 -c "
import json, os, urllib.request

payload = {
    'tag_name': os.environ['TAG'],
    'name':     os.environ['TAG'],
    'body':     os.environ['NOTES'],
    'draft':    False,
    'prerelease': True,
}
req = urllib.request.Request(
    'https://api.github.com/repos/$GITHUB_REPO/releases',
    data=json.dumps(payload).encode(),
    headers={
        'Authorization': 'token $GITHUB_TOKEN',
        'Content-Type':  'application/json',
        'Accept':        'application/vnd.github+json',
    },
    method='POST',
)
with urllib.request.urlopen(req) as r:
    print(r.read().decode())
")

RELEASE_ID=$(echo "$RELEASE_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")

# ── 3. Upload APK ─────────────────────────────────────────────────────────────
echo "⬆️   Uploading APK..."
ASSET_JSON=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/vnd.android.package-archive" \
  --data-binary @"$APK_PATH" \
  "https://uploads.github.com/repos/$GITHUB_REPO/releases/$RELEASE_ID/assets?name=$APK_FILENAME")

DOWNLOAD_URL=$(echo "$ASSET_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)['browser_download_url'])")

# ── 4. Notify Discord ─────────────────────────────────────────────────────────
echo "💬  Posting to Discord..."
TAG="$TAG" NOTES="$RELEASE_NOTES" URL="$DOWNLOAD_URL" \
APP="$APP_NAME" WEBHOOK="$DISCORD_WEBHOOK" python3 << 'PYEOF'
import json, urllib.request, os

tag   = os.environ["TAG"]
notes = os.environ["NOTES"]
url   = os.environ["URL"]
app   = os.environ["APP"]

payload = {
    "embeds": [{
        "title":       f"📱 {app} build ready",
        "description": notes,
        "url":         url,
        "color":       0xD4821E,
        "fields": [
            {"name": "Tag",      "value": tag,                          "inline": True},
            {"name": "Download", "value": f"[APK]({url})", "inline": True},
        ],
        "footer": {"text": "tap title or Download link to install"},
    }]
}

req = urllib.request.Request(
    os.environ["WEBHOOK"],
    data=json.dumps(payload).encode(),
    headers={"Content-Type": "application/json", "User-Agent": "DistributeBot/1.0"},
    method="POST",
)
try:
    urllib.request.urlopen(req)
except urllib.error.HTTPError as e:
    print(f"Discord error {e.code}: {e.read().decode()}")
    raise
PYEOF

echo ""
echo "✅  Done."
echo "    $DOWNLOAD_URL"
