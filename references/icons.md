# SVG Icon 库(v5.5 新增 · 借鉴 robonuggets/marp-slides)

> **饶秋老师说"我们之前文字太单一了"——这个 icon 库就是用来配合 SVG 图表给信息处理页提供视觉锚点的。**

## 设计规范

**所有图标都遵守这个标准**:

```html
<svg width="16" height="16" viewBox="0 0 24 24"
     fill="none" stroke="currentColor" stroke-width="1.5"
     stroke-linecap="round" stroke-linejoin="round">
  <!-- path / circle / polyline 内容 -->
</svg>
```

**4 条铁律**:
1. **viewBox 永远 `0 0 24 24`**(Lucide / Feather 同款,业界共识)
2. **stroke-width = 1.5**(不要 2,2 太粗会显廉价)
3. **`fill="none"` + `stroke="currentColor"`** — 颜色跟父元素 `color` 走,改色不用改 SVG
4. **`stroke-linecap="round"` + `stroke-linejoin="round"`** — 圆头线条,符合"程前式干净简单"

## 三种尺寸用法

| 用法 | width / height | 配套字号 |
|---|---|---|
| **内联** inline(文字行内) | 14-16px | 跟随文字字号 |
| **卡片标题前** | 20-24px | 跟随标题字号(约 1rem) |
| **特性突出** feature | 32-44px | 跟随小标题(约 1.4rem) |
| **Big Number 页装饰** | 56-72px | 不超过数字字号的 1/4 |

**控制方式**:用外层 CSS,不要改 SVG 本身的 width/height。

```css
.icon-inline   { width: 14px; height: 14px; }
.icon-card     { width: 24px; height: 24px; }
.icon-feature  { width: 36px; height: 36px; }
.icon-hero     { width: 64px; height: 64px; }
```

---

## 基础图标(必装 · 24 个)

### 趋势 · 数据类

```html
<!-- arrow-up · 上升(配 #16A34A 绿色)-->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <polyline points="18 15 12 9 6 15"/>
</svg>

<!-- arrow-down · 下降(配 #DC2626 红色)-->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <polyline points="6 9 12 15 18 9"/>
</svg>

<!-- arrow-right · 流程箭头 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <line x1="5" y1="12" x2="19" y2="12"/>
  <polyline points="12 5 19 12 12 19"/>
</svg>

<!-- trending-up · 折线趋势上 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/>
  <polyline points="17 6 23 6 23 12"/>
</svg>

<!-- bar-chart · 柱状图 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <line x1="12" y1="20" x2="12" y2="10"/>
  <line x1="18" y1="20" x2="18" y2="4"/>
  <line x1="6"  y1="20" x2="6"  y2="16"/>
</svg>

<!-- pie-chart · 饼图 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M21.21 15.89A10 10 0 1 1 8 2.83"/>
  <path d="M22 12A10 10 0 0 0 12 2v10z"/>
</svg>
```

### 状态 · 反馈类

```html
<!-- check · 通过(配 #16A34A)-->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <polyline points="20 6 9 17 4 12"/>
</svg>

<!-- check-circle · 完成确认 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
  <polyline points="22 4 12 14.01 9 11.01"/>
</svg>

<!-- x-circle · 不通过(配 #DC2626)-->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="10"/>
  <line x1="15" y1="9"  x2="9"  y2="15"/>
  <line x1="9"  y1="9"  x2="15" y2="15"/>
</svg>

<!-- alert-triangle · 警告(配 #F59E0B)-->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
  <line x1="12" y1="9"  x2="12" y2="13"/>
  <line x1="12" y1="17" x2="12.01" y2="17"/>
</svg>

<!-- info · 信息提示 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="10"/>
  <line x1="12" y1="16" x2="12" y2="12"/>
  <line x1="12" y1="8"  x2="12.01" y2="8"/>
</svg>
```

### 时间 · 节奏类

```html
<!-- clock · 时长 / 截止 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="10"/>
  <polyline points="12 6 12 12 16 14"/>
</svg>

<!-- calendar · 日期 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <rect x="3" y="4"  width="18" height="18" rx="2" ry="2"/>
  <line x1="16" y1="2"  x2="16" y2="6"/>
  <line x1="8"  y1="2"  x2="8"  y2="6"/>
  <line x1="3"  y1="10" x2="21" y2="10"/>
</svg>

<!-- zap · 闪电 / 高效 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/>
</svg>
```

### 内容 · 主体类

