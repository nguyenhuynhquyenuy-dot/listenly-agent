#!/usr/bin/env bash
set -e

MESSAGE="$1"
if [ -z "$MESSAGE" ]; then
    MESSAGE="Update Listenly Agent ($(date '+%Y-%m-%d %H:%M:%S'))"
fi

echo "========================================"
echo "  LISTENLY AGENT - GITHUB AUTO SYNC     "
echo "========================================"

if [ -z "$(git status --porcelain)" ]; then
    echo "Không có thay đổi nào cần đồng bộ."
    exit 0
fi

echo "[1/3] Đang thêm các file thay đổi..."
git add -A

echo "[2/3] Đang commit với nội dung: '$MESSAGE'..."
git commit -m "$MESSAGE"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "[3/3] Đang push lên GitHub (nhánh $CURRENT_BRANCH)..."
git push origin "$CURRENT_BRANCH"

echo "========================================"
echo " Hoàn tất đồng bộ lên GitHub thành công!"
echo " Repo: https://github.com/nguyenhuynhquyenuy-dot/listenly-agent"
echo "========================================"
