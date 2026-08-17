---
name: tech-stack-selector
description: Construct 2–3 full-stack options, score them with adjustable weights, and recommend one with an architecture diagram and a risk list. Use at Stage 4 once the feature list exists; per-service cost scouting (including server/hosting) belongs to third-party-service-scout. 中文:技术栈多方案加权打分选型(含架构图与风险)。
version: 1.1
updated: 2026-08-17
---

# Skill: tech-stack-selector — 技术栈选型

## 目标
给出 2–3 套完整技术方案,量化对比后推荐一套,并产出架构图与风险清单。

## 执行流程
1. 明确选型约束:从项目画像与功能清单提取(团队技能、目标平台、性能要求、预算、上线时间)。
2. 构造 2–3 套候选方案,每套覆盖:前端、后端、数据库、部署方式、AI 能力接入方式(如涉及)。
3. 打分对比(每项 0–5):开发效率、生态成熟度、招聘/AI 训练语料充分度、运行成本、可扩展性、与 AI 开发的契合度;加权合计。
4. 推荐 + 理由 + 「为什么不用另外两套」。
5. 架构图:模块划分(前端/后端/数据/第三方)与数据流,mermaid 表达。
6. 技术风险:每条「风险 → 影响 → 缓解方案 → 备选方案」。

## 产出要求
- 路径:`docs/04-tech/tech-stack.md`,使用模板 `templates/tech-stack-report.md`。
- 若产品含 AI 功能,必须说明模型调用方式(API/开源自部署)及对应成本影响。

## 质量自检清单
- [ ] ≥2 套候选方案,打分表权重明确
- [ ] 推荐结论含「为什么不选其他」
- [ ] 架构图覆盖全部 P0 模块
- [ ] 每条技术风险有缓解与备选
