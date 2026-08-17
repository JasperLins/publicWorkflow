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

## 阶段运行台账(token 按 skill 粒度)
| 阶段 | 子任务状态(done/pending) | token 估算 | 产出量(文件/行) | 门禁三态 |
|---|---|---|---|---|
| 0 | 种子(跳过实测,见 _test/reports/test-a) | — | — | — |
| 1 | 种子(跳过实测,见 _test/reports/test-a) | — | — | — |
| 2 | market-supply-demand=done;competitor-analysis=done | 2A≈22 万;2B≈29 万(子代理token) | 3 文件/~500 行 | 预检通过→模拟答题(一次通过) |
| 3 | requirements-organizer=done;feature-breakdown(初估)=done | 阶段3≈54 万;QA预检≈32 万(子代理token) | 3 文件/~230 行 | QA 修复 5 项后通过→模拟答题(经修订通过) |

## 项目进度(唯一事实源)
- 已完成阶段:0、1(种子)、2、3(门禁已过:D-011~018;BL-003/004 转二期)
- 进行中:阶段 4 · 技术栈与第三方服务
- 下一动作:架构师技术栈+第三方成本 → 全栈工程师回填校准工时(A-017/A-018 在此校验)
