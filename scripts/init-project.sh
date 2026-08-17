#!/usr/bin/env bash
# 用法: scripts/init-project.sh <项目名>
# 作用: 在 projects/<项目名>/ 下创建项目骨架(框架/项目分离),memory 从框架模板复制
set -euo pipefail

NAME="${1:?用法: scripts/init-project.sh <项目名>}"
# 项目名仅允许小写字母/数字/连字符,防止路径问题
case "$NAME" in
  *[!a-z0-9-]*|[!a-z0-9-]*) echo "错误: 项目名仅允许小写字母、数字、连字符(如 fridge-keeper)"; exit 1 ;;
esac

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
P="$ROOT/projects/$NAME"

if [ -e "$P" ]; then echo "已存在: $P(如需重新初始化请先删除)"; exit 1; fi

mkdir -p "$P"/docs/{01-brainstorm,02-market,03-requirements,04-tech,05-uiux,06-ai-plan,07-business,08-retro} \
         "$P"/UI "$P"/memory
cp "$ROOT"/memory/*.md "$P"/memory/

echo "项目已创建: $P"
echo "下一步: 在仓库根打开 AI 代理会话,说「读 AGENTS.md,按工作流启动项目 $NAME」"
echo "(阶段 0 将清除 memory/ 示例行并与你确认项目画像)"
