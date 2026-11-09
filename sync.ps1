param(
    [string]$Message = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Message)) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Message = "Update Listenly Agent ($timestamp)"
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  LISTENLY AGENT - GITHUB AUTO SYNC     " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$status = (git status --porcelain)
if (-not $status) {
    Write-Host "Khong co thay doi nao can dong bo." -ForegroundColor Yellow
    exit 0
}

Write-Host "[1/3] Dang them cac file thay doi..." -ForegroundColor Green
git add -A

Write-Host "[2/3] Dang commit: '$Message'..." -ForegroundColor Green
git commit -m "$Message"

$currentBranch = (git rev-parse --abbrev-ref HEAD).Trim()
Write-Host "[3/3] Dang push len GitHub ($currentBranch)..." -ForegroundColor Green
git push origin $currentBranch

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Hoan tat dong bo len GitHub!" -ForegroundColor Green
Write-Host " Repo: https://github.com/nguyenhuynhquyenuy-dot/listenly-agent" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
