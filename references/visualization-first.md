# 可视化优先工作流(v5.11 新增 · 饶秋实战反馈)

> **饶秋 2026-05-19 锦江课件实战诊断**:
> > "整个看起来文字太多了,讲解的时候很难让别人抓住重点。"
>
> **数据**:锦江课件 44 张片,**42 张是全文字页**(0 视觉元素),全 deck 总共只有 4 个视觉元素。
>
> **根因**:skill v5.5 起已有 SVG Dashboard 版式库(12 个组件)+ 24 个 SVG icon,**但 AI 生成时默认走"文字 + 卡片"路线,根本没用上**。

---

## 核心原则

**先想视觉,再想文字** — 跟之前"先想内容,再选版式"是反的。

| 老流程(v5.10 及之前)| 新流程(v5.11 起) |
|---|---|
| 1. 写大纲 → 2. 选版式 → 3. 填文字 → 4. 偶尔配图 | **1. 写大纲 → 2. 标识"哪些数据/对比/趋势"→ 3. 强制可视化 → 4. 文字降到辅助** |

---

## 强制可视化触发条件(满足任一即必须用图)

### 🚨 P0 红线 · 出现以下情况必须用图,不许用文字 list

| 触发信号 | 必须用的版式 | 不许用 |
|---|---|---|
| 内容有 **≥ 2 个数据对比**(前 vs 后 / 老 vs 新 / 传统 vs 现在)| **`.metric-row` 大数字 + SVG 横条对比** | ❌ split 两栏文字 |
| 内容有 **百分比 / 比率 / 转化率**(60% / 92% / 3.2×)| **`.big-number` 整页大字** 或 **donut/gauge** | ❌ 段落里嵌数字 |
| 内容有 **时间序列**(月度变化 / 季度趋势 / 周环比)| **SVG line/area chart 趋势线** | ❌ 表格 / 文字描述 |
| 内容有 **流程步骤 ≥ 3 步** | **`.process-flow` 横向时间线**(N 步 = N 节点)| ❌ 编号 list |
| 内容有 **2 维度分类**(高频/低频 × 强/弱 之类) | **`.matrix-2x2` 战略矩阵** | ❌ 4 段文字 |
| 内容有 **≥ 3 个并列要点 + 每个都带数据** | **`.card-grid` 卡片 + 每卡 metric 大数字** | ❌ 纯 card.h3+p |
| 内容是 **"5 个翻车 / 5 个原因 / 5 个步骤"** | **process-flow 5 节点** 或 **5 张连续 insight-page** | ❌ 一张片塞 5 项 list |

### 🟡 P1 · 出现以下情况强烈推荐用图

| 信号 | 推荐版式 |
|---|---|
| 单纯讲一个核心概念 / 定义 | `.big-quote` 整页大字(衬线)|
| 单个超震撼数据(60% / 80+) | `.big-number` 整页大字 + source |
| 工具 / 角色 4-6 个并列(每个有图标 + 短描述)| `.card-grid cols-3` + 每卡 SVG icon |
| 关键洞察 + 数据支撑 | `.insight-page` + 红色 tag + insight-meta |

### ✅ P2 · 可以用文字的极少数场景

| 场景 | 用什么 |
|---|---|
| 代码 / 提示词 / 命令 | `.prompt-block` 等宽字体 |
| 任务卡(动手时间 + 验收标准)| `.task-card` |
| 章节扉页(只有 1 个标题 + 1 句副标)| `.chapter` |
| 收尾页(讲师签名)| `.ending` |

**其他场景都应该先考虑可视化**,文字是兜底,不是首选。

---

## 文字 → 视觉化的 10 个常见转换模式

### 模式 1 · 文字 list 4 项 → process-flow 4 节点

**反例(锦江原 v0.3 场景 1)**:
```html
<ol class="list-clean">
  <li>翻去年的方案,复制一份</li>
  <li>改改改 — 主题、人数、时间、节目</li>
  <li>挠头想新节目创意</li>
  <li>2 小时改完 → 还是去年的味儿</li>
</ol>
```

**正例**:
```html
<div class="process-flow" style="--steps:4;">
  <div class="step"><div class="dot">1</div><h4>翻去年方案</h4><p>拷一份</p></div>
  <div class="step"><div class="dot">2</div><h4>改主题人数</h4><p>逐项改</p></div>
  <div class="step"><div class="dot">3</div><h4>挠头创意</h4><p>无新意</p></div>
  <div class="step"><div class="dot">4</div><h4>2 小时去年味</h4><p>白干</p></div>
</div>
```

字数减 70%,视觉冲击 ×5。

### 模式 2 · "2 小时变 10 分钟" → metric-row + SVG 横条

**反例**:`<p>用 AI 之前要 2 小时,用 AI 之后 10 分钟,效率提升 12 倍。</p>`

**正例**:
```html
<div class="metric-row">
  <div class="metric"><div class="v" style="color:var(--c-warm);">2<span class="unit"> 小时</span></div><div class="l">传统</div></div>
  <div class="metric"><div class="v" style="color:#16A34A;">10<span class="unit"> 分钟</span></div><div class="l">用 AI</div></div>
  <div class="metric"><div class="v">12<span class="unit">×</span></div><div class="l">效率提升</div></div>
</div>
<!-- SVG 横条对比(传统满条 vs AI 短条)= 直观看到 12 倍长度差 -->
<svg width="100%" height="22"><rect width="600" height="22" fill="var(--c-warm)"/></svg>
<svg width="100%" height="22"><rect width="50" height="22" fill="#16A34A"/></svg>
```

