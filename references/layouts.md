# 12 种版式索引

每种版式记录:用途、密度规则(关键!)、template.html 中的位置、注意事项。

**核心方法:不要从零写版式 HTML,在 template.html 里找到对应的 section,复制后改文字内容即可。**

**版式分类**(动手前先想清楚每页属于哪一类):

| 类别 | 版式 | 节奏作用 | **HTML 结构** ⚠️ |
|---|---|---|---|
| **开场 / 收束** | 1 封面 / 10 结尾 | 框架 | `<section>` 直接放 `<div class="cover\|ending">` |
| **重音页**(强冲击) | 2 章节扉页 / 7 Key Insight / **11 Big Number** / **12 Big Quote** | hero — 制造节奏重音 | `<section>` 直接放 `<div class="chapter\|insight-page\|big-number\|big-quote">`(**不要用 .page 包装!**) |
| **信息处理页** | 3 卡片网格 / 4 metric+split / 8 流程时间线 / 9 2x2 矩阵 | 弱拍 — 信息组织 | `<section>` → `<div class="page">` → 内部用 page-meta / page-title / page-body(**必须 .page 包装,不要写 page-footer**) |
| **操作类页** | 5 提示词代码块 / 6 学员任务卡 | 实操指引 | 同信息处理页:`<section>` → `<div class="page">` |

### 信息处理页的标准结构(漏一个就崩)

```html
<section class="slide" data-module="模块名" data-name="页面名">
  <div class="page">                                    ← P0 漏掉就贴边贴顶
    <div class="page-meta">                             ← 顶部 chrome(模块标签 + 页码)
      <span class="module">模块 X · 子主题</span>
      <span>XX / 10</span>
    </div>
    <h2 class="page-title">标题(用 h2,不要用 div)</h2>
    <p class="page-subtitle">副标题(用 p,不要用 div)</p>
    <div class="page-body">                             ← 主内容区(自动垂直居中)
      <!-- 卡片网格 / metric-row / pipeline / matrix 等 -->
    </div>
  </div>
</section>
```

**为什么 `.page` 不能漏**:`.page` 类是 `padding: 3.5rem 5rem 2rem` + `flex column` + 让 `.page-body` 自动 flex:1 撑开。少了它,所有内容都贴 viewport 边,标题贴顶、卡片堆底、左右零留白 —— 视觉立刻崩。Hero 版式不用 `.page` 是因为它们各自定义了 `padding`(例如 `.big-number` / `.cover` / `.chapter` 都内置了大 padding)。

**子标题用 `<p class="page-subtitle">` 不是 `<div>`**:模板的 CSS 是 `p.page-subtitle` 选择器(虽然 CSS 没强制,但保持语义)。同理 `h2.page-title` 用 h2 不用 div。

### ⚠️ 不要写 `.page-footer`(v4 弃用 · 2026-05 真实踩坑)

**现象**:写了 `<div class="page-footer">` 之后,底部"饶秋 · XX"被左下角翻页按钮 `<` `>` 遮挡,"MODULE X · XX"被右下角页码 `XX / 10` 遮挡。全屏也挡。

**根因**:模板 UI 的 `.nav-arrows` 固定在 `bottom:1rem; left:1.5rem`,`.page-num` 固定在 `bottom:1rem; right:1.5rem` — page-footer 在 `.page` 的 padding-bottom 内,跟它们硬撞。

**做法**:**信息页只用顶部 page-meta,不要写 page-footer**。template.html 的 `.page-footer` CSS 已加 `display:none !important`,即使误写也不会显示。品牌/模块/页码信息全部交给:
- 顶部 `.page-meta`(信息页内嵌)
- 右下角 `.page-num`(模板自动生成,跟随当前 slide)
- 大纲面板(按 M 触发,显示所有页面名)

---

## 1. 封面 `.cover`

**用途**:课程开场,PPT 第一页

**密度规则**:每个 PPT **1 张**

**位置**:template.html 第 1 页(搜索 `data-name="课程封面"`)

**填什么**:
- `eyebrow`:小写英文标识(如 "AIGC TRAINING · CLIENT NAME · 2026")
- `h1`:课程主标题,可以两行,**禁止超过 12 字一行**
- `lead`:副标题,**30 字以内**,讲清楚课程定位
- `meta-grid` 三列:主讲 / 课程时长 / 对象,固定结构

**注意**:封面 h1 的左上方有一个 3rem 宽的横线作为视觉锚点(`::before`),不要删

---

## 2. 章节扉页 `.chapter`

**用途**:模块切换,深蓝整页 + 白色巨大数字

**密度规则**:每个 PPT **不超过 5 张**(对应 5 个模块,多了就是模块设计有问题)

**位置**:template.html 第 3、9 页(搜索 `data-module="模块一"` 和 `data-module="模块二"` 的 chapter 页)

