<#
.SYNOPSIS
    Tự động khởi tạo file .env với các token bí mật cho Listenly / GoClaw trên Windows.
#>
$ErrorActionPreference = "Stop"

function Get-RandomHex([int]$bytes) {
    $buffer = New-Object byte[] $bytes
    [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($buffer)
    return [BitConverter]::ToString($buffer).Replace("-", "").ToLower()
}

$envFile = ".env"
$envExample = ".env.example"

Write-Host "=== Khởi tạo cấu hình môi trường Listenly Agent ===" -ForegroundColor Cyan

if (-not (Test-Path $envFile)) {
    if (Test-Path $envExample) {
        Copy-Item $envExample $envFile
        Write-Host "Đã tạo file .env từ .env.example" -ForegroundColor Green
    } else {
        New-Item -ItemType File -Path $envFile | Out-Null
    }
}

$content = Get-Content $envFile -Raw

# 1. GOCLAW_GATEWAY_TOKEN (32 bytes = 64 hex chars)
if ($content -notmatch '(?m)^GOCLAW_GATEWAY_TOKEN=[^\s\r\n]+') {
    $token = Get-RandomHex 32
    if ($content -match '(?m)^GOCLAW_GATEWAY_TOKEN=') {
        $content = $content -replace '(?m)^GOCLAW_GATEWAY_TOKEN=.*', "GOCLAW_GATEWAY_TOKEN=$token"
    } else {
        $content += "`nGOCLAW_GATEWAY_TOKEN=$token"
    }
    Write-Host "Generated GOCLAW_GATEWAY_TOKEN" -ForegroundColor Green
}

# 2. GOCLAW_ENCRYPTION_KEY (32 bytes = 64 hex chars)
if ($content -notmatch '(?m)^GOCLAW_ENCRYPTION_KEY=[^\s\r\n]+') {
    $key = Get-RandomHex 32
    if ($content -match '(?m)^GOCLAW_ENCRYPTION_KEY=') {
        $content = $content -replace '(?m)^GOCLAW_ENCRYPTION_KEY=.*', "GOCLAW_ENCRYPTION_KEY=$key"
    } else {
        $content += "`nGOCLAW_ENCRYPTION_KEY=$key"
    }
    Write-Host "Generated GOCLAW_ENCRYPTION_KEY" -ForegroundColor Green
}

# 3. POSTGRES_PASSWORD (16 bytes = 32 hex chars)
if ($content -notmatch '(?m)^POSTGRES_PASSWORD=[^\s\r\n]+') {
    $pgPass = Get-RandomHex 16
    if ($content -match '(?m)^POSTGRES_PASSWORD=') {
        $content = $content -replace '(?m)^POSTGRES_PASSWORD=.*', "POSTGRES_PASSWORD=$pgPass"
    } else {
        $content += "`nPOSTGRES_PASSWORD=$pgPass"
    }
    Write-Host "Generated POSTGRES_PASSWORD" -ForegroundColor Green
}

Set-Content $envFile -Value $content.Trim()
Write-Host "File .env đã sẵn sàng cho Docker!" -ForegroundColor Cyan
