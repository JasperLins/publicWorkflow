---
name: app-ui-design
description: 把已确认的界面清单与 UI 风格规范直接生成为高保真静态原型站(HTML+Tailwind+FontAwesome,输出到 ./UI/)。当阶段 5 已产出 ux-flows.md(界面清单)与 ui-spec.md(风格)且需要可浏览、可交给 AI 开发复现的原型时使用本 skill;仅做静态原型,不实现业务逻辑与数据交互,不适用于线框图或交互演示需求。
version: 1.1
updated: 2026-08-17
---

# Skill: app-ui-design — 高保真静态原型生成

> v1.1 变更:按冒烟测试与 Agent Skills 规范改写——主提示词由嵌套模板改为命令式指令;新增 CDN 白名单与降级链、外框归属约定、图标映射、单位换算、图片降级规则。原始提示词源自框架需求方(about.md),要点全部保留。

## 输入依赖(缺失即报告,不猜测)
- `docs/05-uiux/ux-flows.md`:界面清单(屏号/名称/目的/关键元素/优先级)
- `docs/05-uiux/ui-spec.md`:风格规范(色彩/字体/圆角/组件)
- `memory/project-profile.md`:项目名称与业务语境(文案用)
- 缺任一项 → 向项目经理报告,不得自行假设界面或风格。

## 执行步骤(命令式,逐步执行)
1. **读取输入**:按上表读齐三份文档;项目名称从 project-profile 一句话概述中提取,无需主代理替换占位符。
2. **用户体验分析**:从画像与界面清单提炼核心用户需求与交互逻辑,列出每屏「用户此刻想完成什么」。
3. **界面规划核对**:逐屏核对界面清单(P0 先行、P1 次之);不擅自增删界面,确需新增(如缺少登录页)先报告并说明理由。
4. **高保真设计**:按 ui-spec.md 落实色彩/字体层级/圆角/间距/阴影到每屏;遵循真实 iOS(Web 产品则按桌面规范)设计语言,使用现代化 UI 元素。**单位规则**:ui-spec 若用 pt 标注字号,按 CSS px 等值直接使用(20pt→20px),并在 HTML 注释声明该换算决策。
5. **逐屏生成 HTML** 到 `./UI/`(每屏一文件,kebab-case 命名,与清单屏名对应):
   - 技术栈:HTML + Tailwind CSS + FontAwesome,全部 CDN 引入(白名单见下);类名只用标准工具类与任意值语法 `w-[393px]`,保证跨 CDN 版本兼容。
   - **App 产品**:屏文件为纯 393×852 画布——顶部 iOS 状态栏(时间 9:41/信号/Wi-Fi/电量,可含灵动岛)+ 内容区 + 底部 TabBar(含 Home Indicator)。**手机圆角外框由 index.html 的设备壳实现,屏文件内不做外框**(避免压缩内容宽度、裁切 fixed TabBar)。
   - **Web 产品**:按 1440×900 桌面视口,含顶部导航与页脚。
   - **状态演示**:静态页无法演示交互动画——关键控件**并列展示默认态与禁用态实例**(如「分享」默认+active、「导出 PDF」禁用);按压/悬停用 `:active`/`:hover` 伪类表达。
   - **多状态界面**(清单含「列表+空态」等):主态完整呈现;次要状态(空态/筛选无结果)以带虚线边框+标注的区块并列呈现,标注格式「状态样式 · 触发条件」。
   - 文案用真实业务语言(取自项目画像语境,如具体物料名/单价/编号),禁止 Lorem ipsum 与"示例文本"。
   - 图片优先用已验证的 Unsplash/Pexels 直链;无匹配图或外网不可达时,用纯 CSS 渐变/图标组合替代并在注释声明「设计选择,非占位符」——**禁止灰色占位块**。
