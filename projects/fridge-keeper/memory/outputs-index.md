# 产出物索引与运行台账(Outputs Index)

> 项目目录 projects/fridge-keeper/(端到端实测);本文件是项目唯一进度事实源。阶段 0/1 数据为种子(端到端实测从阶段 2 起)。

## 文档索引
| 日期 | 阶段 | 文档路径 | 一句话摘要 | 关键词 | 状态 |
|---|---|---|---|---|---|
| 2026-08-17 | 1 | projects/fridge-keeper/docs/01-brainstorm/ideas.md | 12 条创意→3 方向,推荐方向 A(总分 9) | 头脑风暴、方向A、AI识别 | 已确认 |
| 2026-08-17 | 1 | projects/fridge-keeper/docs/01-brainstorm/questions-stage1.md | 3 题,模拟选推荐项(D-001~003) | 决策、批量提问 | 已确认 |
| 2026-08-17 | 2 | projects/fridge-keeper/docs/02-market/feasibility.md | 可行性「调整后做」(中置信):TAM 75–150 亿/SAM 8–16 亿/SOM 中值 272 万/年 | 市场测算、食物浪费、TAM-SAM-SOM、订阅变现 | 已确认 |
| 2026-08-17 | 2 | projects/fridge-keeper/docs/02-market/competitor-analysis.md | 6 竞品(4 直接 2 间接)+14 项矩阵+定价带;最强竞品「有菜」高度重合 | 竞品、定价锚点、差异化、有菜 | 已确认 |
| 2026-08-17 | 2 | projects/fridge-keeper/docs/02-market/questions-stage2.md | 8 题合并,模拟选推荐项(D-004~010);预检通过 | 决策、批量提问 | 已确认 |

