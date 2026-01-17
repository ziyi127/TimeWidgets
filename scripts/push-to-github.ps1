# PowerShell 脚本用于推送代码到 GitHub
param(
    [string]$Message = "Update code",
    [string]$Branch = "main"
)

Write-Host "=== 推送代码到 GitHub ===" -ForegroundColor Cyan

# 检查 Git 状态
Write-Host "`n1. 检查 Git 状态..." -ForegroundColor Yellow
git status

# 添加所有更改
Write-Host "`n2. 添加所有更改..." -ForegroundColor Yellow
git add .

# 提交更改
Write-Host "`n3. 提交更改..." -ForegroundColor Yellow
git commit -m $Message

# 推送到远程仓库
Write-Host "`n4. 推送到远程仓库 ($Branch)..." -ForegroundColor Yellow
git push origin $Branch

Write-Host "`n✅ 完成！代码已推送到 GitHub" -ForegroundColor Green
Write-Host "查看仓库: https://github.com/your-username/time_widgets" -ForegroundColor Cyan
