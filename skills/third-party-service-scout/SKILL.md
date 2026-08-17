---
name: third-party-service-scout
description: Map required third-party services (payments/SMS/cloud/AI APIs), decide the deployment shape, and ALWAYS conclude server/hosting selection with a monthly cost bottom line (or an explicit "no server needed + why"). Use at Stage 4 when the tech plan is forming; overall tech-stack selection belongs to tech-stack-selector. 中文:第三方服务调研+服务器选配+月费结论。
version: 1.2
updated: 2026-08-17
---

# Skill: third-party-service-scout — 第三方服务与成本调研

> v1.1 变更:description 规范化;新增投入缩放档。

## 输入依赖
- `docs/03-requirements/feature-list.md`(P0/P1 需求的第三方依赖来源;缺失即阻塞)

## 执行流程
0. **部署形态判定(必做,决定服务器结论)**:独立服务器 / Serverless(函数计算) / 纯静态托管 / 纯客户端无后端——依据技术栈与数据架构;判定结果写入产出第 0 节。
1. **需求映射**:从功能清单逐条推导所需第三方能力(支付、短信/验证码、推送、地图、对象存储、CDN、AI 模型 API、语音/OCR、审核合规等)。
2. **候选与选择**:每类服务列 1–3 家候选(优先主流:支付宝/微信支付、阿里云/腾讯云、主流大模型 API 等),按稳定性、价格、接入难度选择并说明理由。
3. **服务器与托管(必填小节,不可省略)**:按第 0 步形态给出——选配结论(规格/厂商/月费,含域名/SSL/备案/对象存储/CDN/数据库按需)或「**无需独立服务器 + 理由**」(如 Serverless 按量/纯静态/无后端);**「费用结论」行必填**:月度总费用区间一句线。
4. **用量假设**:按项目画像预估用量(如日活 × 次数),写明假设式。
5. **成本测算**:每项「免费额度内 / 预估月费」两档;单价注明来源与查询日期。
6. **汇总**:月度固定成本合计 + 随用量增长的可变成本公式(供敏感性分析)。

## 产出要求
- 路径:`docs/04-tech/third-party-services.md`,使用模板 `templates/third-party-services.md`,含文档头契约节。
- 表格列:服务类型 | 供应商 | 用途 | 用量假设 | 免费额度 | 预估月费(币种) | 备选。

## 投入缩放
- **轻量**(纯本地/无第三方依赖):确认「无第三方依赖」并说明结论依据。
- **标准**:每类服务 1–2 家候选 + 月费两档。
- **深度**(成本敏感/用量大):每类 3 家候选 + 阶梯价 + 可变成本公式与盈亏平衡点提示。

## 质量自检清单
- [ ] 部署形态已判定,「服务器与托管」小节 + 费用结论行必填(含「无需服务器」时的理由)
- [ ] 功能清单每条 P0/P1 需求的第三方依赖均已覆盖
- [ ] 每项成本含用量假设式,可复算
- [ ] 单价有来源与日期
- [ ] 汇总有固定/可变成本区分