```html
<!-- file-text · 文档 / 课件 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
  <polyline points="14 2 14 8 20 8"/>
  <line x1="16" y1="13" x2="8"  y2="13"/>
  <line x1="16" y1="17" x2="8"  y2="17"/>
  <polyline points="10 9 9 9 8 9"/>
</svg>

<!-- book-open · 培训 / 学习 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
  <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
</svg>

<!-- users · 学员 / 团队 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
  <circle cx="9" cy="7" r="4"/>
  <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
  <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
</svg>

<!-- target · 目标 / 学习目的 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="10"/>
  <circle cx="12" cy="12" r="6"/>
  <circle cx="12" cy="12" r="2"/>
</svg>

<!-- lightbulb · 洞察 / 灵感(配 Key Insight 页)-->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M9 18h6"/>
  <path d="M10 22h4"/>
  <path d="M12 2a7 7 0 0 0-4 12.74V17h8v-2.26A7 7 0 0 0 12 2z"/>
</svg>
```

### 工具 · 操作类

```html
<!-- edit · 编辑 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
  <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
</svg>

<!-- download · 导出 / 下载 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
  <polyline points="7 10 12 15 17 10"/>
  <line x1="12" y1="15" x2="12" y2="3"/>
</svg>

<!-- search · 搜索 / 发现 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="11" cy="11" r="8"/>
  <line x1="21" y1="21" x2="16.65" y2="16.65"/>
</svg>

<!-- settings · 配置 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="3"/>
  <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>
</svg>

<!-- play · 播放 / 开始 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <polygon points="5 3 19 12 5 21 5 3"/>
</svg>
```

### 商业 · 业绩类

```html
<!-- dollar-sign · 营收 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <line x1="12" y1="1" x2="12" y2="23"/>
  <path d="M17 5H9.5a3.5 3.5 0 1 0 0 7h5a3.5 3.5 0 1 1 0 7H6"/>
</svg>

<!-- activity · 业务活跃度 / 心电 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
</svg>

<!-- award · 成就 / 认证 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="8" r="7"/>
  <polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"/>
</svg>

<!-- globe · 全球 / 行业 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="10"/>
  <line x1="2" y1="12" x2="22" y2="12"/>
  <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>
</svg>

<!-- shield · 合规 / 保障 -->
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
  <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
</svg>
```

---

## 配色规则

| 语义 | 颜色变量 | hex | 用在哪 |
|---|---|---|---|
| 中性 / 默认 | `--c-ink-3` | `#5C6772` | 普通图标 |
| 主色强调 | `--c-brand` | `#051C2C` | 主标题前的图标 |
| 正向 / 上升 | `--c-up` | `#16A34A` | check / arrow-up / trending-up |
| 负向 / 下降 | `--c-down` | `#DC2626` | x-circle / arrow-down |
| 警告 / 注意 | `--c-warn` | `#F59E0B` | alert-triangle / info |
| 客户色重音 | `--c-warm` | `#E53935` | 最多 3 处客户色出现 |

**禁用**:
- 不要给图标加 fill 渐变
- 不要给图标加 drop-shadow
- 不要把图标缩到 < 12px(看不清还不如不用)
- 不要 3 种以上颜色同时出现(主色 + 1-2 个语义色 已是上限)

---

## 哪里去找更多 icon

**首选**:[Lucide Icons](https://lucide.dev/icons/) — 1500+ 图标,全部遵守本规范(viewBox 24,stroke 1.5),直接复制 SVG 代码就能用。

**备选**:[Feather Icons](https://feathericons.com/) — Lucide 的前身,规范相同,数量少些。

**禁用**:
- Material Icons(填充式,违反"线条简洁")
- Font Awesome(品牌色 / 实色填充,违反"克制")
- 任何带表情 emoji 的图标库

## 怎么在 template.html 里集成

```html
<!-- 在卡片标题前嵌入图标 -->
<div class="card">
  <h3 class="card-title">
    <svg class="icon-card" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
      <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
    </svg>
    业绩心跳
  </h3>
  <p>本月营收 ¥41,946,环比 +49.3%。</p>
</div>
```

```css
/* template.html 顶部添加 */
.card-title {
  display: flex; align-items: center; gap: 0.5rem;
  color: var(--c-brand);
}
.icon-inline   { width: 14px; height: 14px; flex-shrink: 0; }
.icon-card     { width: 22px; height: 22px; flex-shrink: 0; color: var(--c-ink-3); }
.icon-feature  { width: 36px; height: 36px; flex-shrink: 0; color: var(--c-brand); }
.icon-hero     { width: 64px; height: 64px; flex-shrink: 0; color: var(--c-warm); opacity: 0.4; }
```

**注意 `flex-shrink: 0`**:在 flex 容器里图标会被压缩变形,必须锁死。
