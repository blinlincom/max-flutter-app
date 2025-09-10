@echo off
echo 正在推送项目到GitHub仓库...

echo 正在添加所有更改...
git add .

echo 正在提交更改...
git commit -m "Update UI design for all pages to match modern Xiaomi community style"

echo 正在推送到GitHub...
git push origin main

if %errorlevel% == 0 (
    echo 推送成功！
) else (
    echo 推送失败，请检查网络连接或认证信息。
    echo 错误代码: %errorlevel%
    echo 请尝试以下解决方案：
    echo 1. 检查网络连接
    echo 2. 配置GitHub个人访问令牌
    echo 3. 使用SSH密钥认证
    echo 4. 检查防火墙设置
)

pause