**填什么**:
- `deco-num`:超大铅字数字(01 / 02 / 03 ...)
- `ch-label`:Chapter One · 第一章
- `h1`:章节标题,**禁止超过 8 字**
- `desc`:副标题描述
- `ch-meta`:三个数据(几步方法 / 几分钟 / 几案例)

**注意**:章节扉页是整个 PPT 唯一用深蓝整页的版式,作为视觉节奏的"重音"。不要在其他页面用深蓝底。

---

## 3. 卡片网格内容页 `.card-grid`

**用途**:罗列要点、对比维度、列功能

**密度规则**(必须严格遵守,这是字号偏小的根源):

| 类型 | 容量上限 | 超量怎么办 |
|---|---|---|
| `.card-grid.cols-2` 标准卡 | **4 张**(2×2) | 拆成两页 |
| `.card-grid.cols-3` mini 卡 | **6 张**(3×2) | 拆成两页,绝不挤 8 张 |
| `.card-grid.cols-4` mini 卡 | **4 张**(1 行) | 不允许做 2 行 |

**位置**:
- 标准卡 cols-2:template.html 第 2 页
- mini 卡 cols-3:template.html 第 10 页(豆包六件套)

**卡片变体**:
- `.card.bordered-top`:顶部 3px 主色边(默认推荐)
- `.card.bordered-left`:左边 3px 主色边
- `.card.dark`:深蓝底白字(对比强烈,慎用,一页最多 3 张)
- `.card.warm-mark`:左边 3px 警示红边(标记"关键""客户色位置")
- `.card.mini`:紧凑版,padding 小一档,字号小一档

**卡片内必填**:
- `.card-num`:01 · 类别 / 02 · 类别 ...
- `h3`:**8 字以内**的小标题
- `p`:**30 字以内**的描述,**1-2 行**

---

## 4. 数据 + 对比 `.metric-row` + `.split`

**用途**:左右双栏对比 + 大数字 metric 展示

**密度规则**:
- `.metric-row` 每页 **不超过 3 个数字**
- `.split` 必须左右两栏,不要三栏

**位置**:template.html 第 4 页(搜索 `data-name="为什么需要 TRAIN"`)

**填什么**:
- `.metric .v`:大号数字(可以加 `<span class="unit">%</span>` 或 `×` 等单位)
- `.metric .l`:数字下方的小标签(mono 字体)
- `.split` 两栏:左边"现状/问题",右边"对策/答案"(用 `.col.brand` 让右栏标题用主色)

---

## 5. 提示词代码块 `.prompt-block`

**用途**:展示提示词模板,是饶秋老师课程的高频版式

**密度规则**:每页 **1 个 prompt-block**(超过就拆页)

**位置**:template.html 第 6 页(搜索 `data-name="提示词模板 · TRAIN"`)

**填什么**:
- `.prompt-tag`:`PROMPT · TPL XX` 红色矩形标签
- 提示词正文:用等宽字体显示,行内可以混排
- `.ph` 类标记的占位符:`[xxx]`,显示为棕赭色高亮
- `.prompt-meta`:底部元数据(适用场景 / 预计耗时)

**注意**:占位符 `<span class="ph">[内容]</span>` 是关键交互——告诉用户哪些地方需要替换

---

## 6. 学员任务卡 `.task-card`

**用途**:实操任务说明,左右双栏

**密度规则**:每页 **1 个 task-card**

**位置**:template.html 第 7 页(搜索 `data-name="实操任务 · 任务1"`)

**填什么**:
- 左栏:任务编号(大号数字) + 任务名 + 任务背景 + 你的任务(数字编号 list)
- 右栏:验收标准(数字编号 list) + 配套资料 + 倒计时(大号红色数字,如 `10:00`)

**注意**:这是双栏布局,内容必须左右匹配,不要左多右少或反之

---

## 7. Key Insight 关键洞察 `.insight-page`

**用途**:核心论点 + 数据支撑 + 来源(替代金句页)

**密度规则**:每个 PPT **不超过 3 张**(用太多就失去强调感,价值递减)

**位置**:template.html 第 8 页(搜索 `data-name="关键洞察"`)

**填什么**:
- `.insight-tag`:KEY INSIGHT · 关键洞察(红色标签 + 横线)
- `.insight-body`:核心论点(2.25rem 大字 + 左侧 3px 主色竖边)
- `.insight-meta`:三个量化指标(每个 item 有 mono 标签 + brand 大字)
- `.insight-source`:数据来源脚注(SOURCE / xxx)

**注意**:这是麦肯锡式的"洞察标注",必须有数据 + 来源,不能只是金句

---

## 8. 流程时间线 `.process-flow`

**用途**:横向 N 步流程,5 步最佳

**密度规则**:每页 1 个流程图,**最多 5-6 步**(7+ 步必须拆成两个流程图)

**位置**:template.html 第 5 页(搜索 `data-name="TRAIN 五步流程图"`)

