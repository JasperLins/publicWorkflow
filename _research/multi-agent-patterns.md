# 多代理(Multi-Agent)协作工作流设计模式调研报告

> 版本:v1.0 / 日期:2026-08-17 / 状态:已确认(调研完成) / 作者:工作流调研员(子代理)
> 目的:为本框架(主代理编排 9 角色子代理、8 阶段流水线、阶段门禁+批量提问、记忆三文件、12 技能库、产出落盘 docs/)提供可落地的优化点。
> 方法:联网检索 + 原文抓取(Anthropic / OpenAI / LangChain / MetaGPT / CrewAI / AutoGen 官方文档与论文,优先 2024-2026 资料)。所有要点均附来源;二手转述数据已标注置信度。

---

## 一、来源清单与核心机制摘要

### 1. Anthropic《Building Effective Agents》(2024-12-19)
URL: https://www.anthropic.com/engineering/building-effective-agents

- **工作流 vs 代理二分法**:Workflows = LLM 按预定义代码路径编排(我们的框架属此类);Agents = LLM 动态自主决定流程。**可预测、结构化任务应优先用 Workflow,只有开放性任务才需要自主 Agent**。
- **五种模式**:① Prompt chaining(链式+门禁检查)② Routing(分类路由到不同提示/模型)③ Parallelization(分段 sectioning / 投票 voting)④ **Orchestrator-workers**(中央 LLM 动态分解、委派、综合——适合子任务不可预测的场景)⑤ **Evaluator-optimizer**(生成者+评审者循环迭代,适合有明确评价标准、单次产出不够好的任务,如翻译、复杂文档)。
- **从简原则**:最成功的团队用"简单可组合的模式"而非复杂框架;先优化单次 LLM 调用,确有收益再加复杂度。
- **ACI(代理-计算机接口)**:像设计人机界面一样设计工具与提示——给工具写清晰描述、示例、边界;格式选择要防错(poka-yoke,如绝对路径优于相对路径)。
- **代理的代价**:自主性 = 错误复利放大,必须沙箱测试 + 护栏。

### 2. Anthropic《How we built our multi-agent research system》(2025-06)
URL: https://www.anthropic.com/engineering/multi-agent-research-system

- **Orchestrator-worker 架构**:Lead agent 分析查询 → 制定策略并**存入记忆** → 派生并行 subagent(各自独立上下文窗口)→ subagent 回传**浓缩结论**(非全文)→ lead 综合,必要时追加派生;最终 CitationAgent 标注来源。
- **委派质量决定一切**:早期因委派指令模糊,出现"琐碎查询派生 50 个子代理"、三个子代理重复研究同一芯片供应链等问题。解法:每个子任务必须带**目标 + 输出格式 + 工具指引 + 明确边界**四要素。
- **工作量按复杂度显式缩放**:提示词中嵌入 effort-scaling 规则(简单事实 1 个代理,复杂研究 10+ 个),教"先广后窄"搜索策略。
- **Token 经济学**:token 用量解释了 BrowseComp 上 80% 的性能方差;多代理比单代理性能高 90.2%,但 token 消耗约为对话的 15 倍——**只对高价值、可并行任务划算**。
- **评测与生产工程**:小样本起步(约 20 条真实查询即可发现大问题);LLM-as-judge 按评分细则(准确性/完整性/来源质量/工具效率)评**最终状态**而非固定步骤;持久化执行(checkpoint/断点续跑而非全量重启);全链路 tracing。

### 3. OpenAI Agents SDK(承继 Swarm):handoffs、guardrails、manager 模式
URL: https://openai.github.io/openai-agents-python/agents/ (Swarm 为其实验前身,handoff 概念由此而来)

- **两种多代理模式**:**Manager(agents-as-tools)**——中央编排者以工具形式调用子代理,子代理结果作为工具输出返回,**编排者始终保留对话控制权**(与我们"主代理唯一出口"一致);**Decentralized handoffs**——被移交代理获得全部对话历史并完全接管(适合 triage→专家 流程,我们框架不采用)。
- **Guardrails 双闸**:input guardrails(用户输入进入前校验,如相关性筛查)与 output guardrails(最终产出校验),与主流程并行运行。
- **暴露子代理要配 `as_tool` 式清晰描述**:工具名+工具描述决定编排者能否正确路由。

