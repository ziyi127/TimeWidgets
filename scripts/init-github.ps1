# PowerShell 脚本用于初始化 GitHub 仓库
param(
    [Parameter(Mandatory=$true)]
    [string]$RepoUrl
)

Write-Host "=== 初始化 GitHub 仓库 ===" -ForegroundColor Cyan

# 检查是否已经是 Git 仓库
if (Test-Path ".git") {
    Write-Host "已经是 Git 仓库" -ForegroundColor Yellow
    
    # 检查是否已有远程仓库
    $remotes = git remote -v
    if ($remotes) {
        Write-Host "`n当前远程仓库:" -ForegroundColor Yellow
        Write-Host $remotes
        
        $update = Read-Host "`n是否更新远程仓库地址? (y/n)"
        if ($update -eq 'y' -or $update -eq 'Y') {
            git remote set-url origin $RepoUrl
            Write-Host "已更新远程仓库地址" -ForegroundColor Green
        }
    } else {
        git remote add origin $RepoUrl
        Write-Host "已添加远程仓库" -ForegroundColor Green
    }
} else {
    # 初始化 Git 仓库
    Write-Host "`n1. 初始化 Git 仓库..." -ForegroundColor Yellow
    git init
    
    # 添加远程仓库
    Write-Host "`n2. 添加远程仓库..." -ForegroundColor Yellow
    git remote add origin $RepoUrl
    
    # 创建初始提交
    Write-Host "`n3. 创建初始提交..." -ForegroundColor Yellow
    git add .
    git commit -m "Initial commit"
    
    Write-Host "`n✅ Git 仓库初始化完成" -ForegroundColor Green
}

# 推送到 GitHub
Write-Host "`n准备推送到 GitHub..." -ForegroundColor Yellow
$push = Read-Host "是否立即推送? (y/n)"
if ($push -eq 'y' -or $push -eq 'Y') {
    git branch -M main
    git push -u origin main
    Write-Host "`n✅ 代码已推送到 GitHub" -ForegroundColor Green
    Write-Host "查看仓库: $RepoUrl" -ForegroundColor Cyan
} else {
    Write-Host "`n稍后可以手动推送:" -ForegroundColor Yellow
    Write-Host "  git branch -M main" -ForegroundColor Cyan
    Write-Host "  git push -u origin main" -ForegroundColor Cyan
}
