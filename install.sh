#!/usr/bin/env bash
# ============================================================
#  dotfiles 一键部署脚本
#  用法: ./install.sh
#  适用: Debian / Ubuntu
# ============================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

info()  { echo -e "\033[1;34m[INFO]\033[0m  $1"; }
ok()    { echo -e "\033[1;32m[ OK ]\033[0m  $1"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m  $1"; }
err()   { echo -e "\033[1;31m[ERR ]\033[0m  $1"; }

# ---- 0. 前置检查 ----
if ! command -v sudo >/dev/null 2>&1; then
    err "未找到 sudo,请用 root 运行或先安装 sudo"
    exit 1
fi

# ---- 1. 检测并安装基础依赖 ----
info "更新 apt..."
sudo apt update -y

for pkg in zsh git curl unzip; do
    if command -v "$pkg" >/dev/null 2>&1 || dpkg -s "$pkg" >/dev/null 2>&1; then
        ok "$pkg 已安装"
    else
        info "安装 $pkg..."
        sudo apt install -y "$pkg"
    fi
done

# ---- 2. 安装命令行增强工具 ----
info "安装命令行工具 (eza / zoxide / fzf / bat)..."
sudo apt install -y zoxide fzf bat || warn "部分工具安装失败,稍后可手动补装"

if ! command -v eza >/dev/null 2>&1; then
    if ! sudo apt install -y eza 2>/dev/null; then
        warn "apt 源里没有 eza,尝试添加官方源..."
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
        | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
        | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
        sudo apt update -y && sudo apt install -y eza || warn "eza 安装失败,请手动处理"
    fi
fi
ok "命令行工具安装完成"

# ---- 3. 安装 Zim ----
if [[ ! -d "${HOME}/.zim" ]]; then
    info "安装 Zim..."
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh -o /tmp/zim-install.zsh
    zsh /tmp/zim-install.zsh
    rm -f /tmp/zim-install.zsh
    ok "Zim 安装完成"
else
    ok "Zim 已存在,跳过"
fi

# ---- 4. 备份并部署配置文件(部署时自动清除 CRLF)----
deploy() {
    local src="$1" dst="$2"
    if [[ ! -f "$src" ]]; then
        warn "源文件不存在,跳过: $src"
        return
    fi
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        cp "$dst" "${dst}.bak-${TIMESTAMP}"
        warn "已备份原文件: ${dst}.bak-${TIMESTAMP}"
    fi
    # 用 sed 清除可能的 Windows CRLF,确保 Unix 换行
    sed 's/\r$//' "$src" > "$dst"
    ok "已部署: $dst"
}

info "部署配置文件..."
deploy "${DOTFILES_DIR}/.zshrc"  "${HOME}/.zshrc"
deploy "${DOTFILES_DIR}/.zimrc"  "${HOME}/.zimrc"

# ---- 4b. 部署 .zshenv(修复 compinit 重复初始化)----
if [[ -f /etc/zsh/zshrc ]] && grep -q "skip_global_compinit" /etc/zsh/zshrc; then
    deploy "${DOTFILES_DIR}/.zshenv" "${HOME}/.zshenv"
    ok "系统支持 skip_global_compinit,已部署 .zshenv"
else
    warn "系统 /etc/zsh/zshrc 不识别 skip_global_compinit,跳过 .zshenv"
fi

# ---- 5. 安装 Zim 模块 ----
info "安装 Zim 模块 (forgit / p10k / 高亮 等)..."
zsh -ic 'zimfw install' || warn "zimfw install 执行异常,可登录后手动重试"
ok "Zim 模块处理完成"

# ---- 6. 设置 zsh 为默认 shell ----
if [[ "${SHELL:-}" != *zsh ]]; then
    info "将 zsh 设为默认 shell..."
    if chsh -s "$(command -v zsh)"; then
        ok "默认 shell 已切换为 zsh (下次登录生效)"
    else
        warn "chsh 失败,请手动执行: chsh -s \$(which zsh)"
    fi
else
    ok "默认 shell 已是 zsh"
fi

echo
ok "全部完成!请重新登录,或执行: exec zsh"
warn "首次进入会触发 p10k 配置向导;若已有 ~/.p10k.zsh 则直接生效"