6. **生成 `./UI/index.html`**:iframe 平铺嵌入全部界面(不跳转);iframe 固定 393×852,**内容超出时允许屏内纵向滚动**;外层用设备壳 div 呈现圆角手机边框;每个 iframe 下方标注「屏号 · 界面名 · 用途」。
7. **CDN 校验(生成后必做)**:对主源 URL 各执行一次可达性校验(curl 或等效方式);不可达则按降级链换源并更新全部文件;全部源不可达(纯内网)时改用内联最小样式方案并在 index.html 顶部注释声明环境限制。**图片直链 HEAD 校验遇瞬时限流(000)时,用 range GET(`curl -r 0-99`)复验,返回 206 即视为可达。**
8. **登记**:把登记行(路径+一句话摘要+关键词)随回传交**主代理统一落盘** `outputs-index.md`(并行纪律:子代理不直接写共享记忆);该文件不存在时由主代理按 `memory/README.md` 规范创建。
9. **自检**:逐项执行下方自检清单后回传。

## CDN 白名单与降级链
| 资源 | 主源(实测较稳) | 备源 1 | 备源 2 |
|---|---|---|---|
| Tailwind | `https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4` | `https://unpkg.com/@tailwindcss/browser@4` | `https://cdn.tailwindcss.com` |
| FontAwesome | `https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.2/css/all.min.css` | `https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css` | unpkg 同名包 |

> 经验依据:2026-08 实测部分受限网络下 cdn.tailwindcss.com 与 cdnjs SSL 失败、jsDelivr 与 images.unsplash.com 可达;故 jsDelivr 列为主源。

## 常用图标映射(FontAwesome 6,TabBar/通用控件)
| 功能 | 图标 class | 功能 | 图标 class |
|---|---|---|---|
| 首页 | `fa-house` | 历史/记录 | `fa-clock-rotate-left` |
| 计算/比价/结果 | `fa-scale-balanced` | 搜索 | `fa-magnifying-glass` |
| 库存/食材(FA6 免费版无冰箱图标) | `fa-box-archive` | 设置 | `fa-gear` |
| 新建/添加 | `fa-plus` | 分享 | `fa-arrow-up-from-bracket` |
| 导出 PDF | `fa-file-pdf` | 返回 | `fa-chevron-left` |

> 界面清单未指定图标时按此映射;特殊业务图标自行选择语义最接近者并在注释标注。

## 投入缩放
- **轻量(≤4 屏)**:一次生成全部。
- **标准(5–10 屏)**:先 P0 核心闭环一批生成并自检,再 P1/P2 第二批。
- **深度(>10 屏)**:按模块分 3 批以上,每批生成后即时自检,避免单次上下文过载。

## 质量自检清单
- [ ] 界面数 = 界面清单数,文件名与屏名一一对应
- [ ] index.html iframe 平铺展示所有界面且无死链(无 javascript: 空链,无跳转即动作用的 `<button>` 而非 `<a>`)
- [ ] App 端:393×852 画布 + iOS 状态栏 + 底部 TabBar(界面清单明确豁免的屏除外,如 Onboarding);圆角外框仅在 index 设备壳
- [ ] CDN 主源已校验可达(或已按降级链换源/内联降级并注释)
- [ ] 图片为真实直链或声明的 CSS 渐变替代,无灰块占位
- [ ] 文案为真实业务语言,无 Lorem ipsum
- [ ] 色彩/字体/圆角/阴影与 ui-spec.md 一致(pt 已按 px 等值换算并注释)
- [ ] 关键控件并列演示默认/禁用态;次要状态区块带标注
- [ ] 标签开闭配平(校验用 Python/Node 等工具,勿依赖 grep 对 `</tag>` 的匹配)
- [ ] 已登记 outputs-index.md

## CHANGELOG
- 1.1(2026-08-17):命令式改写;CDN 白名单+降级链+校验;外框归属/滚动/单位/图标/状态演示/图片降级规则;outputs-index 自动创建;投入缩放。依据:冒烟测试 C(_test/reports/test-c-ui.md)与 Agent Skills 官方规范调研。
- 1.0(2026-08-15):初版,基于需求方原始提示词。
