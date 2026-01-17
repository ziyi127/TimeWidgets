# 显示当前版本信息
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TimeWidgets 版本信息" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 读取 pubspec.yaml 中的版本号
$pubspecPath = "pubspec.yaml"
if (Test-Path $pubspecPath) {
    $content = Get-Content $pubspecPath -Raw
    if ($content -match 'version:\s*(\d+\.\d+\.\d+\+\d+)') {
        $version = $matches[1]
        Write-Host "`n当前版本: v$version" -ForegroundColor Green
        
        # 分解版本号
        if ($version -match '(\d+)\.(\d+)\.(\d+)\+(\d+)') {
            $major = $matches[1]
            $minor = $matches[2]
            $patch = $matches[3]
            $build = $matches[4]
            
            Write-Host "`n版本组成:" -ForegroundColor Yellow
            Write-Host "  主版本号: $major" -ForegroundColor White
            Write-Host "  次版本号: $minor" -ForegroundColor White
            Write-Host "  修订号: $patch" -ForegroundColor White
            Write-Host "  构建号: $build" -ForegroundColor White
        }
    } else {
        Write-Host "`n无法读取版本号" -ForegroundColor Red
    }
} else {
    Write-Host "`n找不到 pubspec.yaml 文件" -ForegroundColor Red
}

# 显示 Git 信息
Write-Host "`nGit 信息:" -ForegroundColor Yellow
try {
    $branch = git rev-parse --abbrev-ref HEAD 2>$null
    if ($branch) {
        Write-Host "  当前分支: $branch" -ForegroundColor White
    }
    
    $commit = git rev-parse --short HEAD 2>$null
    if ($commit) {
        Write-Host "  最新提交: $commit" -ForegroundColor White
    }
    
    $tags = git tag --points-at HEAD 2>$null
    if ($tags) {
        Write-Host "  当前标签: $tags" -ForegroundColor White
    }
    
    $status = git status --porcelain 2>$null
    if ($status) {
        Write-Host "  状态: 有未提交的更改" -ForegroundColor Red
    } else {
        Write-Host "  状态: 工作区干净" -ForegroundColor Green
    }
} catch {
    Write-Host "  无法获取 Git 信息" -ForegroundColor Red
}

# 显示版本类型
Write-Host "`n版本类型:" -ForegroundColor Yellow
if ($version -match '^0\.') {
    Write-Host "  测试版本 (Pre-release)" -ForegroundColor Cyan
    if ($version -match '^0\.1\.') {
        Write-Host "  阶段: 早期测试 (Alpha/Beta)" -ForegroundColor Cyan
    } elseif ($version -match '^0\.9\.') {
        Write-Host "  阶段: 预发布 (Release Candidate)" -ForegroundColor Cyan
    } else {
        Write-Host "  阶段: 开发中 (Development)" -ForegroundColor Cyan
    }
} elseif ($version -match '^1\.') {
    Write-Host "  稳定版本 (Stable)" -ForegroundColor Green
} else {
    Write-Host "  未知版本类型" -ForegroundColor Yellow
}

Write-Host "`n========================================" -ForegroundColor Cyan