**填什么**:
- 容器加 `style="--steps: 5"` 控制列数
- 每个 `.step` 包含:`step-num` + `dot`(可加 `.active` 表示当前) + `h4` + `p`
- 第一步常加 `.active` 表示"起点",其他空心

**注意**:流程图横线由 CSS 自动生成(`::before`),不需要手写

---

## 9. 2x2 战略矩阵 `.matrix-2x2`

**用途**:四象限战略图,SWOT,优先级判断

**密度规则**:每页 **1 个矩阵**

**位置**:template.html 第 11 页(搜索 `data-name="AI 应用战略矩阵"`)

**填什么**:
- `.y-axis`:左边坐标轴(高/低 + 标签 + 高/低)
- `.x-axis`:底部坐标轴(低/高 + 标签 + 低/高)
- 4 个 `.quadrant`:
  - 通常右上是"重点象限",加 `.highlight` 类
  - 每个象限:`.q-tag`(象限编号 + 行动建议) + `h4`(象限名) + `p`(描述)

**注意**:矩阵的高度需要至少占 page-body 的 80%,内容少了会显得空——要确保 4 个象限都填实

---

## 11. Big Number 整页大数字 `.big-number`(本次新增)

**用途**:把一个核心数字放大到整页 — 比 metric-row 更强的视觉冲击,适合开场/章末/Key Insight 收束。

**密度规则**:每个 PPT **不超过 3 张**(过多会失去震撼感)

**位置**:template.html(搜索 `data-name="Big Number 范例"`)

**填什么**:
- `.kicker`:小标题(mono 字体,如 `THE GAP · 真实差距`)
- `.v.serif-quote`:**整页大数字**,可加衬线(20-30vw 字号),例 `60%`、`70万`、`105`
- `.lead`:数字下方一句话注解,30 字内,无衬线
- `.source`:数据来源(SOURCE / xxx)

**衬线规则**:
- `.v` 数字本身可以加 `.serif-quote` 类(用 Source Han Serif SC + Playfair Display)— 增强权威感
- `.lead` 注解必须无衬线 — 信息处理

**示例**:
```html
<section class="slide big-number light">
  <span class="kicker">THE GAP · 真实差距</span>
  <div class="v serif-quote">60%</div>
  <p class="lead">员工每周用 AI 不到 1 次,管理层以为是 80%。</p>
  <span class="source">SOURCE / 某客户内部调研 2026.03</span>
</section>
```

**注意**:
- 数字字号 20-30vw,**单数字最多 4 字符**(包括百分号),超过用 lead 句拆解
- 数字旁不要堆其他数字,这一页就讲一个数
- 与 `.metric-row`(每页 3 个数字小字号)互补:metric-row 处理"对比",Big Number 处理"震撼"

---

## 12. Big Quote 整页大引用 `.big-quote`(本次新增)

**用途**:用一句话承担整页 — 适合关键金句、章节收束、Takeaway 页。**比 Key Insight 更"轻"**(Key Insight 必带数据来源,Big Quote 是纯主张)。

**密度规则**:每个 PPT **不超过 2 张**(过多会显得"文学化",失去咨询风的克制)

**位置**:template.html(搜索 `data-name="Big Quote 范例"`)

**填什么**:
- `.kicker`:小标题(可选,mono 字体)
- `.quote.serif-quote`:**整页大引用**,衬线字体(8-12vw 字号),用手工 `<br>` 控制断行
- `.attribution`:出处 / 署名(— 饶秋 · 2026 / SOURCE)
- 可选 `.aside`:小注解一段(无衬线,正文字号)

**衬线规则**:
- `.quote` **必须** 加 `.serif-quote` 类 — 这是 Big Quote 的标志
- `.attribution` 用 mono 字体,无衬线
- `.aside` 注解无衬线

**示例**:
```html
<section class="slide big-quote light">
  <span class="kicker">TAKEAWAY · 我的判断</span>
  <blockquote class="quote serif-quote">
    AI 不会取代你,<br>
    但用 AI 的人会。
  </blockquote>
  <span class="attribution">— 饶秋 · AIGC 培训交付现场</span>
</section>
```

**注意**:
- 中文引用 ≤ 16 字(两行),英文 ≤ 12 词
- 引用本身就是结论,不要再加"小标题翻译"
- 衬线和引文是这一版式的灵魂 — 但**整份 deck 最多 2 张**,过多就漂

---

## 10. 结尾页 `.ending`

**用途**:致谢 + 联系方式 + 课程编号

**密度规则**:每个 PPT **1 张**

**位置**:template.html 最后一页(搜索 `data-name="结尾致谢"`)

**填什么**:
- `eyebrow`:`从今天开始 · Continue From Today`(可改文字但保留两段式结构)
- `h1`:号召 / 总结金句(主标题)
- `lead`:补充行动指引(50 字内)
- `signature`:三栏(主讲 / 联系方式 / 课程编号)

---

## 版式选择决策树