| 2026-08-17 | 3 | projects/fridge-keeper/docs/03-requirements/requirement-doc.md | PRD:14 条 FR(P0×10/P1×3/P2×1),闭环=整拍录入→临期→菜谱→消耗;不做清单 10 项 | PRD、范围边界、验收标准 | 已确认 |
| 2026-08-17 | 3 | projects/fridge-keeper/docs/03-requirements/feature-list.md | 初估直接 34.5/含缓冲×1.4=48.3 人日(P0 28.5);候选 5 人日单列;待阶段 4 校准 | 功能拆解、工时初估、AI并行87% | 已确认(初估口径) |
| 2026-08-17 | 3 | projects/fridge-keeper/docs/03-requirements/questions-stage3.md | 8 题,模拟选推荐项(D-011~018);QA 预检修复 5 项后通过 | 决策、批量提问 | 已确认 |
| 2026-08-17 | 4 | projects/fridge-keeper/docs/04-tech/tech-stack.md | 方案 A(SwiftUI+FC 极薄代理+qwen3-vl-flash 主力/GLM 备援)打分 4.70,架构图+8 风险 | 技术栈、架构图、视觉API | 已确认 |
| 2026-08-17 | 4 | projects/fridge-keeper/docs/04-tech/third-party-services.md | 单次识别 ¥0.0005;月成本 57+MAU×0.00768;N∈[15,60] 推荐 30 | 第三方成本、免费额度、API | 已确认 |
| 2026-08-17 | 4 | projects/fridge-keeper/docs/04-tech/questions-stage4.md | 7 题,模拟选推荐项(D-019~025);主代理预检通过 | 决策、批量提问 | 已确认 |
| 2026-08-17 | 4 | projects/fridge-keeper/docs/03-requirements/feature-list.md | **v0.2 已回填校准**:27 子任务,直接 38.5/含缓冲 53.9(+11.6% 阈值内),P0 含缓冲 45.5,AI 并行 81% | 功能拆解、回填校准、变更记录 | 已确认 |
| 2026-08-17 | 4 | projects/fridge-keeper/docs/03-requirements/requirement-doc.md | v0.2:FR-10 N=30、FR-11 M=300 按 D-021 回填 | PRD、额度参数 | 已确认 |
| 2026-08-17 | 5 | projects/fridge-keeper/docs/05-uiux/ux-flows.md | UX:12 屏(P0×9/P1×3),TabBar 4+中央📷,闭环四环+5 类异常,字号 px 体系,FR 全映射 | UX、界面清单、信息架构 | 已确认 |
| 2026-08-17 | 5 | projects/fridge-keeper/docs/05-uiux/ui-spec.md | UI 规范:鲜蔬绿 hex 全套(D-030)、字号 28/20/16/15/12、组件规格、CDN 实测 | UI 规范、色彩、组件 | 已确认 |
| 2026-08-17 | 5 | projects/fridge-keeper/UI/(index+12 屏) | 高保真原型 13 文件,3 批生成,自检 9✓1△,jsDelivr 200,零 lorem 零死链 | UI、原型、Tailwind | 已确认 |
| 2026-08-17 | 5 | projects/fridge-keeper/docs/05-uiux/questions-stage5.md | 5 题(4 题先行裁决+风格题),模拟选推荐项(D-026~030);预检通过 | 决策、批量提问 | 已确认 |
| 2026-08-17 | 6 | projects/fridge-keeper/docs/06-ai-plan/ai-dev-plan.md | AI 开发计划:12 任务包 6 批次,中性 20 工作日/28 日历天,token 三档 1,550/2,670/4,730 万(¥124/214/378),人力提效 3.6×,台账校准闭合 | AI开发计划、token三档、校准 | 已确认 |
| 2026-08-17 | 7 | projects/fridge-keeper/docs/07-business/cost-profit.md | 内部版:总成本 ¥36,659(A)/公允等效 ¥91,410;三档 ¥44,000–55,000(推荐 ¥49,500,利润 ¥12,841);敏感性三情景 | 成本利润、三档、敏感性 | 已确认 |
| 2026-08-17 | 7 | projects/fridge-keeper/docs/07-business/quotation.md | 甲方版报价 ¥49,500 含税:7 分项包干+人天 ¥1,800 并列+30-40-30+交付物;保密扫描 0 命中 | 报价单、包干、里程碑 | 已确认 |
| 2026-08-17 | 7 | projects/fridge-keeper/docs/07-business/questions-stage7.md | 7 题,模拟选推荐项(D-033~039);QA 预检修复 4 项后通过 | 决策、批量提问 | 已确认(旧口径,被 7-v2 部分取代) |
| 2026-08-17 | 7-v2 回溯 | projects/fridge-keeper/docs/06-ai-plan/ai-dev-plan.md | **v0.2**:AI 节奏模型 12 工作日/17 日历天(测试修复 46%);token ¥0 包月,配额占比待填 | AI开发计划、AI节奏、配额 | 已确认(v1.4 口径) |
| 2026-08-17 | 7-v2 回溯 | projects/fridge-keeper/docs/04-tech/third-party-services.md | v0.2 增补:部署形态 Serverless+纯客户端,无需独立服务器;费用结论 ¥57+MAU×0.00768 | 服务器、部署形态 | 已确认 |
| 2026-08-17 | 7-v2 回溯 | projects/fridge-keeper/docs/07-business/cost-profit.md | v0.2 三法定价:行情 21-52K/难度交叉/底价 30,734 红线 36,881;推荐 ¥38,000(利润 ¥7,266 如实) | 行情锚定、底价红线、贴线定价 | 已确认 |
| 2026-08-17 | 7-v2 回溯 | projects/fridge-keeper/docs/07-business/quotation.md | v0.2 甲方版报价 ¥38,000;人天口径默认不并列;零内部数字 | 报价单、行情依据 | 报价中(有效期 30 天) |
| 2026-08-17 | 7-v2 回溯 | projects/fridge-keeper/docs/07-business/questions-stage7-v2.md | 4 题口径变更备案,模拟选推荐项(D-040~043) | 口径变更、批量提问 | 已确认 |
| 2026-08-17 | 7-v3 回溯 | projects/fridge-keeper/docs/07-business/cost-profit.md | **v0.3 AI 竞争定价**:现金成本 ¥40 红线 ¥48;三档 3,500/**4,000(委托方拍板)**/6,000;利润 ¥3,960;质量红线入文;修正 v0.2 模块合计缺陷 | AI竞争定价、现金红线、质量红线 | 已确认(v1.5 口径,委托方指示) |
| 2026-08-17 | 7-v3 回溯 | projects/fridge-keeper/docs/07-business/quotation.md | **v0.3 甲方版报价 ¥4,000 含税**:7 模块包干精确合计 4,000 + 质量承诺条款 + 30-40-30;保密扫描 0 泄露 | 报价单、质量承诺、竞争档 | 报价中(有效期 30 天) |
| 2026-08-17 | 7-v3 回溯 | projects/fridge-keeper/docs/07-business/questions-stage7-v3.md | 1 题备案:报价 ¥4,000 替代 D-040;委托方指示即为答复(D-044) | 口径变更、批量提问 | 已确认 |

