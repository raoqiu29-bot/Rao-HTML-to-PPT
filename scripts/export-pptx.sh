#!/usr/bin/env bash
#
# raoqiu-slide-builder · HTML PPT → 可编辑 PPTX 导出脚本(v5.4)
# 借鉴 PptxGenJS + Playwright 工业标准
#
# 用法:
#   bash scripts/export-pptx.sh <input.html> [output.pptx] [--compact]
#
# 参数:
#   input.html   - 要导出的 HTML PPT(必填,raoqiu-slide-builder v5.x 生成的)
#   output.pptx  - 输出 PPTX 路径(可选,默认放在 input.html 同目录)
#   --compact    - 用 1280x720 替代 1920x1080(文件小 50-70%,适合邮件发送)
#
# 实现机制(alpha 版):
#   - Playwright headless Chromium 加载 HTML PPT
#   - 跳到每一页 + 截图(1920x1080 PNG)
#   - PptxGenJS 创建 16:9 .pptx,每页嵌一张全屏图片
#   - 客户能在 PowerPoint / Keynote 打开 → 看到 100% 一致视觉
#   - **限制**:每页是图片,不能改文字(如需真"可编辑",等 v5.4-beta 用 dom-to-pptx)
#
# 依赖:
#   Node.js + npx + playwright + pptxgenjs(首次跑会自动装,约 200MB,30-90s)

set -euo pipefail

# ======================================================================
# 参数解析
# ======================================================================
INPUT=""
OUTPUT=""
COMPACT="false"

for arg in "$@"; do
  case "$arg" in
    --compact) COMPACT="true" ;;
    *.html)    INPUT="$arg" ;;
    *.pptx)    OUTPUT="$arg" ;;
    *)         echo "[警告] 未识别参数: $arg" ;;
  esac
done

if [[ -z "$INPUT" ]]; then
  echo "用法: bash scripts/export-pptx.sh <input.html> [output.pptx] [--compact]"
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "[错误] 找不到文件: $INPUT"
  exit 1
fi

# 默认输出路径:同目录,扩展名换成 .pptx
if [[ -z "$OUTPUT" ]]; then
  OUTPUT="${INPUT%.html}.pptx"
fi

# 分辨率
if [[ "$COMPACT" == "true" ]]; then
  WIDTH=1280
  HEIGHT=720
  echo "[info] 紧凑模式 (1280x720) · 适合邮件 / Slack 发送"
else
  WIDTH=1920
  HEIGHT=1080
  echo "[info] 标准模式 (1920x1080) · 加 --compact 启用紧凑模式"
fi

# ======================================================================
# 检查 Node + 创建临时工作目录
# ======================================================================
if ! command -v node >/dev/null 2>&1; then
  echo "[错误] 需要 Node.js · 安装方法 (macOS): brew install node"
  exit 1
fi

TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

# ======================================================================
# 生成临时 Node.js 脚本
# ======================================================================
cat > "$TMPDIR/export.cjs" <<'JS_END'
const { chromium } = require('playwright');
const PptxGenJS = require('pptxgenjs');
const path = require('path');
const fs = require('fs');
const http = require('http');