```
要做什么?
├── 开场 / 结束 → 封面 / 结尾(版式 1, 10)
├── 模块切换 → 章节扉页(版式 2)
├── 罗列内容
│   ├── ≤4 项 → cols-2 标准卡(版式 3)
│   ├── ≤6 项 → cols-3 mini 卡(版式 3)
│   └── 7+ 项 → 拆页 / 改用流程图
├── 数据强调
│   ├── 多个数字对比(2-3 个) → metric + split(版式 4)
│   └── 单个数字震撼 → Big Number(版式 11) ★ 本次新增
├── 流程步骤 → 流程时间线(版式 8)
├── 四象限 → 2x2 矩阵(版式 9)
├── 关键观点
│   ├── 带数据 + 来源 → Key Insight(版式 7)
│   └── 纯主张 / 金句 / Takeaway → Big Quote(版式 12) ★ 本次新增
├── 操作类内容
│   ├── 提示词 → prompt-block(版式 5)
│   └── 学员任务 → task-card(版式 6)
└── 不在以上 → 拆解需求,99% 能匹配上面某个版式
```

## "重音页"用量上限(节奏铁律)

整份 deck 重音页(版式 2 / 7 / 11 / 12)的总用量必须节制,否则节奏会"全是高潮 = 没有高潮":

| 版式 | 上限 | 超量信号 |
|---|---|---|
| 章节扉页(版式 2) | ≤ 5 张 | 模块切太细,回去看大纲 |
| Key Insight(版式 7) | ≤ 3 张 | 强调价值递减,挑最重要的 3 个 |
| Big Number(版式 11) | ≤ 3 张 | 数字太多反而平淡,挑最震撼的 |
| Big Quote(版式 12) | ≤ 2 张 | 引用太多变文学化,失去咨询气质 |

**总和上限**:整份 deck 重音页(2+7+11+12)合计 **≤ 13 张**,且**至少有同等数量的信息处理页(3/4/5/6/8/9)**作为"弱拍"。

如果你做了 25 页 deck,重音页 13 张,弱拍 12 张 — 节奏就是"重 / 弱 / 重 / 弱"近乎对半。这是上限,不是目标。**目标是重音 ≤ 1/3,弱拍 ≥ 2/3**。

## 信息密度铁律

> **一页一观点。塞不下不是字小了,是观点多了。**

这是饶秋老师课程理念"标题即结论"的体现,也是真正麦肯锡风格的底层逻辑。

字号偏小的问题 99% 不是 CSS 问题,是版式选择和内容密度问题。先看密度规则,再考虑改 CSS。

---

# 培训片大纲模板(v5.5 新增 · 借鉴 code-on-sunday/slide-deck-generator)

**用在 Mode B(把大纲转 PPT)和 Mode A(从零做培训片)。**

这是真正成熟的成人学习节奏,适合 1-4 小时的培训交付场景。客户提案 / 自媒体讲解不强制按这个,但培训片应该按这个排。

## 五段循环(Learning Cycle)

每一个"知识点"都按这五段走:

```
Problem  →  Discussion  →  Concept  →  Example  →  Takeaway
触发好奇    引导思考       讲清概念    真实例子     强化记忆
1 张片     0-1 张片      3-6 张片    1-2 张片    1 张片
```

| 段 | 目的 | 张数 | 版式建议 |
|---|---|---|---|
| **Problem** | 触发好奇 + 相关性 | 1 | Big Quote(把问题写成大字)或 Cover-like 全屏标题 |
| **Discussion** | 让学员动脑(可选) | 0-1 | Big Quote 风的开放问题,2-3 行字 |
| **Concept** | 讲清框架 | **3-6** | 章节扉页 + 卡片网格 / 流程时间线 / 2x2 矩阵 |
| **Example** | 真实场景 | 1-2 | metric+split 或带截图的卡片 |
| **Takeaway** | 强化记忆 | 1 | Key Insight 或 Big Number |

