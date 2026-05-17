# ============================================================
#  .zshenv — 最早加载,先于 /etc/zsh/zshrc
# ============================================================
# 跳过 Debian/Ubuntu 系统级 /etc/zsh/zshrc 里的 compinit,
# 避免与 Zim 的 completion 模块重复初始化(消除启动 warning)。
skip_global_compinit=1