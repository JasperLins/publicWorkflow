# 冒烟测试报告 C:app-ui-design 技能 ×「高级 UI 设计师」角色

| 版本 | 日期 | 状态 | 执行者 |
|---|---|---|---|
| v1.0 | 2026-08-17 | 完成 | 冒烟测试员(代行「高级 UI 设计师」) |

**测试对象**:`skills/app-ui-design/SKILL.md` v1.0 + `roles/ui-designer.md`
**测试输入**:`_test/memory/project-profile.md`、`_test/docs/05-uiux/ux-flows.md`(3 屏)、`_test/docs/05-uiux/ui-spec.md` v0.1
**测试产出**:`_test/UI/` home.html / result.html / history.html / index.html

---

## 一、执行概览

严格按 SKILL「执行流程」跑:读两份输入(齐全,未触发"缺失报告")→ 按"先核心流程后次要"顺序生成 3 屏(home P0 → result P0 → history P1,与清单屏号/优先级一致)→ 生成 index.html iframe 平铺 → 执行质量自检清单 → 登记 `_test/memory/outputs-index.md`。全程无需用户中途介入,主提示词结构(用户体验分析→界面规划→UI 设计→HTML 实现)可独立遵循。

## 二、质量自检清单逐项结果(SKILL.md 原文 7 项)

| # | 自检项 | 结果 | 原因/证据 |
|---|---|---|---|
| 1 | 界面数 = 界面清单数,命名对应 | ✅ 通过 | 清单 3 屏,产出 home/result/history 3 屏,文件名与清单 S1–S3 逐字对应,未增删 |
| 2 | index.html 平铺展示所有界面且无死链 | ✅ 通过 | 3 个 iframe 相对 src 均存在;屏间 TabBar 互链(home↔result↔history)共 13 处 href 全部指向已存在文件;分享/搜索等无跳转动作用 `<button>` 而非空 `<a>`,无 javascript: 空链 |
| 3 | App 端有 iOS 状态栏 + 底部 TabBar;尺寸 393×852 | ✅ 通过 | 每屏含 54px 状态栏(9:41/信号/Wi-Fi/电量 + 灵动岛)与底部 3 Tab TabBar(含 Home Indicator);`html,body{width:393px}` 固定画布;index 侧 852px 设备壳 |
| 4 | 图片为真实图片直链,无占位符 | ✅ 通过(附条件) | 实测 2 个 Unsplash 人像直链 HTTP 200(home.html 用户头像);供应商字母标/渐变数据卡为**设计选择**并已代码注释声明;全站无灰块占位。条件:见摩擦 F1/F7,图片可用性依赖外网 |
| 5 | 文案为真实业务语言 | ✅ 通过 | 法兰盘 DN50、含税单价 ¥12.40、账期 60 天、加权评分 92 分、BJ-240817-01 编号等,全部取自项目画像语境,无 Lorem ipsum |
| 6 | 色彩/字体/圆角与 ui-spec.md 一致 | ✅ 通过 | #2563EB/#0F172A/#64748B/#F8FAFC 全套色值直引;标题 20px 粗体/正文 15px/辅助 12px 灰;卡片 rounded-2xl(=16px)、按钮 rounded-xl(=12px)、阴影统一 `0 2px 8px rgba(15,23,42,.08)`;三语义色在 result/history 均有使用 |
| 7 | 所有 HTML 可独立打开,控制台无报错(静态层面) | ✅ 通过(以 CDN 可达为前提) | DOCTYPE/lang 完整,Python 校验 4 文件 10 类标签开闭全配平;无自定义 JS,仅 2 个 CDN 引入。但默认 CDN 在本网络不可达(见 F1),已降级 jsDelivr 并注释;若在无外网机器打开将裸奔 |

**小结:7/7 通过,其中 2 项带环境条件(外网/CDN)。**

## 三、执行摩擦清单(位置 / 严重度 / 现象 / 改法)

