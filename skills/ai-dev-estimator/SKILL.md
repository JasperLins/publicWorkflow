---
name: ai-dev-estimator
description: Plan AI-agent development: task packages, batch scheduling on the real AI dev rhythm (coding is fast, testing & bug-fixing dominate), and three-tier token volume estimates for code-plan quota planning (NOT priced by default). Use at Stage 6 after tech stack and prototype are final; pricing/profit belongs to quotation-calculator. 中文:AI 开发周期与 token 量预估(包月口径,测重于码)。
version: 1.2
updated: 2026-08-17
---

# Skill: ai-dev-estimator — AI 开发周期与 token 预估

> v1.2 变更(依据委托方反馈 TODO-1/2):周期模型改「AI 开发节奏」——编码只占 30–40%,测试+bug 修复+联调占 40–50%,小项目总周期锚定 2–3 周;token **默认包月 code plan 口径不计价**,三档量预估用于配额规划与消耗/产出比。

## 输入依赖
- `docs/03-requirements/feature-list.md`(回填校准后)、`docs/04-tech/tech-stack.md`、`docs/05-uiux/ui-spec.md` + `UI/`(复现基准)
- `memory/outputs-index.md` 台账(实测 token 校准);委托方 code plan 配额(未知则标「待填」)

## 执行流程
1. **任务包拆分**:子任务组装为 AI 可执行任务包(每包一个可验收交付物);标注依赖与可并行组。
2. **周期(AI 开发节奏模型)**:
   - 时间结构:**编码 30–40% / 测试+bug 修复+联调 40–50% / 评审与集成 ~20%**——必须写明「测试修复是主要耗时」,禁止按纯编码速度排期。
   - 周期锚定表:≤30 子任务 → **2–3 周**;30–60 → 4–6 周;>60 → 6–10 周;并行可压缩,压缩比例写明假设。
   - 本项目周期 = 锚定表 × 难度/并行修正,给出乐/中/保三档(工作日+日历天双列)。
3. **token 三档(量,不默认折价)**:
   - 校准链条:台账实测 token ÷ 实测产出行数 = 基线 → 编码调整系数 → 预估 token/有效行 × 预估代码行 = 总量(两路复算闭合)。
   - 费用列改**「配额占比%」**(= 三档 token ÷ code plan 月配额;配额未知标「待填」);**仅当委托方声明按量 API 时**才按单价折算费用并注明来源。
4. **人机分工**:AI 独立 / AI 起草+人工评审 / 人工主导(真机联调、密钥配置、评测集采集等);原型复现基准用法。
5. **质量门禁**:每批次 DoD(构建通过/自测用例/与 UI 原型一致性)。
6. **对比**:与传统人日对比(提效倍数+前提;人工不减项诚实列出:评审、真机、上架等待)。

## 产出要求
- 路径:`docs/06-ai-plan/ai-dev-plan.md`,模板 `templates/ai-dev-plan.md`(含校准推导小节),文档头契约节。

## 质量自检清单
- [ ] 任务包有验收标准与并行组;周期按 AI 节奏模型(测试占比 ≥40%)
- [ ] 周期落在锚定表区间或写明偏离理由;假设显式(每日有效时长/并行度/日历换算)
- [ ] token 三档为**量**+配额占比;按量折价仅在有声明时出现
- [ ] 校准链条可复算(台账比值→系数→预估,两路闭合)
- [ ] 提效对比列出人工投入不变部分

## CHANGELOG
- 1.2(2026-08-17):AI 开发节奏模型(编码 30-40%/测试修复 40-50%);周期锚定表(小项目 2–3 周);token 包月口径+配额占比列。依据:委托方 TODO-1/2。
- 1.1(2026-08-17):校准推导小节、周期假设句式、自检补 2 条。
- 1.0(2026-08-15):初版。
