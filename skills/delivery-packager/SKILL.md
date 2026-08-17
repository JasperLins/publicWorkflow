---
name: delivery-packager
description: Compose the two final deliverables by aggregating all document-header contracts — a client-facing confirmation sheet (features, quote, decisions needed) and a single-file AI-dev handoff pack (everything an AI coding agent needs to start). Use at Stage 8 after Stage 7 gate passes; do NOT re-derive numbers, only aggregate and reference. 中文:生成客户确认单+AI 开发移交包(聚合不重算)。
version: 1.0
updated: 2026-08-17
---

# Skill: delivery-packager — 交付包生成(客户确认单 + AI 开发移交包)

> v1.0(2026-08-17):依据委托方反馈 TODO-4 新增。原则:**聚合不重算**——所有数字与结论一律引用上游文档头契约,发现矛盾即停止并报告项目经理。

## 输入依赖(全为「已确认」状态)
- 全部 `docs/01–07` 产出的「📌 文档头契约」节(按 memory/outputs-index.md 索引逐份读取)
- `memory/decisions.md`(生效决策 D-xxx 与假设 A-xxx)、`memory/backlog.md`
- `./UI/`(原型入口)

## 执行流程
1. **客户沟通确认单** → `docs/07-business/client-summary.md`(模板 `templates/client-summary.md`):
   - 功能摘要(P0/P1/P2 计数 + 每条 P0 一句验收要点;范围外项=不做清单+待议池去向)
   - 报价与付款里程碑(引用 quotation.md 结论)
   - **客户待确认事项**:全部未决问题 + 需甲方拍板项(账号归属/费用归属/内容口径/保修期等)
   - 交付物清单与不含项;纯甲方视角——**零内部数字、零注释、零内部文件路径**(引用用「详见附件《报价单》」式表述)
2. **AI 开发移交包** → `docs/08-handoff/ai-dev-handoff.md`(模板 `templates/ai-dev-handoff.md`):
   - 一段式总装:项目一句话 → 技术栈结论(含部署形态)→ 任务包/批次/DoD → 界面清单+原型入口(`UI/index.html`)→ 关键决策 D-xxx(逐条一行)→ 生效假设 A-xxx(逐条一行,标注需运行时校验项)→ 验收标准与风险/预研
   - **目标:AI 开发代理只读此一个文件即可开工**;每节末附「深读指引」(上游文档路径)
3. 自检后回传:两文件路径 + 引用一致性声明 + 待决策问题(如有)。

## 质量自检清单
- [ ] client-summary 零内部数字/零注释/零内部路径(独立 grep 扫描)
- [ ] 所有数字与上游头契约一致(聚合未重算)
- [ ] handoff 含全部生效 D/A 编号与原型入口,单文件可开工
- [ ] 客户待确认事项覆盖全部未决问题
