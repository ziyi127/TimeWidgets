# PowerShell 脚本用于创建新版本发布
param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

# 验证版本号格式
if ($Version -notmatch '^v?\d+\.\d+\.\d+$') {
    Write-Error "版本号格式错误。请使用格式: 1.0.0 或 v1.0.0"
    exit 1
}

# 确保版本号以 v 开头
if ($Version -notmatch '^v') {
    $Version = "v$Version"
}

Write-Host "准备发布版本: $Version" -ForegroundColor Green

# 检查是否有未提交的更改
$status = git status --porcelain
if ($status) {
    Write-Error "存在未提交的更改，请先提交或暂存"
    exit 1
}

# 更新 pubspec.yaml 中的版本号
$versionNumber = $Version -replace '^v', ''
$pubspecPath = "pubspec.yaml"
$pubspecContent = Get-Content $pubspecPath -Raw
$pubspecContent = $pubspecContent -replace 'version:\s*\d+\.\d+\.\d+\+\d+', "version: $versionNumber+1"
Set-Content $pubspecPath $pubspecContent

Write-Host "已更新 pubspec.yaml 版本号为: $versionNumber" -ForegroundColor Yellow

# 提交版本更改
git add pubspec.yaml
git commit -m "chore: bump version to $Version"

# 创建 tag
git tag -a $Version -m "Release $Version"

Write-Host "已创建 tag: $Version" -ForegroundColor Green

# 询问是否推送
$push = Read-Host "是否推送到远程仓库? (y/n)"
if ($push -eq 'y' -or $push -eq 'Y') {
    git push origin main
    git push origin $Version
    Write-Host "已推送到远程仓库，GitHub Actions 将自动开始构建" -ForegroundColor Green
} else {
    Write-Host "未推送。稍后可以手动推送:" -ForegroundColor Yellow
    Write-Host "  git push origin main" -ForegroundColor Cyan
    Write-Host "  git push origin $Version" -ForegroundColor Cyan
}
