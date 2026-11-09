<#
.SYNOPSIS
    Script tự động commit và đồng bộ push mã nguồn Listenly Agent lên GitHub repository.
.EXAMPLE
    .\sync.ps1
    .\sync.ps1 -Message "Cập nhật màu sắc giao diện và logo"
#>
param(
    [string]$Message = ""
)

$ErrorActionPreference = "Stop"

if (-not $Message) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Message = "Update Listenly Agent ($timestamp)"
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  LISTENLY AGENT - GITHUB AUTO SYNC     " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Check if there are changes
$status = git status --porcelain
if (-not $status) {
    Write-Host "Không có thay đổi nào cần đồng bộ." -ForegroundColor Yellow
    exit 0
}

Write-Host "[1/3] Đang thêm các file thay đổi..." -ForegroundColor Green
git add -A

Write-Host "[2/3] Đang commit với nội dung: '$Message'..." -ForegroundColor Green
git commit -m "$Message"

# Get current branch
$currentBranch = (git rev-parse --abbrev-ref HEAD).Trim()
Write-Host "[3/3] Đang push lên GitHub (nhánh $currentBranch)..." -ForegroundColor Green
git push origin $currentBranch

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Hoàn tất đồng bộ lên GitHub thành công!" -ForegroundColor Green
Write-Host " Repo: https://github.com/nguyenhuynhquyenuy-dot/listenly-agent" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