### 4. LangGraph:supervisor / 图状态机编排
URL: https://reference.langchain.com/python/langgraph-supervisor 、https://www.langchain.com/langgraph

- **Supervisor 模式**:图中一个中央 supervisor 节点路由任务给专职 worker 节点,共享状态(State)在图中流转;官方 `create_supervisor` / `langgraph-supervisor` 库封装了"规划→路由→收集→再路由"循环。
- **图 = 显式状态机**:节点(角色)+ 边(转移条件)+ 状态(共享黑板),天然支持条件分支、循环、回滚;比自由对话可控、可调试。
- **状态管理是难点**:社区反馈共享状态在 supervisor→子图间传递时易出一致性问题;建议状态 schema 显式化。
- **五种编排模式对比**(supervisor / swarm / 层级 / fan-out 等,参见 https://www.digitalapplied.com/blog/multi-agent-orchestration-5-patterns-that-work ):supervisor 路由准确但延迟集中,fan-out 并行快但合并难。

### 5. MetaGPT(ICLR 2024):SOP 编码 + 角色流水线(与我们框架最相似)
URL: https://arxiv.org/html/2308.00352v6 、https://github.com/foundationagents/metagpt ("Code = SOP(Team)")

- **SOP 编码为提示序列**:把人类标准作业程序写进提示词,用流程纪律替代代理即兴发挥——这是其核心创新,与我们的 AGENTS.md+workflow 完全同构。
- **角色流水线**:Product Manager(PRD)→ Architect(设计文档/接口定义)→ Project Manager(任务分配)→ Engineer(代码)→ QA(测试用例);每个角色有 profile/goal/constraints/专属工具,ReAct 式"观察-行动"。
- **结构化产物 = 角色间接口**:代理之间传递**文档**(PRD、设计图、接口定义),而非对话;"结构化产物包含全部必要信息,防止无关或缺失内容",显著抑制级联幻觉。
- **发布-订阅消息池**:所有结构化消息进共享池,角色**只订阅与自己相关的消息**,前置依赖到齐才激活——既共享又防信息过载。
- **可执行反馈闭环**:代码跑测试、失败重试(≤3 次)使 MBPP Pass@1 +5.4%,人工修正成本从 2.25 降至 0.83;消融实验证明**增加角色(流水线分细)一致提升质量**。

### 6. CrewAI:sequential / hierarchical process 与任务交接
URL: https://docs.crewai.com/v1.15.15/en/concepts/processes 、https://docs.crewai.com/v1.15.6/en/learn/hierarchical-process 、https://docs.crewai.com/v1.15.6/en/learn/sequential-process

- **Sequential**:任务逐一执行,**前一任务输出作为上下文注入下一任务**(对应我们的阶段 3 需求→功能串行);即使串行,`allow_delegation=True` 仍允许同组交接。
- **Hierarchical**:自动生成(或指定)manager agent,**负责规划、委派、验证输出、未通过则迭代重做直至完成**——即"管理者既是编排者又是质检员"。
- **已知坑**(GitHub issue #4783、社区论坛):manager 可能**委派给错误角色**、或该委派不委派;manager 自带工具受限。教训:委派需要显式的角色-任务匹配约束。

### 7. AutoGen(Microsoft):group chat 与 human-in-the-loop
URL: https://microsoft.github.io/autogen/stable//user-guide/agentchat-user-guide/tutorial/human-in-the-loop.html 、https://microsoft.github.io/autogen/0.2/docs/tutorial/human-in-the-loop/

- **human_input_mode 三档**:NEVER / TERMINATE(默认,**仅在满足终止条件时才请求人类介入**,人类若拦截回复则对话继续)/ ALWAYS——把人类介入成本降到最低且时机明确。
- **终止条件可组合**:TextMentionTermination(关键词如 TERMINATE)、MaxMessageTermination、HandoffTermination(代理主动交还人类)等,可用 `|`/`&` 组合。
- **Group chat 由 group manager 选 speaker**,配合 UserProxyAgent 实现人机协作;社区痛点是"何时停"——需要显式终止策略。
- 对我们的启示:人类介入应设计为**门禁触发式(默认 TERMINATE 档)+ 可组合终止/回退条件**,而非随时插话。

### 8. MAST:《Why Do Multi-Agent LLM Systems Fail?》(NeurIPS 2025)
URL: https://arxiv.org/abs/2503.13657 (PDF: https://arxiv.org/pdf/2503.13657 )

- **14 种失败模式 / 3 大类**:① 规格缺陷(角色/提示/工作流定义不清)② 代理间错位(inter-agent misalignment,互相误解对方输出与意图)③ **任务验证失败**(结果无人/无力校验)。
- 1600+ 条真实轨迹标注(7 个主流框架);LLM-as-judge 标注管线与人工标注高度一致(可复用于我们复盘)。
- 核心结论:**加代理收益甚微,改规格/验证收益大**;"第一步干预有效但完成率仍低",需要系统性设计改进。
- 二手数据(置信度中,来自 FutureAGI 等转述,非论文原文):生产环境多代理系统失败率 41–87%——见 https://futureagi.substack.com/p/why-do-multi-agent-llm-systems-fail 。

### 9. LangChain《How and when to build multi-agent systems》(2025-06, Harrison Chase)
URL: https://www.langchain.com/blog/how-and-when-to-build-multi-agent-systems

- **上下文工程 > 提示工程**:动态供给模型正确上下文是"构建代理工程师的第一要务";Anthropic 的记忆模式 = 阶段完成后总结、存外部记忆、**派生全新干净上下文的子代理**、靠精细交接维持连续性。
- **读可并行,写不可并行**:研究类(read-heavy)多代理容易成功;写作/编码类(write-heavy)冲突难调和——"行动隐含决策,冲突的决策带来坏结果";Anthropic 刻意把**最终报告写作保留在单一主代理**。
- **多代理 vs 长上下文**:多代理本质是 token 规模化手段,适合广度优先、可独立并行的方向;低价值任务不划算。
- **可观测性 + 持久化执行**为生产必备;评测小样本起步。

### 10. Cognition《Don't Build Multi-Agents》(2025-06, 反方视角)
URL: https://cognition.com/blog/dont-build-multi-agents

- **两大原则**:① **共享完整上下文**(share full agent traces, not just individual messages)② **行动隐含决策**——并行的多个决策者做出互相冲突的隐式假设,产出必然互相矛盾(Flappy Bird 示例:小鸟与背景画风不匹配)。
- **教训:决策与执行不可拆分**(edit-apply 模型失败案例):让 A 描述、B 执行,微小歧义即失败;应让同一模型决策+执行。
- **长任务的解法不是拆代理,而是上下文压缩**:专职压缩模型把历史蒸馏为"关键细节、事件、决策"。
- **子代理的合理用法**:窄范围、只读、不并行(调查/答问),避免污染主线程。
- 与我们框架的关系:我们的子代理是"写文档"而非"写共享代码",各写各的 docs 文件、由主代理转发交接,恰好规避了"并行写同一产物"的坑——但**隐式假设冲突**风险依然存在(见建议 11)。

---

## 二、可移植到我们框架的改进建议(14 条)

> 建议均基于现有形态增量改造,不推翻重来。标注:【来源】【改造点】【预期收益】。

### 建议 1:启动契约升级为"委派四要素"(目标+输出格式+输入+边界)
- 【来源】Anthropic 多代理研究系统(委派模糊导致重复劳动/派生爆炸);MAST 规格缺陷类失败。
- 【改造点】`roles/README.md` 统一启动指令模板:在「本次任务」区新增两行——`边界(明确不做什么/排除项)` 与 `完成标准(对应 workflow 阶段完成标准)`;`AGENTS.md` 第五节启动契约同步补"任务边界"。
- 【预期收益】直接消灭最高频失败模式(子代理跑题、重复上游已做内容),减少重试 token。

### 建议 2:门禁前加"轻量预检"——把 doc-quality-reviewer 前置为阶段质检员
- 【来源】MAST"任务验证失败"类;CrewAI hierarchical(manager 职责含 validate outputs + 未通过则迭代);Anthropic LLM-as-judge(评最终状态)。
- 【改造点】`workflow/README.md` 各🔒门禁阶段:批量提问**之前**,主代理(或提示词优化员子代理)用 skill `doc-quality-reviewer` 按该阶段「完成标准」逐条自检产出文档;不合格项就地修一轮,再进入批量提问。`AGENTS.md` 第四节工作流表加"阶段预检"列。
- 【预期收益】用户看到的每版都是过了自检的;把"用户发现问题→回滚重做"的昂贵循环替换为"机器预检→自动修正"的廉价循环。

### 建议 3:给每份产物定义"结构化文档头契约"(机器可读摘要)
- 【来源】MetaGPT(结构化产物=角色间接口,包含全部必要信息);LangChain(上下文工程:给下游注入正确上下文而非全文)。
- 【改造点】`templates/` 所有模板统一增加头部 front-matter 区:`关键结论(≤5条) / 关键假设与置信度 / 对下游的输入承诺(哪些数字可被引用) / 未决问题`。`AGENTS.md` 第八节文档规范补此要求;`memory/outputs-index.md` 的一句话摘要可由该头自动导出。
- 【预期收益】下游子代理启动时只注入上游文档头而非全文,token 显著下降;代理间错位(引用了不存在的数字)从结构上被抑制。

### 建议 4:技能内嵌"工作量缩放规则"(effort scaling)
- 【来源】Anthropic(1 个代理做简单事实、10+ 做复杂研究的显式规则;token 15 倍经济学)。
- 【改造点】各 `skills/*/SKILL.md` 增加一节「投入缩放」:按项目画像复杂度分 2–3 档(如 competitor-analysis:概念期查 3 个竞品 / 成熟市场查 5–8 个 + 定价表;third-party-service-scout:每类服务查 2 个 vs 4 个备选)。缩放档位由主代理依据阶段 1 结论在启动契约中指定。
- 【预期收益】避免小项目跑重型调研、大项目调研不足;token 消耗与项目价值匹配,直接落实第九节节约规范。

### 建议 5:阶段内检查点——支持"从断点续跑"而非重跑整阶段
- 【来源】Anthropic(checkpoint/resume 替代全量重启);LangChain(durable execution)。
- 【改造点】`memory/outputs-index.md` 每阶段登记细粒度子任务状态(如阶段 2:market-supply-demand=done, competitor-analysis=pending);`workflow/README.md` 通用规则补一条:会话中断恢复时,读 outputs-index 直接从 pending 子任务续跑,已 done 产物不重做。
- 【预期收益】长流水线(8 阶段跨多次会话)的崩溃韧性;中断恢复成本从"整阶段"降到"单个子任务"。

### 建议 6:对高价值文档引入 evaluator-optimizer(生成-评审)双循环
- 【来源】Anthropic 五模式之 evaluator-optimizer(有明确评价标准+迭代可改善时用);MetaGPT 可执行反馈(重试使修正成本 2.25→0.83)。
- 【改造点】选定 2–3 份对外关键文档试点(报价单、需求文档、AI 开发计划):主代理生成后,启动一次轻量评审(用 `doc-quality-reviewer` 按"数字可追溯/假设显式/格式合规"评分细则),低于阈值则带评审意见重生成一轮(上限 1 次)。落点:`workflow/README.md` 阶段 3/6/7 完成标准。
- 【预期收益】用户可直接发甲方的文档质量抬升;评审-修订一轮的边际成本远低于用户返工。

### 建议 7:建立输入/输出双 guardrail 检查单
- 【来源】OpenAI Agents SDK(input/output guardrails 与主流程并行);Anthropic(ground-truth 信号)。
- 【改造点】`workflow/README.md` 每阶段开头加"输入闸"三问(上游文档状态=已确认?项目画像未过期?决策日志无未消解冲突?);产出落盘前加"输出闸"(模板齐备?数字均有计算过程?来源与置信度已标?)。可做成 `skills/` 内一个极简 checklist 段落并入现有模板,不必新增技能。
- 【预期收益】防止"垃圾进垃圾出"沿流水线传播;两个闸都是主代理自查,零额外子代理成本。

### 建议 8:订阅式上下文注入——角色文件声明"输入订阅清单"
- 【来源】MetaGPT 发布-订阅消息池(角色只订阅相关消息,防信息过载);LangChain 上下文工程。
- 【改造点】`roles/*.md` 的「协作接口」区统一增加「输入订阅」字段:明确列出该角色**只**需要读的上游文档(如 architect 只订阅 03-requirements/* + decisions.md,不读 02-market 全文)。主代理组装启动提示词时按此清单注入(优先注入文档头,见建议 3)。
- 【预期收益】每次子代理注入的上下文从"全部上游"缩到"角色相关",token 与错位风险同时下降。

### 建议 9:decisions.md 扩展为"决策+假设"双账本
- 【来源】Cognition(行动隐含决策——冲突的隐式假设产生矛盾产物);MAST 代理间错位类失败。
- 【改造点】`AGENTS.md` 第七节 decisions.md 结构扩展两列:① 用户显式决策(现状)② **子代理显式声明的工作假设**(如商务顾问假设"人天单价按二线城市"、UI 设计师假设"移动端优先")。规则:子代理回传摘要中必须含"本次假设清单",主代理登记;启动下游子代理时把相关假设注入。假设被用户否决时与决策同流程处理。
- 【预期收益】跨阶段一致性(报价单与功能清单口径一致、原型与技术栈不冲突);用户一眼可见 AI 拍脑袋的地方,可集中裁决。

### 建议 10:失败重试协议升级——按 MAST 三分类对症下药
- 【来源】MAST(14 失败模式 3 大类;对症干预);CrewAI(manager 委派错角色教训)。
- 【改造点】`AGENTS.md` 第五节第 5 条"失败重试"细化为:主代理判定不合格时先归类——规格缺陷(改启动契约/任务描述再重试)、代理间错位(补注入正确上游文档头)、验证失败(给出具体不合规项清单);**重试提示必须携带归类后的具体修正指令**,禁止"再做好一点"式重试;仍失败第二次才升级为用户问题。
- 【预期收益】重试命中率提升(修正根因而非表象),避免两次重试浪费后仍升级。

### 建议 11:明确"并行只读、写入单点"的协作铁律
- 【来源】LangChain(read-heavy 可并行、write-heavy 不可;Anthropic 最终综合保留单一主代理);Cognition(并行写=冲突决策)。
- 【改造点】`AGENTS.md` 第五节第 3 条并行原则补一句:**并行子任务只允许产出相互独立的文档**;任何需要"合并/综合/修改他人产物"的动作一律由主代理(或单一指定角色)串行完成。阶段 2(两份独立报告)、阶段 4(两份独立文档)符合;未来若新增并行任务须先回答"产物是否互写"。
- 【预期收益】从制度上排除多代理并行写同一产物的冲突模式;现有设计已基本满足,补条文防未来退化。

### 建议 12:技能描述按"工具接口"标准打磨并定期重写
- 【来源】Anthropic ACI(工具描述投资回报巨大:重写工具描述使任务时间 -40%;poka-yoke);OpenAI(as_tool 的工具名+描述决定路由正确性)。
- 【改造点】`skills/*/SKILL.md` 的 frontmatter description 统一升级为"触发条件 + 适用边界 + 不适用情形"三段式,附 1 个调用示例;`roles/prompt-optimizer.md` 职责增加:每轮复盘时依据各技能实际被调用/误用记录,优先重写低效描述而非重写正文。
- 【预期收益】主代理路由到正确技能的命中率提高(减少用错技能导致的返工);技能库进化有了量化抓手。

### 建议 13:批量提问协议引入"终止/回退"语义与拦截机制
- 【来源】AutoGen(human_input_mode=TERMINATE 默认档:仅终止条件触发才请人;人类拦截回复则继续;终止条件可组合)。
- 【改造点】`AGENTS.md` 第六节格式模板中每题增加显式「回退项」选项(如"D. 本阶段该项推翻重做:____"),并在协议头部声明:用户任意一题的回复若与当前阶段结论冲突,主代理须先执行该阶段局部修订并复述影响,再继续其余题目——相当于 AutoGen 的"拦截后对话继续"。
- 【预期收益】用户单点异议不再导致整阶段含糊通过或全部回滚;修订影响被显式复述,减少误解。

### 建议 14:建立小样本评测循环,让复盘数据驱动技能进化
- 【来源】Anthropic(约 20 条真实样本即可发现大效应;LLM-as-judge 评终态;human testing 抓机器评不出的偏差);MAST(发布 LLM-as-judge 标注管线)。
- 【改造点】`memory/outputs-index.md` 每阶段登记行增加:门禁一次通过/经修订通过/回滚 三态 + 用户修改要点数;`roles/prompt-optimizer.md` 复盘时据此排序:优先修订"回滚率最高/修改要点最多"阶段对应的 SKILL.md。现有第九节 token 登记行合并为一张"阶段运行台账"。
- 【预期收益】框架自我进化从凭感觉变为凭数据;token 消耗记录与质量记录合并后,阶段 6 的 AI 预估也有了校准基线(呼应第九节第 5 条)。

---

## 三、优先级最高的 5 条(见回传摘要)

1. 建议 2(门禁前轻量预检)——质量与用户体验收益最大、实现最轻。
2. 建议 1(启动契约四要素)——一次性改一个模板,消除最高频失败根因。
3. 建议 3 + 8(文档头契约 + 订阅式注入)——上下文工程双件套,token 与错位双降。
4. 建议 9(决策+假设双账本)——直接治理跨阶段口径不一致。
5. 建议 4(技能工作量缩放)——成本可控性的最大杠杆。

---

## 附:全部引用链接

- Anthropic, Building Effective Agents: https://www.anthropic.com/engineering/building-effective-agents
- Anthropic, How we built our multi-agent research system: https://www.anthropic.com/engineering/multi-agent-research-system
- Anthropic, Demystifying Evals for AI Agents: https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
- OpenAI Agents SDK – Agents(多代理模式/handoffs/guardrails): https://openai.github.io/openai-agents-python/agents/
- OpenAI Cookbook – Multi-Agent Portfolio Collaboration: https://developers.openai.com/cookbook/examples/agents_sdk/multi-agent-portfolio-collaboration/multi_agent_portfolio_collaboration
- LangGraph Multi-Agent Supervisor: https://reference.langchain.com/python/langgraph-supervisor
- LangGraph 产品页: https://www.langchain.com/langgraph
- Multi-Agent Orchestration: 5 Patterns That Work: https://www.digitalapplied.com/blog/multi-agent-orchestration-5-patterns-that-work
- Supervisor vs Swarm 对比: https://focused.io/lab/multi-agent-orchestration-in-langgraph-supervisor-vs-swarm-tradeoffs-and-architecture
- MetaGPT 论文(ICLR 2024): https://arxiv.org/html/2308.00352v6
- MetaGPT GitHub: https://github.com/foundationagents/metagpt
- MetaGPT 官方文档: https://docs.deepwisdom.ai/main/en/guide/get_started/introduction.html
- IBM – What is MetaGPT: https://www.ibm.com/think/topics/metagpt
- CrewAI Processes 概览: https://docs.crewai.com/v1.15.15/en/concepts/processes
- CrewAI Hierarchical Process: https://docs.crewai.com/v1.15.6/en/learn/hierarchical-process
- CrewAI Sequential Process: https://docs.crewai.com/v1.15.6/en/learn/sequential-process
- CrewAI 委派错角色社区案例: https://community.crewai.com/t/manager-agent-delegates-task-to-wrong-agent-in-a-hierarchical-process/3179
- AutoGen Human-in-the-Loop(0.4+): https://microsoft.github.io/autogen/stable//user-guide/agentchat-user-guide/tutorial/human-in-the-loop.html
- AutoGen Human-in-the-Loop(0.2): https://microsoft.github.io/autogen/0.2/docs/tutorial/human-in-the-loop/
- MAST – Why Do Multi-Agent LLM Systems Fail?: https://arxiv.org/abs/2503.13657
- LangChain – How and When to Build Multi-Agent Systems: https://www.langchain.com/blog/how-and-when-to-build-multi-agent-systems
- Cognition – Don't Build Multi-Agents: https://cognition.com/blog/dont-build-multi-agents
- (二手,置信度中)FutureAGI – Why Do Multi-Agent LLM Systems Fail: https://futureagi.substack.com/p/why-do-multi-agent-llm-systems-fail
- (二手,置信度中)Galileo – Why Multi-Agent Systems Fail: https://galileo.ai/blog/why-multi-agent-systems-fail
