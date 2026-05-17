# dotfiles

个人服务器 zsh 环境配置 (Zim + Powerlevel10k + eza/zoxide/fzf/bat)。

## 一键部署

    git clone https://github.com/你的用户名/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    chmod +x install.sh
    ./install.sh
    exec zsh

## 包含内容

- Zim — zsh 框架,模块见 .zimrc
- Powerlevel10k — 提示符主题
- eza — 带图标的 ls(需终端字体为 Nerd Font)
- zoxide — 智能目录跳转,用 z 代替 cd
- fzf — 模糊查找,Ctrl+R 历史 / Ctrl+T 文件
- bat — 带高亮的 cat

## 字体

终端需使用 Nerd Font(推荐 0xProto Nerd Font),否则图标显示为方块。
字体装在本地机器,服务器端无需安装。

## 说明

- 安装脚本自动备份已存在的配置为 .bak-时间戳
- 部署时自动清除 CRLF,配合 .gitattributes 防止 Windows 换行符污染
- 适用于 Debian / Ubuntu