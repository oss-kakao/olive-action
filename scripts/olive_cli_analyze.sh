#!/bin/bash
set -e

echo "════════════════════════════════════════════════════════════════════════════════"
echo "📊 STEP 5: OLIVE CLI Analysis"
echo "════════════════════════════════════════════════════════════════════════════════"
echo '📋 Running analysis on repository...'
olive-cli analyze --mapping

if [ $? -ne 0 ]; then
  echo '❌ OLIVE CLI 분석 실패: 에러가 발생했습니다.'
  exit 1
fi

echo '📂 .olive directory structure:' && ls -al .olive
echo '📁 .olive/1 contents:' && ls -al .olive/1

echo "════════════════════════════════════════════════════════════════════════════════"
echo "✅ OLIVE CLI Analysis Complete"
echo "════════════════════════════════════════════════════════════════════════════════"
echo "" 