### 模式 3 · "AI 能干 5 件事" 列表 → card-grid + icon + metric

**反例**:`<ol><li>写文字</li><li>拉表格</li>... 5 个 li</ol>`

**正例**:5 张 mini card 各带 SVG icon(file-text / table / audio / presentation / search,从 `references/icons.md` 选),每卡顶部 mono 标签 "AI 01-05"。

### 模式 4 · "5 个翻车" → 5 张连续片(每张一个翻车 + 大数字)

**反例**:一张片塞 5 个翻车 → 字太密。

**正例**:5 张 `process-flow` 三节点片(现象 → 原因 → 应对)+ 每张片一个核心数字(比如"翻车 4 · 一次生太长 · 后半段崩"→ ≤5 秒 / 4×5 秒 / 10+秒 三个 metric)。

### 模式 5 · "AI 工作 5 件事 / 生活 7 件事" → 双 dashboard hero

**反例**(锦江"工作 5 件事" 371 字符):两张片 + 12 张文字卡片。

**正例**:
- 第 1 张:Big Number "5 件事" + 5 个 sparkline(每个对应一件事的时间节省曲线)+ 1 行 takeaway
- 第 2 张:同模式,7 件事 = 7 个 sparkline

### 模式 6 · "工具地图四件套" → 2x2 矩阵(频次 × 重要性)

**反例**:4 张 card 文字描述 4 个工具。

**正例**:`.matrix-2x2` — 横轴"使用频次"纵轴"不可替代性",4 个工具落到 4 个象限,带颜色 + tag。

### 模式 7 · "今天讲完你能做的三件事" → 3 个 metric + 3 个 SVG icon

不要 `<li>` 三项文字,要 3 个超大数字 + icon + 一句话。

### 模式 8 · 章节扉页的"3 章节内容预告" → 不要 ch-meta 3 项文字,改成 3 个 thumbnail-style mini box

### 模式 9 · "AI 给的第一稿不满意 · 3 个层次" → process-flow 3 节点 + 每节点 prompt-block 短代码

不要文字描述"什么是方向层、什么是局部层、什么是细节层",**直接展示 3 段示范提示词代码**(prompt-block × 3 横排)。

### 模式 10 · 数据 dashboard 范例(综合)

任何"业绩复盘 / 学员反馈 / 月度数据"页 → 不要 paragraph,**直接给完整 dashboard**:顶部 4 个 metric card + 中部 1 个 donut + 1 个 line chart + 底部 hover-row 表格。版式见 `references/layouts.md` "13. 数据 Dashboard 版式"。

---

## 写每页前必问的 3 个问题(v5.11 强制)

写每张 slide 之前,**先在心里(或对话里)回答**:

```
Q1. 这页有没有数字 / 对比 / 趋势 / 流程?
    ─ 有 → 强制走可视化,不许写文字 list
    ─ 没有 → 进 Q2

Q2. 这页有没有 ≥ 3 个并列要点?
    ─ 有 → 用 card-grid + icon + 每卡数字,不用纯文字
    ─ 没有 → 进 Q3

Q3. 这页是不是"单个核心观点"?
    ─ 是 → 用 big-quote 或 insight-page(衬线大字)
    ─ 否 → 才允许用 split 文字对比 / list-clean
```

**默认假设:用户给的内容**不是**纯叙述,一定有数据/对比/流程藏在里面 — AI 要主动挖出来,而不是直接抄成文字 list。**

---

## 跟"信息密度铁律"的关系

旧版铁律(v5.5):**"塞不下不是字小了,是观点多了。"**

新版补充(v5.11):**"字多不是字号问题,是没把数据挖出来。"**

`.page-body` 超 350 字符 → 一定能拆成 2-3 个视觉模块。**字数应该是 last resort**。

---

## visualize-audit 工具(v5.11 新增)

跑 `bash scripts/visualize-audit.sh <file.html>` 一键扫:
- 每张片的字符数 / 视觉元素数(SVG + img + metric)
- 文字 / 视觉比例
- 全 deck 视觉化健康指数

输出报告标识"哪些页文字最多 / 哪些页 0 视觉元素",优先改造这些。

---

## 历史实战案例

| 日期 | 课件 | 改造前 | 改造后 |
|---|---|---|---|
| 2026-05-19 | 锦江"场景 1 · 痛点+提示词" | 598 字符 + 0 SVG | 240 字符 + 3 SVG + 3 metric(参见桌面 `可视化改造示范-场景1-2026-05-19.html`)|

每做完一个可视化改造案例,加进这张表。

---

## 给 AI 的强约束(写进 SKILL.md Step 1.7)

> **节奏规划阶段,每张片必须 defend choice**:
> - 这页内容是什么?
> - **第一选项**:能不能用图/数字/流程表达?(查上面"模式 1-10")
> - **第二选项**:不能,那能不能用 card-grid + icon + 数字?
> - **第三选项**:实在不行,才考虑 split 文字 / list-clean
>
> **AI 不可以默认走 split / list-clean,必须先排除前两个选项。**
