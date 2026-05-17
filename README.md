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

## 字体(重要)

终端需使用 Nerd Font(推荐 0xProto Nerd Font),否则图标显示为方块。
字体装在本地机器,服务器端无需安装。

eza 的图标由**本地终端**的字体渲染,**不需要在服务器上安装字体**。

请在你本地用来 SSH 的机器上安装 **0xProto Nerd Font**:
- 下载:https://github.com/ryanoasis/nerd-fonts/releases (找 0xProto)
- 或 https://www.nerdfonts.com
- 装好后,在终端设置里把字体设为 `0xProto Nerd Font`

若图标显示为方块 □ 或问号,即本地字体未生效。

## 说明

- 安装脚本自动备份已存在的配置为 .bak-时间戳
- 部署时自动清除 CRLF,配合 .gitattributes 防止 Windows 换行符污染
- 适用于 Debian / Ubuntu