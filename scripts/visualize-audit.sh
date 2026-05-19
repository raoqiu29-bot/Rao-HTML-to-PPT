#!/usr/bin/env bash
#
# Rao-HTML-to-PPT · 可视化健康度审计(v5.11 新增 · 饶秋实战痛点)
#
# 输入:任何 v5.x HTML 课件
# 输出:每张片的文字密度 + 视觉密度报告 + 全 deck 健康指数 + 改造建议
#
# 设计哲学:
#   - 跟 audit-deck.sh 互补 — audit-deck 看"模块齐不齐",visualize-audit 看"视觉够不够"
#   - 不修改文件,只诊断
#   - 输出按"文字最多"排序,top 5 是最该改造的页
#   - 建议跟 references/visualization-first.md 的 10 个转换模式对应
#
# 用法:
#   bash scripts/visualize-audit.sh <file.html>
#   bash scripts/visualize-audit.sh <file.html> --top 10    # 显示前 10 个最该改的页(默认 5)
#

set -uo pipefail

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m'

# 参数解析
TOP=5
ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --top)
      shift; TOP="$1"; shift ;;
    *)
      ARGS+=("$1"); shift ;;
  esac
done
if [[ ${#ARGS[@]} -gt 0 ]]; then
  set -- "${ARGS[@]}"
else
  set --
fi

F="${1:-}"
if [[ -z "$F" ]]; then
  echo "用法:"
  echo "  bash scripts/visualize-audit.sh <file.html>"
  echo "  bash scripts/visualize-audit.sh <file.html> --top 10"
  exit 1
fi
if [[ ! -f "$F" ]]; then
  echo "[错误] 找不到文件: $F"
  exit 1
fi

# ======================================================================
# Python 做内容分析(精确 + 跨行 regex 友好)
# ======================================================================
python3 - "$F" "$TOP" <<'PYEOF'
import sys, re

F = sys.argv[1]
TOP = int(sys.argv[2])

with open(F) as f:
    html = f.read()

# 拆分每个 section.slide(先抓整个 section 块,再单独提 data-name)
section_re = re.compile(
    r'<section class="slide[^"]*"([^>]*)>(.*?)</section>',
    re.DOTALL
)
sections_raw = section_re.findall(html)

if not sections_raw:
    print("[错误] 没找到 section.slide,确认是 Rao-HTML-to-PPT 标准文件")
    sys.exit(1)

sections = []
for attrs, body in sections_raw:
    name_match = re.search(r'data-name="([^"]+)"', attrs)
    name = name_match.group(1) if name_match else '(unnamed)'
    sections.append((name, body))

results = []
for name, body in sections:
    # 纯文字字符数(去 HTML 标签)
    text = re.sub(r'<script.*?</script>', '', body, flags=re.DOTALL)
    text = re.sub(r'<style.*?</style>', '', text, flags=re.DOTALL)
    text = re.sub(r'<[^>]+>', '', text)
    text = re.sub(r'\s+', ' ', text).strip()
    chars = len(text)

    # 视觉元素计数(每类视觉武器单独算,有助于判断"用了哪些可视化版式")
    n_svg = len(re.findall(r'<svg', body))
    n_img = len(re.findall(r'<img', body))
    n_metric = len(re.findall(r'class="metric"', body))
    n_card = len(re.findall(r'class="card[\s\b]', body)) + len(re.findall(r'class="card[\s"]', body))
    n_process = len(re.findall(r'class="process-flow"', body))
    n_matrix = len(re.findall(r'class="matrix-2x2"', body))
    n_big_num = len(re.findall(r'class="big-number"', body))
    n_big_q = len(re.findall(r'class="big-quote"', body))
    n_prompt = len(re.findall(r'class="prompt-block"', body))
    n_task = len(re.findall(r'class="task-card"', body))
    n_insight = len(re.findall(r'class="insight-page"', body))

    # 视觉强度评分(每种武器权重不同)
    visual_score = (
        n_svg * 3 +           # SVG 图表权重高
        n_metric * 3 +        # metric 大数字权重高
        n_big_num * 5 +       # big-number hero 权重最高
        n_big_q * 4 +
        n_matrix * 4 +
        n_process * 4 +
        n_insight * 3 +
        n_img * 2 +
        n_task * 2 +
        n_card * 1            # card 文字含量大,权重低
    )

    # 判断"是否纯文字片"
    is_text_only = (n_svg == 0 and n_metric == 0 and n_big_num == 0 and
                     n_big_q == 0 and n_matrix == 0 and n_process == 0 and
                     n_img == 0)

    # 推荐改造方向(基于内容特征启发式)
    suggestion = ""
    if chars > 500 and is_text_only:
        if '小时' in text or '分钟' in text or '%' in text or '×' in text:
            suggestion = "✂ 数字对比 → metric-row + SVG 横条"
        elif text.count('、') > 4 or text.count('，') > 8:
            suggestion = "✂ 多并列项 → process-flow 或 card-grid + icon"
        else:
            suggestion = "✂ 长段落 → big-quote / insight-page / 3 卡 split"
    elif chars > 300 and n_card > 0 and n_svg == 0:
        suggestion = "✂ card 没图标 → 加 SVG icon(见 references/icons.md)"
    elif chars > 200 and is_text_only:
        suggestion = "○ 中等文字 → 加 1 个 SVG 或 metric"

    results.append({
        'name': name or '(unnamed)',
        'chars': chars,
        'svg': n_svg,
        'metric': n_metric,
        'card': n_card,
        'process': n_process,
        'matrix': n_matrix,
        'big': n_big_num + n_big_q,
        'visual_score': visual_score,
        'is_text_only': is_text_only,
        'suggestion': suggestion,
    })

# 颜色函数
RED = '\033[0;31m'; GREEN = '\033[0;32m'; YELLOW = '\033[0;33m'
BLUE = '\033[0;34m'; GRAY = '\033[0;90m'; BOLD = '\033[1m'; NC = '\033[0m'

def density_color(chars, is_text_only):
    if is_text_only and chars > 500: return RED + "🔴" + NC
    if is_text_only and chars > 300: return YELLOW + "🟡" + NC
    if is_text_only: return GRAY + "⚪" + NC
    if chars > 500: return YELLOW + "🟡" + NC
    return GREEN + "🟢" + NC

print()
print(f"{BOLD}{BLUE}=== 可视化健康度审计 · visualize-audit v5.11 ==={NC}")
print(f"{BLUE}文件: {F}{NC}")
print()

# ====== 全 deck 概览 ======
total = len(results)
total_chars = sum(r['chars'] for r in results)
text_only = sum(1 for r in results if r['is_text_only'])
high_text = sum(1 for r in results if r['chars'] > 500)
zero_visual = sum(1 for r in results if r['svg'] + r['metric'] + r['big'] == 0)
total_svg = sum(r['svg'] for r in results)
total_metric = sum(r['metric'] for r in results)
total_big = sum(r['big'] for r in results)

# 健康指数(0-100):视觉化越好分越高
visual_pct = (total - text_only) / max(total, 1) * 100
density_penalty = min(high_text / max(total, 1) * 60, 60)
health_score = max(0, min(100, visual_pct - density_penalty + (total_svg + total_metric + total_big) * 0.5))

print(f"{BOLD}--- 全 deck 概览 ---{NC}")
print(f"  总片数:              {total}")
print(f"  总字符:              {total_chars:,}")
print(f"  全文字页(0 视觉):   {text_only} / {total} ({text_only*100//total}%)")
print(f"  高文字密度(>500 字符):{high_text} / {total}")
print(f"  SVG 总数:            {total_svg}")
print(f"  metric 总数:         {total_metric}")
print(f"  Big Number/Quote:    {total_big}")
print()

# 健康指数颜色
if health_score >= 70:
    health_color = GREEN
    health_label = "良好"
elif health_score >= 40:
    health_color = YELLOW
    health_label = "中等 · 有改造空间"
else:
    health_color = RED
    health_label = "差 · 文字过多 · 需大规模可视化改造"

print(f"  {BOLD}视觉化健康指数:{NC}    {health_color}{health_score:.0f} / 100 · {health_label}{NC}")
print()

# ====== Top N 最该改造的页 ======
results.sort(key=lambda r: -r['chars'])
print(f"{BOLD}--- 文字最多 · TOP {TOP} 优先改造 ---{NC}")
print(f"  {GRAY}页面名{NC}{' ':27} {GRAY}字符{NC} {GRAY}SVG{NC} {GRAY}metric{NC} {GRAY}卡{NC}  {GRAY}改造建议{NC}")
print(f"  {'─' * 96}")
for r in results[:TOP]:
    name = r['name'][:30]
    icon = density_color(r['chars'], r['is_text_only'])
    print(f"  {icon} {name:<30} {r['chars']:>5} {r['svg']:>3} {r['metric']:>5}  {r['card']:>3}  {r['suggestion']}")
print()

# ====== 行动建议 ======
print(f"{BOLD}--- 行动建议 ---{NC}")
if health_score < 40:
    print(f"  {RED}⚠ 健康指数低 · 建议系统性可视化改造{NC}")
    print(f"  1. 优先改 TOP {TOP} 文字最多的页(见上)")
    print(f"  2. 参考 {BOLD}references/visualization-first.md{NC} 的 10 个转换模式")
    print(f"  3. 改完每页后重跑本工具,看健康指数是否上升")
elif health_score < 70:
    print(f"  {YELLOW}○ 有改造空间 · 挑 3-5 张文字最多的改一下就够{NC}")
    print(f"  优先看 {BOLD}references/visualization-first.md{NC} 的 \"模式 1-3\"")
else:
    print(f"  {GREEN}✓ 可视化已经做得不错 · 保持当前节奏{NC}")
print()

print(f"{GRAY}详细方法论: references/visualization-first.md{NC}")
print(f"{GRAY}下一步:挑 1 张文字最多的页,跟 AI 说 \"按 visualization-first 改造这页\",AI 会按 10 个模式重做。{NC}")
PYEOF