## 阶段运行台账(token 按 skill 粒度)
| 阶段 | 子任务状态(done/pending) | token 估算 | 产出量(文件/行) | 门禁三态 |
|---|---|---|---|---|
| 0 | 种子(跳过实测,见 _test/reports/test-a) | — | — | — |
| 1 | 种子(跳过实测,见 _test/reports/test-a) | — | — | — |
| 2 | market-supply-demand=done;competitor-analysis=done | 2A≈22 万;2B≈29 万(子代理token) | 3 文件/~500 行 | 预检通过→模拟答题(一次通过) |
| 3 | requirements-organizer=done;feature-breakdown(初估)=done | 阶段3≈54 万;QA预检≈32 万(子代理token) | 3 文件/~230 行 | QA 修复 5 项后通过→模拟答题(经修订通过) |
| 4 | tech-stack-selector=done;third-party-service-scout=done;回填校准=done(快检通过) | 架构师≈138 万;回填≈55 万(子代理token) | 3+2 修订/580 行 | 主代理预检通过→模拟答题(一次通过);回填 +11.6% 阈值内 |
| 5 | ux-flow-designer=done;app-ui-design=done(深度档 3 批) | UX≈27 万;UI≈288 万(生成 13 文件+CDN 校验往返,子代理token) | ux-flows+ui-spec+13 HTML/~2600 行 | 主代理预检通过→模拟答题(一次通过) |
| 6 | ai-dev-estimator=done | ≈35 万(子代理token) | 1 文件/~180 行 | 主代理预检通过→模拟答题 D-031/032(一次通过) |
| 7 | quotation-calculator=done | 商务≈59 万;QA≈39 万(子代理token) | 3 文件/~380 行 | QA 修复 4 项后通过→模拟答题(经修订通过) |
| 7-v2 回溯 | 三文档重出+服务器节增补 | 商务≈95 万(子代理token) | 4 修订+1 新建/~420 行 | v1.4 口径变更,模拟答题 D-040~043(一次通过) |
| 7-v3 回溯 | 报价按 ¥4,000 竞争档回溯 | 商务≈43 万(子代理token) | 2 修订+1 新建/~200 行 | 委托方指示,一次通过(D-044);发现并修正 v0.2 合计缺陷 |

## 项目进度(唯一事实源)
- 已完成阶段:**0–7 全部完成 + v1.5 口径回溯(最终报价 ¥4,000,周期 17 天,token 包月 ¥0,质量红线入单)**;共 44 决策、55 假设
- 进行中:—
- 下一动作:阶段 8 交付包(client-summary + ai-dev-handoff)可随时按 delivery-packager 技能生成