**核心规则**:`1 idea = 1 slide`。Concept 段如果有 5 个原因,**写 5 张片**(每张 Cause #1 / #2 / ...),不要塞一张片上。

## 整份培训片的 Module 结构

```
Introduction(开场)        5-10 张
Module 1                   25-40 张
  ├─ Cycle 1               5-10 张
  ├─ Cycle 2               5-10 张
  ├─ Cycle 3               5-10 张
  └─ Cycle 4               5-10 张
Module 2                   25-40 张
Module 3                   25-40 张
Wrap-up(收束)             5-10 张
```

## 时长 → 张数对照表

| 培训时长 | 总张数 | Module 数 | 备注 |
|---|---|---|---|
| 30 分钟分享 | 15-25 | 1 | 单 Module,Cycle ≤ 3 |
| 1 小时讲座 | 30-50 | 1-2 | |
| 2 小时工作坊 | 60-90 | 2-3 | |
| **半天 (4 小时) 培训** | **100-140** | **3-4** | 饶秋老师 AI 培训典型节奏 |
| 全天 (7 小时) 培训 | 180-240 | 5-6 | 中间留休息和实操 |

**计算口径**:培训现场约 **每张片讲 1.5-2 分钟**(包含 Q&A 缓冲)。4 小时 = 240 分钟,扣掉 20% 实操和休息 ≈ 192 分钟讲解 ÷ 1.5 = 128 张,落在 100-140 范围内。

## 视觉比例建议(培训片专用)

| 类型 | 占比 | 怎么算 |
|---|---|---|
| **视觉为主**(图 / 卡 / 流程) | 60-70% | 卡片网格 + metric+split + 流程时间线 + 矩阵 + Big Number / Quote |
| **图表为主**(数据可视化) | 10-15% | 见下方 SVG 图表章节 |
| **文字解释**(短列表) | 15-20% | 章节扉页 + Key Insight + 任务卡 |

**如果文字片 > 30%,就是讲义不是培训片**。重新审视,把能拆成图的拆掉。

## Mode B 工作流(把客户给的大纲转成培训片)

1. **先看大纲属于什么时长** → 查对照表确定总张数和 Module 数
2. **把大纲切成 Module** → 每个 Module 25-40 张
3. **每个 Module 切成 Cycle** → 每个 Cycle 5-10 张
4. **每个 Cycle 走五段** → Problem / Discussion / Concept × N / Example / Takeaway
5. **逐张选版式** → 按"视觉比例"建议,先排版式,再填内容
6. **跑 Ghost Deck Test** → 只读标题串能读出培训逻辑

---

# 数据 Dashboard 版式(v5.5 新增 · 借鉴 robonuggets/marp-slides)

> **饶秋老师说"我们之前文字太单一了"——这一节就是补这个洞。**

**用在哪**:培训片的数据对比 / 客户提案的业绩页 / 莱美的业绩 ROI 页 / 麦肯锡风的数据 dashboard 报告页。

**核心原则**:这些组件是**信息处理页**的内容,必须包在 `<div class="page">` 里(参见本文件顶部"信息处理页的标准结构")。

## 颜色定义(放在模板顶部 `:root`)

```css
:root {
  /* 复用既有麦肯锡风变量 */
  --c-brand: #051C2C;     /* 主色 */
  --c-warm:  #E53935;     /* 警示 / 客户色 */

  /* 新增 dashboard 语义色 */
  --c-up:    #16A34A;     /* 上升 / 正向 */
  --c-down:  #DC2626;     /* 下降 / 负向 */
  --c-flat:  #6B7280;     /* 持平 */
  --c-warn:  #F59E0B;     /* 注意 */

  /* SVG 图表线条 */
  --chart-grid:  #E5E7EB; /* 网格线 */
  --chart-axis:  #9CA3AF; /* 坐标轴 */
}
```

## 13.1 Metric Card · 单数字卡片(配顶部色边)

**用途**:KPI 仪表板顶部那一排数字(收入 / 转化 / ROAS / 留存率)。

```html
<div class="metric-card">
  <div class="metric-card__topbar"></div>
  <div class="metric-card__label">
    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
      <path d="M12 2v20M17 5H9.5a3.5 3.5 0 1 0 0 7h5a3.5 3.5 0 1 1 0 7H6"/>
    </svg>
    营收
  </div>
  <div class="metric-card__value">¥41,946</div>
  <div class="metric-card__trend metric-card__trend--up">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <polyline points="18 15 12 9 6 15"/>
    </svg>
    +49.3% vs 上月
  </div>
</div>
```

```css
.metric-card {
  position: relative;
  overflow: hidden;
  background: #FBFBFD;
  border: 1px solid var(--c-line);
  border-radius: 10px;
  padding: 1.2rem 1.4rem;
}
.metric-card__topbar {
  position: absolute;
  top: 0; left: 0;
  width: 100%; height: 2px;
  background: linear-gradient(90deg, var(--c-brand), transparent);
}
.metric-card__label {
  display: flex; align-items: center; gap: 0.4rem;
  font-size: 0.75rem; font-weight: 600;
  color: var(--c-ink-3);
  letter-spacing: 0.08em; text-transform: uppercase;
  margin-bottom: 0.5rem;
}
.metric-card__label .icon { width: 14px; height: 14px; }
.metric-card__value {
  font-family: 'Fraunces', 'Noto Serif SC', serif;
  font-size: 2.2rem; font-weight: 600;
  color: var(--c-brand);
  line-height: 1;
}
.metric-card__trend {
  margin-top: 0.5rem;
  font-size: 0.8rem;
  display: flex; align-items: center; gap: 0.25rem;
}
.metric-card__trend--up { color: var(--c-up); }
.metric-card__trend--down { color: var(--c-down); }
.metric-card__trend--flat { color: var(--c-flat); }
.metric-card__trend svg { width: 10px; height: 10px; }
```

**密度上限**:一行 4 张为上限,3 张为推荐。

## 13.2 Donut Ring · 单环占比

**用途**:转化率 / 完成率 / 单一占比指标(89% 学员通过 / 76% 任务完成)。

```html
<div class="donut">
  <svg viewBox="0 0 200 200" width="160" height="160">
    <!-- 底环 -->
    <circle cx="100" cy="100" r="74" fill="none" stroke="#E5E7EB" stroke-width="18"/>
    <!-- 数据环(89%,顺时针从顶部开始)-->
    <circle cx="100" cy="100" r="74" fill="none"
            stroke="#051C2C" stroke-width="18"
            stroke-dasharray="465" stroke-dashoffset="51"
            stroke-linecap="round"
            transform="rotate(-90 100 100)"/>
    <!-- 中间数字 -->
    <text x="100" y="105" text-anchor="middle"
          font-family="Fraunces, serif" font-size="36" font-weight="600" fill="#051C2C">89%</text>
    <text x="100" y="130" text-anchor="middle"
          font-family="Manrope, sans-serif" font-size="11" fill="#5C6772">学员通过</text>
  </svg>
</div>
```

**数学公式(必背)**:
```
circumference = 2 * π * r
r = 74  →  circumference ≈ 465
当显示 X%  →  dashoffset = 465 - (465 × X / 100)
   89%  →  dashoffset = 465 - 414 = 51
   76%  →  dashoffset = 465 - 353 = 112
   50%  →  dashoffset = 465 - 232 = 233
```

## 13.3 Pie / Multi-Segment Donut · 多段饼图

**用途**:渠道占比 / 角色分布 / 类型构成。

```html
<svg viewBox="0 0 200 200" width="180" height="180">
  <!-- 段 1: 50% 主色,offset=0 -->
  <circle cx="100" cy="100" r="74" fill="none"
          stroke="#051C2C" stroke-width="50"
          stroke-dasharray="232 465" stroke-dashoffset="0"
          transform="rotate(-90 100 100)"/>
  <!-- 段 2: 30%,offset=-232 -->
  <circle cx="100" cy="100" r="74" fill="none"
          stroke="#2251FF" stroke-width="50"
          stroke-dasharray="139 465" stroke-dashoffset="-232"
          transform="rotate(-90 100 100)"/>
  <!-- 段 3: 20%,offset=-(232+139)=-371 -->
  <circle cx="100" cy="100" r="74" fill="none"
          stroke="#E53935" stroke-width="50"
          stroke-dasharray="93 465" stroke-dashoffset="-371"
          transform="rotate(-90 100 100)"/>
</svg>
```

**算段长**:`段长 = (该段百分比 / 100) × circumference`。`stroke-dasharray="段长 总长"` 让每段只画自己那一截。`stroke-dashoffset` 累计前面所有段的负值,把当前段推到正确起点。

## 13.4 Sparkline · 内联迷你折线

**用途**:数字旁边的小趋势线,占地极小(50×16)。

```html
<span class="sparkline">
  <svg width="50" height="16" viewBox="0 0 50 16">
    <polyline points="0,14 8,12 16,10 24,8 32,11 40,6 50,2"
              fill="none" stroke="#16A34A" stroke-width="1.2"
              stroke-linecap="round" stroke-linejoin="round"/>
  </svg>
</span>
```

**坐标技巧**:`x` 轴均匀分布,`y` 轴 `0=顶/14=底`(SVG y 轴向下)。数值高 → y 小。

## 13.5 Stacked Bar · 横向堆叠条

**用途**:进度构成 / 时间投入分布 / 多类占比对比。

```html
<div class="stacked-bar">
  <div style="flex: 50; background: #051C2C;"  title="麦肯锡风 50%"></div>
  <div style="flex: 30; background: #2251FF;"  title="客户主题 30%"></div>
  <div style="flex: 20; background: #E53935;"  title="实操 20%"></div>
</div>
<div class="stacked-bar__legend">
  <span><i style="background:#051C2C"></i>麦肯锡风 50%</span>
  <span><i style="background:#2251FF"></i>客户主题 30%</span>
  <span><i style="background:#E53935"></i>实操 20%</span>
</div>
```

```css
.stacked-bar {
  display: flex;
  height: 14px;
  border-radius: 7px;
  overflow: hidden;
  background: #F3F4F6;
}
.stacked-bar > div { transition: opacity 0.2s; }
.stacked-bar > div:hover { opacity: 0.85; }

.stacked-bar__legend {
  display: flex; gap: 1rem;
  margin-top: 0.6rem;
  font-size: 0.75rem; color: var(--c-ink-3);
}
.stacked-bar__legend i {
  display: inline-block;
  width: 8px; height: 8px;
  border-radius: 2px;
  margin-right: 0.3rem;
  vertical-align: middle;
}
```

## 13.6 Vertical Bar Chart · 纵向柱状图

**用途**:月度对比 / 各模块得分 / 6-8 个类目的数值比较。

```html
<div class="vbar-chart">
  <div class="vbar" style="--h: 35%;"><span class="vbar__label">M1</span></div>
  <div class="vbar" style="--h: 62%;"><span class="vbar__label">M2</span></div>
  <div class="vbar" style="--h: 48%;"><span class="vbar__label">M3</span></div>
  <div class="vbar" style="--h: 88%;"><span class="vbar__label">M4</span></div>
  <div class="vbar" style="--h: 71%;"><span class="vbar__label">M5</span></div>
  <div class="vbar" style="--h: 55%;"><span class="vbar__label">M6</span></div>
</div>
```

```css
.vbar-chart {
  display: flex; align-items: flex-end;
  gap: 0.8rem;
  height: 140px;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid var(--c-line);
  position: relative;
}
.vbar {
  flex: 1;
  height: var(--h);
  background: linear-gradient(180deg, var(--c-brand), #2A3744);
  border-radius: 3px 3px 0 0;
  position: relative;
  min-height: 4px;
}
.vbar__label {
  position: absolute;
  bottom: -1.3rem; left: 0; right: 0;
  text-align: center;
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.7rem; color: var(--c-ink-3);
}
```

## 13.7 Line / Area Chart · 折线带面积

**用途**:时间序列趋势(月度营收 / 周度学员数 / 季度 ROAS)。

```html
<svg viewBox="0 0 900 240" preserveAspectRatio="none" width="100%" height="200">
  <!-- 网格线 -->
  <line x1="0" y1="60"  x2="900" y2="60"  stroke="#E5E7EB" stroke-width="1" stroke-dasharray="2,4"/>
  <line x1="0" y1="120" x2="900" y2="120" stroke="#E5E7EB" stroke-width="1" stroke-dasharray="2,4"/>
  <line x1="0" y1="180" x2="900" y2="180" stroke="#E5E7EB" stroke-width="1" stroke-dasharray="2,4"/>

  <!-- 面积填充 -->
  <defs>
    <linearGradient id="area-grad" x1="0" x2="0" y1="0" y2="1">
      <stop offset="0" stop-color="#051C2C" stop-opacity="0.25"/>
      <stop offset="1" stop-color="#051C2C" stop-opacity="0"/>
    </linearGradient>
  </defs>
  <polygon fill="url(#area-grad)"
           points="0,180 100,150 200,160 300,120 400,100 500,80 600,90 700,60 800,40 900,30 900,240 0,240"/>

  <!-- 折线 -->
  <polyline fill="none" stroke="#051C2C" stroke-width="2.5"
            points="0,180 100,150 200,160 300,120 400,100 500,80 600,90 700,60 800,40 900,30"/>

  <!-- 数据点 -->
  <circle cx="0"   cy="180" r="4" fill="#051C2C"/>
  <circle cx="300" cy="120" r="4" fill="#051C2C"/>
  <circle cx="600" cy="90"  r="4" fill="#051C2C"/>
  <circle cx="900" cy="30"  r="4" fill="#E53935"/>  <!-- 最新值用警示红 -->

  <!-- 目标虚线 -->
  <line x1="0" y1="50" x2="900" y2="50" stroke="#E53935" stroke-width="1.5" stroke-dasharray="6,4"/>
</svg>
```

**坐标系约定**:viewBox `0 0 900 240`,顶=0,底=240。值高 → y 小。`preserveAspectRatio="none"` 让 SVG 横向拉满容器。

## 13.8 Half-Circle Gauge · 半圆表盘

**用途**:评分 / 健康度 / 完成度的视觉冲击表达(0-100 范围)。

```html
<svg viewBox="0 0 200 120" width="200" height="120">
  <!-- 底弧 -->
  <path d="M 20 100 A 80 80 0 0 1 180 100"
        fill="none" stroke="#E5E7EB" stroke-width="14" stroke-linecap="round"/>
  <!-- 值弧(76%,半圆总长 ≈ 251) -->
  <path d="M 20 100 A 80 80 0 0 1 180 100"
        fill="none" stroke="#16A34A" stroke-width="14" stroke-linecap="round"
        stroke-dasharray="251" stroke-dashoffset="60"/>
  <!-- 中间数字 -->
  <text x="100" y="90" text-anchor="middle"
        font-family="Fraunces, serif" font-size="32" font-weight="600" fill="#051C2C">76</text>
  <text x="100" y="108" text-anchor="middle"
        font-family="Manrope" font-size="10" fill="#5C6772">学员满意度</text>
</svg>
```

**dashoffset 公式**:`offset = 251 × (1 - 值/100)`。76 分 → 251 × 0.24 ≈ 60。

## 13.9 Status Dots · 状态圆点

**用途**:列表项前缀,表达 ON/OFF/警告/异常。

```html
<svg class="dot dot--up"   width="8" height="8" viewBox="0 0 8 8"><circle cx="4" cy="4" r="4" fill="#16A34A"/></svg>
<svg class="dot dot--warn" width="8" height="8" viewBox="0 0 8 8"><circle cx="4" cy="4" r="4" fill="#F59E0B"/></svg>
<svg class="dot dot--down" width="8" height="8" viewBox="0 0 8 8"><circle cx="4" cy="4" r="4" fill="#DC2626"/></svg>
<svg class="dot dot--flat" width="8" height="8" viewBox="0 0 8 8"><circle cx="4" cy="4" r="4" fill="#6B7280"/></svg>
```

直接 inline 在表格 / 列表前面。

## 13.10 Verdict Tag · 结论标签

**用途**:决策列表的"放大 / 砍掉 / 观察"三态结论。

```html
<span class="verdict verdict--scale">放大</span>
<span class="verdict verdict--kill">砍掉</span>
<span class="verdict verdict--review">观察</span>
```

```css
.verdict {
  display: inline-block;
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.7rem; font-weight: 600;
  letter-spacing: 0.06em;
  padding: 3px 10px;
  border-radius: 4px;
  border: 1px solid;
}
.verdict--scale  { color: #16A34A; background: #16A34A12; border-color: #16A34A33; }
.verdict--kill   { color: #DC2626; background: #DC262612; border-color: #DC262633; }
.verdict--review { color: #F59E0B; background: #F59E0B12; border-color: #F59E0B33; }
```

## 13.11 Hover Row · 表格悬停高亮

**用途**:数据表格 / 列表的可读性增强(鼠标停留时本行轻微高亮)。

```html
<div class="hover-row">
  <span>客户 A</span><span>¥12,500</span><span>+12%</span>
</div>
```

```css
.hover-row {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr;
  padding: 0.6rem 0.8rem;
  border-radius: 6px;
  transition: background 0.2s;
}
.hover-row:hover { background: #F8F9FA; }
[data-theme="dark"] .hover-row:hover { background: #15263D; }
```

## 13.12 一页 Dashboard 范例(怎么组合上面这些)

**这是个标准的"业绩仪表板"页**,展示组合方式:

```html
<section class="slide" data-name="2026 Q1 业绩仪表板">
  <div class="page">
    <div class="page-meta">
      <span class="module">模块 3 · 业绩复盘</span>
      <span>03 / 12</span>
    </div>
    <h2 class="page-title">2026 Q1 业绩仪表板</h2>
    <p class="page-subtitle">营收增长 49.3%,但获客成本同步上升 32%,需要关注效率</p>

    <div class="page-body">
      <!-- 顶部 metric card 排(4 个 KPI)-->
      <div class="metric-row" style="display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;">
        <div class="metric-card">...</div>
        <div class="metric-card">...</div>
        <div class="metric-card">...</div>
        <div class="metric-card">...</div>
      </div>

      <!-- 中部:左折线 + 右 donut -->
      <div style="display:grid;grid-template-columns:2fr 1fr;gap:1.5rem;margin-top:1.5rem;">
        <div>
          <h3 style="font-size:0.8rem;color:var(--c-ink-3);">月度营收趋势</h3>
          <!-- Line/Area chart -->
          <svg viewBox="0 0 900 240">...</svg>
        </div>
        <div>
          <h3 style="font-size:0.8rem;color:var(--c-ink-3);">渠道占比</h3>
          <!-- Donut -->
          <svg viewBox="0 0 200 200">...</svg>
        </div>
      </div>

      <!-- 底部 source line -->
      <p class="page-source" style="margin-top:1rem;font-size:0.7rem;color:var(--c-ink-3);">
        SOURCE / 内部经营数据 · 2026-03-31 截止 · 已脱敏
      </p>
    </div>
  </div>
</section>
```

## Dashboard 页的密度上限

| 元素 | 上限 |
|---|---|
| Metric card | 一行 ≤ 4 |
| Donut / Gauge / Pie | 一页 ≤ 3 |
| Line / Area chart | 一页 ≤ 2 |
| Vertical bar | 一页 ≤ 1(给足横向空间) |
| Sparkline | 不限,因为内联 |

**超过上限就拆页**(同"信息密度铁律")。一个 dashboard 页 ≤ 6 个独立图表区域,否则没人看得清。

---

## 何时用 Dashboard 版式 vs 普通版式

| 场景 | 用 Dashboard | 用普通版式(卡片 / metric-row) |
|---|---|---|
| 培训片的"行业数据"页 | ✅ Donut / Gauge 单图为主 | |
| 培训片的"学员任务"页 | | ✅ 卡片网格 |
| 客户提案的"业绩复盘" | ✅ 全套 dashboard 范例 | |
| 客户提案的"我们的服务" | | ✅ 卡片网格 + Key Insight |
| 莱美的"双月业绩" | ✅ Metric card + Vertical bar | |
| 自媒体小红书封面 | | ✅ Big Number / Big Quote |
