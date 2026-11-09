<#
.SYNOPSIS
    Khởi động Cloudflare Quick Tunnel cho Listenly Agent trên Windows.
    Cung cấp tên miền HTTPS ngẫu nhiên miễn phí từ Cloudflare ngay lập tức.
#>
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  LISTENLY AGENT - CLOUDFLARE QUICK TUNNEL " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Kiểm tra cloudflared đã cài đặt chưa
$cloudflared = Get-Command cloudflared -ErrorAction SilentlyContinue
if (-not $cloudflared) {
    Write-Host "Chưa tìm thấy cloudflared. Đang hướng dẫn tải..." -ForegroundColor Yellow
    Write-Host "Tải tại: https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.msi" -ForegroundColor Cyan
    exit 1
}

Write-Host "Đang kết nối cổng 18790 tới Cloudflare..." -ForegroundColor Green
Write-Host "Vui lòng xem link https://*.trycloudflare.com bên dưới:" -ForegroundColor Yellow
cloudflared tunnel --url http://localhost:18790