async function main() {
  const [, , inputHtml, outputPptx, w, h] = process.argv;
  const width = parseInt(w, 10);
  const height = parseInt(h, 10);

  // 用 http 服务器加载 HTML,这样 Google Fonts CDN 和相对路径图片都能工作
  const inputDir = path.dirname(path.resolve(inputHtml));
  const inputName = path.basename(inputHtml);

  const server = http.createServer((req, res) => {
    let filePath = req.url === '/' ? '/' + inputName : decodeURIComponent(req.url);
    filePath = path.join(inputDir, filePath);
    if (!fs.existsSync(filePath)) { res.writeHead(404); res.end(); return; }
    const ext = path.extname(filePath).toLowerCase();
    const mime = {
      '.html': 'text/html', '.css': 'text/css', '.js': 'text/javascript',
      '.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg',
      '.svg': 'image/svg+xml', '.gif': 'image/gif', '.webp': 'image/webp'
    }[ext] || 'application/octet-stream';
    res.writeHead(200, { 'Content-Type': mime });
    res.end(fs.readFileSync(filePath));
  });

  await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
  const port = server.address().port;
  const url = `http://127.0.0.1:${port}/`;

  console.log(`[info] 启动 Chromium ${width}x${height}`);
  const browser = await chromium.launch();
  const context = await browser.newContext({ viewport: { width, height }, deviceScaleFactor: 2 });
  const page = await context.newPage();

  console.log(`[info] 加载 ${url}`);
  await page.goto(url, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);  // 等动画结束

  // 找所有 .slide
  const slideCount = await page.evaluate(() => document.querySelectorAll('.slide').length);
  if (slideCount === 0) {
    console.error('[错误] 没找到 .slide 元素,确认 HTML 是 raoqiu-slide-builder 生成的');
    await browser.close();
    server.close();
    process.exit(1);
  }
  console.log(`[info] 找到 ${slideCount} 张 slide,逐页截图`);

  // 隐藏控件 UI(避免截图带按钮)+ 防止编辑模式干扰
  await page.evaluate(() => {
    document.body.classList.remove('edit-mode');
    document.querySelectorAll('[contenteditable]').forEach(el => {
      el.removeAttribute('contenteditable');
      el.removeAttribute('spellcheck');
    });
    ['.ctrl-bar', '.nav-arrows', '.page-num', '#hint', '#toc-overlay', '#overview', '.progress-bar', '.edit-banner', '.save-toast']
      .forEach((sel) => document.querySelectorAll(sel).forEach((e) => e.style.display = 'none'));
  });

  // 逐页截图
  const screenshots = [];
  for (let i = 0; i < slideCount; i++) {
    // 用 slideshow 实例跳到第 i 页
    await page.evaluate((idx) => {
      if (typeof slideshow !== 'undefined' && slideshow.show) {
        slideshow.show(idx);
      } else {
        // fallback:手动切 .active class
        document.querySelectorAll('.slide').forEach((s, j) => {
          if (j === idx) s.classList.add('active');
          else s.classList.remove('active');
        });
      }
    }, i);
    await page.waitForTimeout(400);  // 等动画
    const png = await page.screenshot({ fullPage: false, type: 'png' });
    screenshots.push(png);
    process.stdout.write(`  截图 ${i + 1}/${slideCount}\r`);
  }
  console.log('\n[info] 截图完成,开始打包 PPTX');

  // 创建 PPTX · 16:9 LAYOUT_WIDE(10" x 5.625")
  const pptx = new PptxGenJS();
  pptx.layout = 'LAYOUT_WIDE';
  pptx.title = path.basename(outputPptx, '.pptx');
  pptx.author = 'Rao-HTML-PPT-Builder v5.4';
  pptx.company = 'raoqiu29-bot';

  for (let i = 0; i < screenshots.length; i++) {
    const slide = pptx.addSlide();
    slide.addImage({
      data: 'data:image/png;base64,' + screenshots[i].toString('base64'),
      x: 0, y: 0, w: '100%', h: '100%'
    });
  }

  await pptx.writeFile({ fileName: outputPptx });
  console.log(`[ok] PPTX 已保存: ${outputPptx}`);

  await browser.close();
  server.close();
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
JS_END

cat > "$TMPDIR/package.json" <<'PKG_END'
{
  "name": "raoqiu-pptx-export",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "playwright": "^1.40.0",
    "pptxgenjs": "^3.12.0"
  }
}
PKG_END

# ======================================================================
# 装依赖(Playwright + PptxGenJS · 只装一次,缓存在 ~/.cache 和当前 tmp)
# ======================================================================
echo "[info] 检查依赖(首次会装 Playwright + PptxGenJS ≈200MB,30-90s)"
cd "$TMPDIR"
npm install --silent --no-audit --no-fund playwright pptxgenjs 2>&1 | tail -3
npx playwright install chromium --with-deps 2>&1 | tail -3

# ======================================================================
# 执行导出
# ======================================================================
node "$TMPDIR/export.cjs" "$INPUT" "$OUTPUT" "$WIDTH" "$HEIGHT"

# ======================================================================
# 自动打开(macOS)
# ======================================================================
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "[info] 自动打开 PPTX(用 Keynote 或 PowerPoint)"
  open "$OUTPUT" || true
fi

# 提示文件大小
SIZE=$(du -h "$OUTPUT" | awk '{print $1}')
echo ""
echo "============================================================"
echo "[完成] 导出 PPTX: $OUTPUT"
echo "       文件大小: $SIZE"
echo ""
echo "【说明】"
echo "  - 这个 .pptx 每页是 ${WIDTH}x${HEIGHT} 高清图片"
echo "  - 客户在 PowerPoint / Keynote 打开,视觉 100% 一致"
echo "  - 但不能改文字(因为每页是图片)"
echo "  - 如需真'可编辑 .pptx'(改文字 / 替换图),等 v5.4-beta(用 dom-to-pptx)"
if [[ "$COMPACT" == "false" ]]; then
  echo "  - 文件太大?加 --compact 参数,大约能压缩到 30-50%"
fi
echo "============================================================"