| # | 位置 | 严重度 | 现象 | 具体改法 |
|---|---|---|---|---|
| F1 | SKILL.md 主提示词第 4 条(L24)"Tailwind CSS(CDN 引入)"、产出要求 L51;roles/ui-designer.md L30 | **阻塞(条件性)** | 常规默认源 cdn.tailwindcss.com 与 cdnjs.cloudflare.com 在本环境 SSL 失败(curl 000,重试仍 000),jsDelivr 与 images.unsplash.com 实测 200。未实测链接的执行代理会产出"打不开即裸奔"的页面,且无任何提示 | SKILL 增补「CDN 白名单 + 降级链」:主源 jsdelivr(`@tailwindcss/browser@4`、`@fortawesome/fontawesome-free@6.5.2`),备源 cdnjs/unpkg;并要求生成后至少 curl 校验一次主源可达;注明"类名只用标准 + 任意值语法,保证跨版本 CDN 兼容"(本次实测有效) |
| F2 | SKILL.md L33"界面尺寸 393×852 + 圆角化外框" | 建议(歧义) | 未说明圆角外框放屏文件内还是 index 内。放屏文件内会压缩 393 内容宽并裁切 fixed TabBar | 明确实现约定:「屏文件 = 纯 393×852 画布(状态栏含灵动岛);手机圆角外框由 index.html 的设备壳 div 实现」。本次按此实现,效果正确 |
| F3 | SKILL.md L33 / ux-flows 清单 | 建议(缺失指引) | TabBar 只给名称(首页/结果/历史),FA 图标选择无任何指引,纯凭设计师临场发挥,跨项目不可复现 | SKILL 附录加常用 Tab 图标映射(house / scale-balanced / clock-rotate-left / user / gear…),或 ui-spec 模板增加「图标」小节 |
| F4 | SKILL.md L38"状态齐全(默认/激活/禁用)" | 建议(与静态原型矛盾) | 静态页无法演示 hover/active 交互过程,只能并列多状态实例 + CSS 伪类近似 | 措辞改为:「关键控件并列演示默认态与禁用态实例;按压/悬停以 active/hover 伪类表达」(本次:分享按钮默认+active、导出 PDF 禁用、筛选 chip 选中/默认、列表态+空态) |
| F5 | SKILL.md L33 与 iframe 平铺(L30)隐含冲突 | 建议(未定义溢出策略) | home/result 内容实际超过 852px,iframe 高度固定只能屏内滚动;SKILL 未说明"限一屏"还是"允许内滚" | 补一句:「iframe 固定 393×852,界面内容超出时允许屏内纵向滚动」 |
| F6 | ui-spec.md §7 字号用 pt(20pt/15pt/12pt) | 建议(单位歧义) | HTML 用 px;若按 1pt≈1.333px 严格换算,20pt≈26.7px,明显大于 iOS 常规标题,两代理可能各算各的 | ui-spec 模板统一改 px;或 SKILL 写明「pt 数值按 CSS px 直接使用」。本次决策:按 px 等值映射并在代码注释说明 |
| F7 | SKILL.md L35"Unsplash、Pexels 稳定直链" + 自检项 4 | 建议(无校验/降级规则) | "稳定直链"从何而来无指引:执行代理只能凭记忆报 photo-id,无法确认可达;也未定义"不需要图片的界面"如何自证清白 | 附「已验证直链样例清单(按用途:人像/工业/办公)」+ 降级规则:「无网或无匹配图时用纯 CSS 渐变/图标并在注释声明为设计选择;禁灰块占位」 |
| F8 | ux-flows.md S3 关键元素"列表 + 空态提示"同屏 | 建议(静态二义) | 一屏静态只能展示一个主态,空态要么丢要么并列 | 界面清单模板区分「主态」与「组件规格态(允许以带标注区块并列呈现)」;本次以虚线框+标题"空态样式·筛选无结果时展示"并列实现,可复现但稍损真实感 |
| F9 | SKILL.md 执行流程第 4 步"登记 memory/outputs-index.md" | 建议(边界未定义) | 未说明该文件不存在时由谁创建。实测 _test 环境中存在(阶段 0/1 测试者已建),直接追加即可;但全新项目中首次调用必踩 | 补一句:「outputs-index.md 不存在时由执行代理按 memory/README 规范创建」 |
| F10 | SKILL.md 主提示词 L16 `{项目/产品名称}` 占位符 | 建议 | 未指明由主代理替换还是执行子代理读取 project-profile 后填充 | 注明「占位符由执行代理从 project-profile.md 读取填充,主代理无需预处理」 |

另记 1 个**环境怪癖**(非框架问题,但对未来自动化测试有用):本机 Git Bash 的 grep 对 `</tag>` 模式恒返回 0(echo 直测可复现),标签配平校验须用 Python 等替代,避免误判产出损坏。

## 四、执行统计

| 项 | 值 |
|---|---|
| 产出文件 | 4 个(home.html 146 行、result.html 180 行、history.html 166 行、index.html 65 行,共 557 行)+ 登记 outputs-index.md 1 行 |
| 生成顺序 | home.html → result.html → history.html → index.html → 自检 → 登记(先 P0 后 P1,符合 SKILL"先核心后次要") |
| 中途返工 | 0 次;但 CDN 选型因实测失败主动切换 1 次(F1) |
| 网络实测 | unsplash 2/2 直链 200;jsdelivr 2/2 200;cdn.tailwindcss.com、cdnjs、unpkg 均 000 |
| token 粗估 | 输入 ≈3.5k(角色+技能+3 输入文档),输出 ≈9k(4 HTML+报告),比 ≈1:2.6 |

## 五、结论

**修复后可用。**

- 技能主线(流程、产出结构、自检清单、真实感要求)清晰可执行,一次通过 7/7 自检,角色文件与 SKILL 分工无重叠冲突;
- 但存在 1 个条件性阻塞 F1(指定 CDN 在受限网络不可达且无降级指引)——不改则在部分企业内网环境必然产出裸奔页面;F2/F3/F5/F6 属十分钟级的小修,修完即可作为 v1.1 发布;
- 建议优先级:F1 > F2(外框归属)> F6(pt/px)> F3(图标映射)> 其余。
