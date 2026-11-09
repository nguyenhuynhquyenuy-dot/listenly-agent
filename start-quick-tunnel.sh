#!/usr/bin/env bash
echo "========================================="
echo "  LISTENLY AGENT - CLOUDFLARE QUICK TUNNEL "
echo "========================================="

if ! command -v cloudflared &> /dev/null; then
    echo "Chưa tìm thấy cloudflared. Chạy qua Docker..."
    docker run --rm --net=host cloudflare/cloudflared:latest tunnel --url http://localhost:18790
else
    echo "Đang kết nối cổng 18790 tới Cloudflare..."
    cloudflared tunnel --url http://localhost:18790
fi
