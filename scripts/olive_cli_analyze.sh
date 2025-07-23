#!/bin/bash
set -e

echo '📋 Step 3: Running analysis on repository...'
olive-cli analyze --mapping

if [ $? -ne 0 ]; then
  echo '❌ Olive CLI 분석 실패: 에러가 발생했습니다.'
  exit 1
fi

echo '📂 .olive directory structure:' && ls -al .olive
echo '📁 .olive/1 contents:' && ls -al .olive/1 