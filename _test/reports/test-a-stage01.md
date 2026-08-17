# 冒烟测试报告 A:阶段 0(记忆初始化)+ 阶段 1(头脑风暴)

> 版本:v1.0 | 日期:2026-08-17 | 状态:已确认 | 作者:框架冒烟测试员(扮演项目经理)
> 示例想法:中小企业采购快速决策计算器 App | 沙盒:`D:\createIdear\Framework\_test\`(框架本体 memory/ 与 docs/ 未改动)

---

## 一、执行摩擦清单

> 严重度定义:阻塞 = 代理无法在不自行违规推断的情况下继续;建议 = 可推断绕过,但会造成不同代理执行结果不一致或体验损耗。

| # | 位置(文件+章节) | 严重度 | 问题描述 | 具体改法 |
|---|---|---|---|---|
| 1 | AGENTS.md 总原则 4「模板驱动」 × templates/ 目录 | 建议(高) | 铁律要求「所有文档必须基于 templates/ 中的模板生成,不得自创结构」,但 templates/ 仅有 7 个模板,**阶段 1 的 ideas.md 无对应模板**(另缺:feasibility、ux-flows、cost-profit、framework-retro)。skill 内嵌了产出结构可兜底,但与总原则字面冲突,严格守规的代理会陷入「不得自创结构 vs 无模板可用」的两难 | 二选一:① 补齐 `templates/brainstorm-ideas.md` 等缺失模板;② 在总原则 4 追加一句「SKILL.md 已定义产出结构的,以 SKILL.md 为准」 |
| 2 | skills/brainstorm-facilitator/SKILL.md 执行流程 3 | 建议(高) | 打分规则自相矛盾:「实现难度(0-5,**越低越好**)…算总分排序」——若四项直接求和,难度 5(最难)反而贡献 5 分,「越低越好」语义丢失。本次被迫自行修正为「难度得分 = 5 − 难度等级」并在文档中声明(见 ideas.md 第 4 节),不同代理可能采用不同修正法,打分结果不可比 | 改为「总分 = 需求强度 + 差异化 + 商业潜力 − 实现难度」或明确「难度得分 = 5 − 难度等级」,并附一行示例计算 |
| 3 | roles/project-manager.md 职责 5「待议池」 × 记忆模块/产出结构 | 建议 | 角色要求超范围新想法「先记入待议池」,但 memory/ 四文件清单(AGENTS.md 第七节)无待议池文件,SKILL.md 产出结构也无该章节,机制无落地位置。本次权宜放在 ideas.md 第 6 节自创章节 | 在 ideas.md 产出结构中增加「待议池」节,或 memory/ 增设 `backlog.md` 并登记入第七节文件表 |
| 4 | AGENTS.md 第七节 × workflow/README.md 阶段 0 | 建议 | 进度信息双源:profile「当前阶段」与 outputs-index「项目进度」语义重复,无一致性校验。沙盒实测即不一致(profile 预置「第 5 阶段」,index 为空),恢复时无所适从 | 规定 outputs-index 为唯一进度源,profile 删除「当前阶段」节;或阶段 0 步骤增加「对齐两处进度」动作 |
| 5 | workflow/README.md 阶段 0「初始化」 | 建议 | 初始化语义未定义:框架 memory/ 三文件即模板(含「示例行,初始化后删除」),未说明初始化=清除示例行原地转正,还是另行复制;「画像已确认而 index 为空」这类部分初始化状态的恢复分支缺失(只能判断「全空/有内容」) | 阶段 0 补两句:「初始化 = 清除模板示例行,三文件原地启用」;「三文件任一非空即视为恢复,进度以 outputs-index 为准,冲突时向用户确认」 |
| 6 | skills/brainstorm-facilitator/SKILL.md 自检清单第 1 条 | 轻微 | 「创意 ≥12 条且覆盖四个维度」不可机械验证:未要求逐条标注四维,验收靠主观。本次自行在全景表设「目标人群/场景/痛点/解决方式」四列解决 | 产出要求中明确「创意全景表须含四维度列」 |
| 7 | skills/brainstorm-facilitator/SKILL.md 执行流程 5 × AGENTS.md 第六节 | 轻微 | 批量提问的「每题必标推荐项及理由」要求只存在于 AGENTS.md 第六节,skill 第 5 步只说「按批量提问格式整理」,需跨文件对照才能合规 | skill 第 5 步补「每题含推荐项与一句话理由」 |
| 8 | memory/README.md 读写纪律 3 × profile「决策摘要」 | 轻微 | 决策需双写(decisions.md 全量 + profile 决策摘要),但「影响画像的决策」入摘要判据模糊,长会话中易漏写或过度写入 | README 给出判据,如「改变范围边界/目标人群/商业模式的决策才入画像摘要」 |

引用断链检查(未发现问题):roles/project-manager.md → workflow/README.md ✓;skill → docs/01-brainstorm/ideas.md 路径 ✓;AGENTS.md 角色注册表 → roles/、skills/ 实际文件 ✓;memory/README → 三数据文件 ✓。

## 二、执行统计

- **读取文件(9 个)**:AGENTS.md(注入)、roles/project-manager.md、skills/brainstorm-facilitator/SKILL.md、memory/README.md、memory/project-profile.md、memory/decisions.md、memory/outputs-index.md、workflow/README.md(角色文件引用,必读)、_test/memory/project-profile.md
- **产出文件(6 个,合计 180 行,不含本报告)**:
  - 新建:_test/memory/decisions.md(16 行)、_test/memory/outputs-index.md(21 行)、_test/docs/01-brainstorm/ideas.md(84 行)、_test/docs/01-brainstorm/questions-stage1.md(38 行)、_test/reports/test-a-stage01.md(本报告)
  - 修订:_test/memory/project-profile.md(+1 行 D-003)
- **冗余部分**:AGENTS.md 第四节阶段表与 workflow/README.md 各阶段条目高度重叠(意图为总-分结构,可接受);批量提问格式在 AGENTS.md 与角色文件各出现一次(轻微冗余);profile「当前阶段」与 index「项目进度」为有害冗余(见摩擦 #4)
- **缺失部分**:阶段 1 模板(摩擦 #1)、待议池落地(摩擦 #3)、打分公式(摩擦 #2)、部分初始化的恢复规则(摩擦 #5)
- **Token 记录**:已在 _test/memory/outputs-index.md 按第九节登记阶段 0/1 两行

## 三、结论

**该链路「可直接用」**(附条件)。0 个阻塞级卡点,阶段 0+1 全流程可依现有指令完整走通,自检清单在补四列表头后全部可验证。但为保证多代理执行一致性与严格守规代理不被摩擦 #1/#2 绊住,建议在正式启用前完成 3 项高优先修复:① 补模板或加模板豁免条款;② 修正打分公式;③ 待议池落地。
