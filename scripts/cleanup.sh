#!/bin/bash
set -e

echo "════════════════════════════════════════════════════════════════════════════════"
echo "🧹 STEP 10: Cleanup"
echo "════════════════════════════════════════════════════════════════════════════════"

docker rm -f olive-action-container || true

echo "════════════════════════════════════════════════════════════════════════════════"
echo "✅ Cleanup Complete"
echo "════════════════════════════════════════════════════════════════════════════════"
echo "" 