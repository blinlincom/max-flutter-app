# Max Flutter App GitHub上传脚本
# 请将YOUR_USERNAME替换为您的GitHub用户名，然后在PowerShell中运行此脚本

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUsername,
    
    [Parameter(Mandatory=$false)]
    [string]$RepoName = "max-flutter-app"
)

Write-Host "🚀 开始配置Max Flutter App GitHub上传..." -ForegroundColor Green

# 验证GitHub用户名
if ([string]::IsNullOrWhiteSpace($GitHubUsername)) {
    Write-Host "❌ 错误：请提供GitHub用户名" -ForegroundColor Red
    Write-Host "💡 使用方法：.\setup_github.ps1 -GitHubUsername '你的用户名'" -ForegroundColor Yellow
    exit 1
}

# 构建远程仓库地址
$remoteUrl = "https://github.com/$GitHubUsername/$RepoName.git"
Write-Host "📍 目标仓库地址：$remoteUrl" -ForegroundColor Cyan

try {
    # 检查是否存在远程仓库配置
    $existingRemote = git remote get-url origin 2>$null
    if ($existingRemote) {
        Write-Host "⚠️  检测到已存在的远程仓库配置：$existingRemote" -ForegroundColor Yellow
        $confirm = Read-Host "是否要替换现有配置？(y/N)"
        if ($confirm -eq 'y' -or $confirm -eq 'Y') {
            git remote remove origin
            Write-Host "✅ 已移除旧的远程仓库配置" -ForegroundColor Green
        } else {
            Write-Host "❌ 用户取消操作" -ForegroundColor Red
            exit 1
        }
    }

    # 添加远程仓库
    Write-Host "🔗 添加远程仓库..." -ForegroundColor Blue
    git remote add origin $remoteUrl
    
    # 验证远程仓库配置
    Write-Host "✅ 验证远程仓库配置..." -ForegroundColor Blue
    git remote -v
    
    # 检查当前分支
    $currentBranch = git branch --show-current
    Write-Host "📋 当前分支：$currentBranch" -ForegroundColor Cyan
    
    # 推送到GitHub
    Write-Host "📤 推送到GitHub..." -ForegroundColor Blue
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "🎉 成功推送到GitHub！" -ForegroundColor Green
        Write-Host "🌐 您的项目地址：https://github.com/$GitHubUsername/$RepoName" -ForegroundColor Cyan
        
        # 显示推送结果
        Write-Host "`n📊 推送验证：" -ForegroundColor Blue
        git log --oneline -3
        
        Write-Host "`n🎯 后续操作建议：" -ForegroundColor Yellow
        Write-Host "1. 访问GitHub仓库页面验证文件是否正确上传" -ForegroundColor White
        Write-Host "2. 添加项目描述和Topics标签" -ForegroundColor White
        Write-Host "3. 设置仓库可见性（Public/Private）" -ForegroundColor White
        Write-Host "4. 配置分支保护规则（可选）" -ForegroundColor White
        Write-Host "5. 启用GitHub Pages（如需Web演示）" -ForegroundColor White
        
    } else {
        Write-Host "❌ 推送失败！请检查以下事项：" -ForegroundColor Red
        Write-Host "1. GitHub仓库是否已创建" -ForegroundColor White
        Write-Host "2. 网络连接是否正常" -ForegroundColor White
        Write-Host "3. GitHub身份验证是否配置正确" -ForegroundColor White
        Write-Host "4. 仓库权限是否充足" -ForegroundColor White
    }
    
} catch {
    Write-Host "❌ 脚本执行出错：$($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`n✨ 脚本执行完成！" -ForegroundColor Green