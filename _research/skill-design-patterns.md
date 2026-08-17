# Agent Skills 与记忆/上下文工程最佳实践调研报告

- 版本:1.0
- 日期:2026-08-17
- 状态:草稿(供提示词优化员与项目经理评审)
- 作者:提示词工程调研员(子代理)
- 调研方式:联网检索 + 一手原文抓取(Anthropic 工程博客、Claude 平台文档、anthropics/skills 仓库、LangChain/Letta 博客、arXiv 论文等),优先 2024–2026 资料

---

## 一、来源清单与核心要点

### 主题 1:Anthropic Agent Skills 官方规范

**1.1 Equipping agents for the real world with Agent Skills(Anthropic 工程博客,2025-10)**
URL: https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills
- Skill = 一个目录,内含 `SKILL.md`;文件必须以 YAML frontmatter 开头,必填 `name` 与 `description`,这两项在启动时**常驻系统提示**,是 Claude 判断"何时触发该 skill"的唯一依据。
- **渐进披露(progressive disclosure)三层模型**:
  1. 元数据(name+description)——始终在上下文中;
  2. SKILL.md 正文——仅当 Claude 判定相关时才完整读入;
  3. 捆绑文件(脚本/参考文档)——按需加载,因此"可捆绑的上下文实际上无上限"。
- 当 SKILL.md 变得臃肿时,应拆分为多个文件并按名引用;互斥或很少同时用的内容分开存放(例:PDF skill 把表单填写说明放独立 `forms.md`,只在需要时加载)。
- 捆绑脚本可作为工具执行,无需把脚本本身读入上下文,获得"确定性可靠"(deterministic reliability)。
- 明确区分"让 Claude 执行脚本"还是"作为参考文档阅读"。

**1.2 Skill authoring best practices(Claude 平台官方文档)**
URL: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
- **name**:≤64 字符,仅小写字母/数字/连字符,不含空话填充词(如 "skill""tool")。
- **description**:≤1024 字符,**第三人称**,必须同时写清"它做什么"与"**何时使用**"(触发时机);触发关键短语可直接写入(如 "Use this skill when the user mentions…")。name/description 用英文以确保发现可靠性。
- 版本等自定义元数据放 `metadata` 对象(如 `metadata: { version: 1.0 }`),而非顶层自定义字段。
- SKILL.md **正文控制在 5000 词以内**;超过即拆分到捆绑参考文件。
- 指令用**命令式(imperative)**;解释"为什么"比堆砌硬性禁令有效;全大写 ALWAYS/NEVER 是写作失败的黄色信号。
- 好的 skill 应包含:精确输出模板、示例、逐步流程;对文件操作类技能强制使用相对路径、统一正斜杠。
- description 是"首要触发机制",Claude 有"欠触发"倾向,描述要写得主动(pushy)一些。

**1.3 skill-creator(anthropics/skills 仓库内的官方元技能)**
URL: https://raw.githubusercontent.com/anthropics/skills/main/skills/skill-creator/SKILL.md
- 目录解剖:`SKILL.md` + `scripts/`(可执行)+ `references/`(按需读的文档)+ `assets/`(模板/字体/图标)。多领域 skill 按变体拆参考文件(如 aws.md / gcp.md),只加载命中的那个。
- "何时使用"信息全部放 description,不放正文。
- 长度:SKILL.md **< 500 行**;参考文件 >300 行应加目录(ToC)。
- **评测流程**(可客观验证的 skill,如文件转换/数据提取类):
  1. 写完 SKILL.md 后立即写 2–3 个真实测试提示词,存 `evals/evals.json`;
  2. **有 skill / 无 skill(或旧版)并行双跑**,同回合记时(token 数、耗时存 timing.json);
  3. 断言字段固定为 `text` / `passed` / `evidence`;
  4. 汇总基准分,分析"无区分度断言"与"高方差评测";
  5. 迭代直到满意,再扩大测试集。
- **description 优化**:生成约 20 条真实触发查询(8–10 条应触发 + 8–10 条不应触发,负例选"近似未命中"而非明显无关),按 60/40 训练/测试分割选优,防止过拟合。
- 主观产出(如写作风格)通常不需要 evals;客观可验证产出必须有。
- 同一辅助逻辑在多次运行中被反复重写 → 应沉淀为 `scripts/` 捆绑脚本。
- 环境适配建议:无子代理能力的环境串行跑测试、跳过基线。

### 主题 2:AGENTS.md / CLAUDE.md 社区最佳实践(防指令过载)

**2.1 A Complete Guide to AGENTS.md(aihero.dev)**
URL: https://www.aihero.dev/a-complete-guide-to-agents-md
- 指令文件应**分层渐进披露**,而不是把所有内容堆进一个文件;聚焦的指令才能最大化代理性能,臃肿上下文会稀释注意力。

**2.2 AGENTS.md Spec Guide(morphllm.com)**
URL: https://www.morphllm.com/agents-md-guide
- AGENTS.md 是纯 Markdown,**无必填字段**;推荐只放:项目概览、构建/测试命令、代码风格、安全约束等**可操作内容**。

**2.3 Notes on AI Agent Rule/Context Files(GitHub gist, 0xdevalias)**
URL: https://gist.github.com/0xdevalias/f40bc5a6f84c4c5ad862e314894b2fa6
- CLAUDE.md/AGENTS.md 属于提示词的一部分,要**像高频使用的提示词一样持续打磨**;常见错误 = 不断追加内容导致提示过载——每个无关 token 都在降低响应质量。

**2.4 Hacker News: Evaluating AGENTS.md**
URL: https://news.ycombinator.com/item?id=47034087
- 社区共识:指令文件主要用于让代理**避免重复犯需要返工的错误**,而非微管理其行为。

**2.5 Common Mistakes in Configuring Coding Agents(arXiv)**
URL: https://arxiv.org/html/2606.15828v2
- 对真实 AGENTS.md/CLAUDE.md 文件的系统性分析,归纳典型配置错误(过载、含糊、不可执行等)。

**共同主题**:短而具体;只放可操作约束;嵌套文件按需加载;当作"活提示词"定期修剪;目标是消灭高频返工错误。

### 主题 3:上下文工程(Context Engineering)公认原则

**3.1 Effective Context Engineering for AI Agents(Anthropic 工程博客,2025)**
URL: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- **注意力是有限资源**;上下文越长,"context rot"使召回精度下降。总原则:"**找到实现目标所需的最小高信号 token 集合**"。
- 系统提示应在"过硬编码"与"过含糊"之间的黄金高度(Goldilocks zone);**从最小开始,观察到失败再增加指令**——而不是预先写一本百科。
- **按需检索优于预载**:代理持轻量引用(文件路径/链接),用时再取;混合模式(小而精的常驻指令 + 运行时导航)通常最优。
- **结构化笔记**：把状态写到上下文窗口之外(NOTES.md / 待办),跨上下文重置恢复长任务。
- **子代理架构**:子代理在干净上下文里干重活,只向主代理返回"浓缩摘要"。
- **压缩(compaction)**:超长任务用摘要重启,保留决策与未决问题,丢弃冗余工具输出。
- 总建议:"do the simplest thing that works"。

**3.2 Context Engineering for Agents(LangChain 博客)**
URL: https://www.langchain.com/blog/context-engineering-for-agents
- 四策略:**Write**(把上下文存到窗口外:草稿本/长期记忆)、**Select**(每步只拉回相关内容:读草稿、记忆检索、RAG)、**Compress**(摘要/修剪,Claude Code 在窗口 95% 时自动压缩)、**Isolate**(多代理各自窗口/沙箱,代价是 token 可达单代理 ~15 倍)。

**3.3 Context Engineering for AI Agents: Lessons from Building Manus(manus.im)**
URL: https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus
- 生产教训:代理系统中 **few-shot 示例可能被过度模仿**("don't get few-shotted"——模型会复制示例的领域而非方法);KV-cache 友好的上下文设计。

### 主题 4:LLM 代理长期记忆设计

**4.1 Agent Memory: How to Build Agents That Learn(letta.com)**
URL: https://www.letta.com/blog/agent-memory/
- MemGPT 范式:把上下文窗口当作**受限内存资源**,按操作系统式分层(驻留区 + 分页外存),自主换入换出。

**4.2 Memory Blocks: Agentic Context Management(letta.com)**
URL: https://www.letta.com/blog/memory-blocks/
- 记忆 = 带结构的**块(block)**:每块有 `label`(用途标识)+ `value`(内容)+ **大小上限**;分 **in-context / out-of-context** 两态,需要时才编译进上下文。
- **自编辑记忆**:代理通过记忆工具自己增改块(如把用户偏好写进 persona 块);核心块可设**只读**,只有开发者能改。
- 块可在多个代理间共享(共享知识库);"sleep-time compute" = 空闲期后台代理整理主代理记忆。
- 最佳实践:每块设字符/token 上限以控制上下文分配;固定小节(human 块 / persona 块)使行为可预测。

**4.3 Agent Memory Techniques(GitHub, NirDiamant)**
URL: https://github.com/NirDiamant/Agent_Memory_Techniques
- 实操目录:MemGPT、Mem0、Zep、**Reflexion**(把语言化自我反思存档供后续尝试使用)、写入/蒸馏/检索各模式,附代码示例。

**4.4 Benchmarking AI Agent Memory: Is a Filesystem All You Need?(letta.com)**
URL: https://www.letta.com/blog/benchmarking-ai-agent-memory/
- 基准对比各记忆架构;文件系统即记忆(目录+索引+按需读)在许多场景与专用系统打平——**对本框架是利好:文件式记忆是合理形态,关键是索引与检索规则**。

**4.5 HF Forum: How do you design memory systems for long-running AI agents?**
URL: https://discuss.huggingface.co/t/how-do-you-design-memory-systems-for-long-running-ai-agents/175584
- 关键规则:**不要让提示词本身充当记忆系统**;记忆外部存储、选择性检索。

**4.6 Agent Memory: Characterization and System Implications(arXiv)**
URL: https://arxiv.org/html/2606.06448v1
- 长时程任务中记忆的需求分类与系统设计含义。

### 主题 5:提示词可维护性(版本化 / 评测 / 回归)

**5.1 What is prompt versioning?(braintrust.dev)**
URL: https://www.braintrust.dev/articles/what-is-prompt-versioning
- 提示词像代码一样做版本管理:结构化追踪变更、可回滚、分层管理。

**5.2 LLM Prompt Testing and Regression Testing: A Practical Guide(Medium)**
URL: https://medium.com/@QuarkAndCode/llm-prompt-testing-and-regression-testing-a-practical-guide-e0d44de823cf
- 区分"测试预期行为"与"回归测试(新版是否破坏旧能力)";维护黄金测试集。

**5.3 Automated Prompt Regression Testing with LLM-as-a-Judge and CI/CD(traceloop.com)**
URL: https://www.traceloop.com/blog/automated-prompt-regression-testing-with-llm-as-a-judge-and-ci-cd
- 新版提示词跑标准测试集,与线上版对比评分,达标才部署(LLM-as-judge + 评分表)。

**5.4 Prompt Regression Testing Guide(futureagi.com)**
URL: https://futureagi.com/blog/prompt-regression-testing-2026/
- "提示词的 pytest"三模式:逐 rubric 断言、分层评测、与旧版**成对对比**。

**5.5 (Why) Is My Prompt Getting Worse?(arXiv)**
URL: https://arxiv.org/html/2311.11123v2
- 提示词变更对输出影响巨大,回归测试必须同时监控模型与提示词两个变量。

**共同主题**:版本化+变更日志;黄金测试集;LLM-as-judge/rubric 评分;改动前后成对对比;不达标可回滚。

---

## 二、对照我们框架的差距分析

对照物:`skills/app-ui-design/SKILL.md`、`skills/brainstorm-facilitator/SKILL.md`、`memory/README.md`、`AGENTS.md`(12 个 skill 均为 frontmatter name/description/version/updated + 正文"角色设定/执行流程/产出要求/自检清单"形态;memory 三文件 + 300 行蒸馏规则)。

### 2.1 对照 `skills/app-ui-design/SKILL.md`

| # | 业界规范 | 现状 | 差距 |
|---|---|---|---|
| A1 | description 必须写"何时使用/何时不用"(触发时机),是首要触发机制【1.2/1.3】 | description 只写了"做什么"+"调用角色:高级 UI 设计师" | 缺触发条件;"调用角色"是路由信息,对触发判断是噪音 |
| A2 | 指令用命令式、直接写给执行代理;避免嵌套提示词【1.2/1.3】 | 正文核心是一段 60 行的 ```text「主提示词」块,内含 `{项目/产品名称}` 占位符,是"给最终用户的提示词模板"而非"给代理的执行指令" | 双层嵌套(框架指令→内嵌提示词→下游模型),语义稀释、维护两套口径;违反命令式原则 |
| A3 | 渐进披露:长内容拆 references/ 按需加载;正文 <500 行 / <5k 词【1.1/1.2/1.3】 | 全部规则(设备尺寸、状态栏、图片源)压在 62 行正文里 | 目前长度尚可,但已接近"单文件塞一切"的形态;无拆分预案,规则再涨就会臃肿 |
| A4 | 客观可验证的 skill 应配 evals/(2–3 个测试提示词+断言)【1.3】 | 无任何测试提示词 | 界面数量、命名、尺寸、无死链等自检项全部可机器断言,却没固化为回归用例 |
| A5 | 输出模板/示例放 assets/ 或 references/,警惕 few-shot 过度模仿【1.3/3.3】 | 无示例、无输出模板文件 | 缺一个"好原型长什么样"的参照(哪怕一个最小 home.html 样例) |
| A6 | 自定义元数据规范放 `metadata` 对象;version 语义化【1.2】 | 顶层 `version: 1.0` + `updated:`(自创字段) | 与官方 loader 不兼容(本框架手动注入可容忍,但若未来接入 Claude Skills 机制需迁移);version 无变更说明 |
| A7 | 约束要解释 why,避免堆砌禁令【1.2/1.3】 | 部分禁令(如"禁止 Lorem ipsum")有理由,整体尚可 | 轻微;个别规则缺理由(如"不直接写入所有界面代码"未解释 iframe 平铺的动机) |

### 2.2 对照 `skills/brainstorm-facilitator/SKILL.md`

| # | 业界规范 | 现状 | 差距 |
|---|---|---|---|
| B1 | description 写触发时机;欠触发需 pushy 描述【1.2/1.3】 | description 只写流程概括+"调用角色:项目经理" | 同 A1:何时进入头脑风暴(阶段 0 后、想法未成型时)未写 |
| B2 | "何时使用"信息全部放 description,不放正文【1.3】 | 正文无重复触发信息 | ✅ 基本符合 |
| B3 | 结构:目标→角色→流程→产出→自检,逐步命令式 | 角色三视角分轮、发散≥12 条、打分收敛 | ✅ 结构良好,接近官方 process 型 skill 形态 |
| B4 | 主观产出可免 evals,但应有输入依赖声明【1.3】 | 未声明输入(原始想法从哪来、需要用户提供什么) | 缺"前置输入清单"(如:项目画像中一句话概述,或用户口述想法) |
| B5 | 打分权重/公式要可复算(框架总原则也要求) | 四维 0–5 等权求和,未说明权重是否等权、并列如何处理 | 小缺口:并列排序规则未定义 |
| B6 | 长度控制:name ≤64 字符 | ✅ 符合 | — |

### 2.3 对照 `memory/README.md`

| # | 业界规范 | 现状 | 差距 |
|---|---|---|---|
| M1 | 记忆分块,每块有 label + **大小上限**【4.2】 | 三文件各有职责,统一 300 行触发蒸馏,无单块(小节)上限 | project-profile 的"关键假设"一节可无限膨胀直到 300 行才处理;建议每节独立上限(如 ≤30 行) |
| M2 | 记忆应**持续自编辑**(每次写入时更新),而非攒到阈值一次性压缩【4.2/3.1 compaction】 | "超 300 行才蒸馏"是被动批量式 | decisions.md 追加频繁,300 行阈值下"被否决选项描述"会长期占位;应改为"每次写入时顺手压缩 + 阶段末例行蒸馏"双触发 |
| M3 | 检索:每步只拉回相关内容;索引需可检索(关键词)【3.2 Select】 | outputs-index.md 只有路径+一句话摘要 | 子代理按"一句话摘要"找原文命中率低;缺关键词列/阶段列/状态过滤约定 |
| M4 | 文件系统即记忆是合理形态,关键在索引与检索规则【4.4】 | ✅ 三文件+docs 原文分层,形态正确 | 只需补检索规则 |
| M5 | 核心记忆可设"只读/永不删除"保护【4.2】 | decisions.md 蒸馏"永不删除最终选择" | ✅ 已符合(等价于只读核心块) |
| M6 | 写入应有验证回路(格式校验)【5.x 回归思想】 | 只规定写入时机,无格式校验要求 | 例如决策条目缺字段(日期/阶段/理由)时无检查;可在 prompt-optimizer 复盘或 doc-quality-reviewer 中加"记忆一致性检查" |
| M7 | 蒸馏规则需可执行步骤(命令式)【1.2】 | "合并同类项、删过程细节"较抽象 | 缺少具体动作序列(先删什么、保留什么、如何写"见 docs/xxx"指针) |

### 2.4 对照 `AGENTS.md`(155 行,常驻系统提示)

| # | 业界规范 | 现状 | 差距 |
|---|---|---|---|
| G1 | 指令文件最小化:最小集合开始,观察到失败再加【3.1】;防过载【2.1/2.3】 | 155 行九大节全文常驻:总原则、角色注册表(10 行表)、Skills 注册表(12 行表)、8 阶段详表、协作协议、提问协议、记忆规则、目录规范、token 规范 | 体量偏大;其中角色表与 `roles/README.md`、阶段详表与 `workflow/README.md`、Skills 表与各 SKILL.md description **三处重复**,每个无关 token 都稀释注意力 |
| G2 | 分层渐进披露:细节放嵌套文件按需加载【2.1/2.2/1.1】 | 框架本身有 workflow/README、roles/README,但 AGENTS.md 未瘦身引用,而是全文复制摘要 | 应"AGENTS.md 只留宪法级规则+速查索引,细节下沉" |
| G3 | 只放可操作约束与高频返工错误规避【2.2/2.4】 | 大量描述性内容(如目录树示意、每阶段调用哪些 skills 的明细) | 描述性内容可移出常驻区 |
| G4 | 像高频提示词一样持续打磨 + 版本化【2.3/5.1】 | 框架无版本号、无变更日志(decisions.md 记的是项目决策,不是框架决策) | 框架自身演进无追溯;skill 修改也无 changelog |
| G5 | 批量提问减少往返 | 第六章批量提问协议 | ✅ 超前于业界做法,保留 |
| G6 | 子代理隔离、只回传浓缩摘要【3.1】 | "子代理只回传结论 ≤300 字" | ✅ 完全符合 Anthropic 子代理模式 |
| G7 | token 消耗记录供校准 | outputs-index.md 记每阶段 token | ✅ 已有 proto-eval 意识;但粒度只到阶段,未到单 skill 调用【对照 1.3 的 timing.json】 |
| G8 | few-shot 风险【3.3】 | 无示例机制 | 无此项风险,但也意味着没有"好产出长什么样"的锚;可低剂量补充 |

---

## 三、改进建议(14 条,按优先级排序)

> 格式:【来源】→【改哪个文件】→【具体改法】

**1.【2.1/2.3/3.1 → AGENTS.md】瘦身与分层加载(最高优先级)**
AGENTS.md 目标压到 ≤80 行:保留九节中的「总原则(压缩为 6 条)」「阶段速查表(一行一阶段:阶段号/主责/产出路径)」「批量提问协议」「记忆读写纪律」;把角色注册表只留角色名一行清单(详情指 `roles/README.md`)、Skills 注册表整表删除(指 `skills/ 各 SKILL.md` frontmatter,启动子代理时现读)、8 阶段详表与协作协议细节下沉到 `workflow/README.md`(已存在,补齐即可)、目录规范移到 `workflow/README.md`。原则:AGENTS.md = 宪法 + 索引,细节 = 按需读的嵌套文档。

**2.【1.2/1.3 → 全部 12 个 SKILL.md 的 frontmatter description】description 规范化**
每条 description 重写为三段式:「做什么(一句)+ 何时使用(触发时机,含关键短语"当…时使用本 skill")+ 边界(何时不适用)」;删除"调用角色:xxx"(移入正文第一节"调用上下文");控制 ≤500 字符(中英混排按官方 1024 字符上限留余量)。例:app-ui-design 改为「…当阶段 5 已产出 ux-flows.md 与 ui-spec.md、需要把界面清单变成高保真 HTML 原型时使用;仅做静态原型,不生成可交互业务逻辑」。

**3.【1.1/1.2/1.3 → skills/app-ui-design/(试点),其余 skill 按需】渐进披露拆分**
为 skill 目录引入官方解剖结构:`SKILL.md` + `references/` + `assets/` + `evals/`。app-ui-design 先行:设备规范(iPhone/Web 尺寸、状态栏细节)拆 `references/device-specs.md`;真实图片来源与选图规则拆 `references/image-sources.md`;正文只留流程与自检,用"执行前先读 references/device-specs.md"引用。规则:正文 >300 行或 >5k 词即必须拆;参考文件 >300 行加目录。

**4.【1.3 → skills/app-ui-design/SKILL.md】主提示词块改命令式**
把 ```text「主提示词」整段改写为第一人称命令式步骤(给执行代理的直接指令),删除 `{项目/产品名称}` 占位符——项目名由代理从 `memory/project-profile.md` 读取;若确需保留"复制即用的提示词模板",降级为 `assets/prompt-template.txt` 并在正文标注"备用模板,优先按下列步骤直接执行"。消除双层嵌套。

**5.【1.3/5.2/5.4 → 新增 skills/<name>/evals/evals.json(客观可验证 skill 先行)】建立最小评测回路**
为 app-ui-design、quotation-calculator、feature-breakdown 三个可客观验证的 skill 各写 2–3 个真实测试提示词 + 断言清单(断言含 `text`/`passed`/`evidence` 三字段,与官方一致)。首次运行记录基线;每次修改 SKILL.md 后,用"旧版/新版成对双跑"对比断言通过率,不降级才算改版成功。主观型 skill(brainstorm-facilitator、ux-flow-designer)按官方指引免评测,只保留自检清单。

**6.【4.2 → memory/README.md】记忆分块限额**
给 `project-profile.md` 规定固定小节与每节上限:一句话概述(≤3 行)、目标用户(≤5 行)、核心价值(≤5 行)、范围边界做/不做(各 ≤10 行)、关键假设(≤15 行,每条一行+置信度);`outputs-index.md` 每条登记 ≤3 行。任一小节超限即触发该节单独蒸馏,不等整文件 300 行。

**7.【4.2/3.1/3.2 → memory/README.md 蒸馏规则】双触发蒸馏**
把"超 300 行才蒸馏"改为:(a) 每次写入时顺手压缩——追加决策时若同问题已有旧决策,旧决策压缩为"问题→结论"一行;(b) 每阶段结束例行蒸馏一次。并把蒸馏写成可执行步骤:① 删过程细节,改写为"结论 + 见 docs/xxx(路径)"指针;② 合并同主题决策;③ 校验 D-xxx 编号连续;④ 检查最终选择一个未丢。

**8.【3.2 Select/4.4 → memory/outputs-index.md + memory/README.md】索引可检索化**
outputs-index.md 表格加两列:「阶段」与「关键词(3–5 个,中英不限)」;memory/README.md 增加一条检索纪律:"子代理查找上下文时,先按阶段列过滤,再按关键词匹配,命中后读原文"。等价于轻量 Select 策略,零工具成本。

**9.【5.1/5.3 → skills/<name>/SKILL.md frontmatter + 新增 skills/<name>/CHANGELOG.md(或合并进 frontmatter)】skill 版本化与变更追溯**
每次修改 SKILL.md:description 变更 bump 次版本,流程/产出结构变更 bump 主版本;在文件尾(或 CHANGELOG.md)追加一行"版本 | 日期 | 改了什么 | 为什么(依据哪次复盘/哪条用户反馈)";同时把 frontmatter 的 `version/updated` 迁入官方兼容的 `metadata: { version, updated }` 写法(顶层保留旧字段做过渡亦可,注明兼容性)。支持"改坏了回滚上一版"。

**10.【2.4/5.5 → AGENTS.md「框架复盘」条款 + roles/prompt-optimizer.md】框架级回归清单**
AGENTS.md 第四节末尾已有"提示词优化员做框架复盘",在 `roles/prompt-optimizer.md` 中落实为检查表:每次复盘逐 skill 回答——① 自检清单逐条是否仍有效(删过期项);② description 是否仍匹配实际触发场景;③ 上阶段该 skill 的 token 消耗/产出比是否劣化(对照 outputs-index 记录);④ 是否出现"多次运行重复造轮子"→ 沉淀为模板或参考文件。任一 skill 连续两次复盘无问题则标记"稳定",降低复审频率。

**11.【G7/1.3 timing → memory/outputs-index.md】token 记账细化到 skill 粒度**
在现有"每阶段 token 消耗"行之外,增加"本阶段各 skill 调用 token"(skill 名 + 估算 token + 产出文件数)。数据来源为主代理注入前后的粗估即可,目的是形成每 skill 的"消耗/产出比"时序,为第 10 条复盘与阶段 6 的 ai-dev-estimator 校准提供真实基线。

**12.【1.3 → skills/brainstorm-facilitator/SKILL.md(及各 skill 通用)】补前置输入声明**
每个 SKILL.md「执行流程」第 1 步前加「输入依赖」小节:列出必需输入(文件路径或用户提供项)与缺失时的动作(brainstorm:需用户口述想法或 project-profile 一句话概述;缺失则先提问,不猜测)。同时给打分表补一条规则:"总分并列时按 需求强度 > 差异化 > 商业潜力 > 实现难度 依次比较",消除并列歧义。

**13.【3.3 + 1.2 → skills/app-ui-design/assets/(及各 skill 可选)】低剂量示例锚**
为客观型 skill 各放 1 个最小"合格产出样例"(如 app-ui-design 放一个 ~60 行的 `assets/sample-home.html` 截图说明或代码),正文标注"示例仅示意结构与真实感标准,禁止复制其业务文案与配色"(防 Manus 指出的 few-shot 过度模仿)。主观型 skill 不放示例。

**14.【2.2/3.1 → AGENTS.md token 节约规范】把"省 token"从口号变成可核对规则**
第九节现有 5 条偏原则化,改为可执行检查:① 常驻上下文(AGENTS.md)预算 ≤N 行,N=80;② 注入子代理的固定材料 ≤3 份(角色文件+画像+任务描述),其余一律路径引用;③ 引用已有结论时必须写"见 memory/outputs-index.md 第 x 条"而非复述;④ 每阶段结束在 outputs-index 登记"预算 vs 实耗"。违反项在复盘时点名。

---

## 四、框架已符合业界规范的项(保持,不动)

1. 三层渐进披露的骨架已天然存在:SKILL.md frontmatter(元数据)→ 正文 → docs/ 原文按需读【对照 1.1】。
2. 子代理只回传 ≤300 字摘要 = Anthropic 子代理"condensed summary"模式【对照 3.1】。
3. 批量提问协议 = 减少往返的上下文工程实践,超前于多数社区方案【对照 3.1/3.2】。
4. 记忆三文件(画像/决策/索引)+ docs 原文分层 = MemGPT 工作记忆/归档记忆分层的文件式实现,基准研究证实该形态成立【对照 4.2/4.4】。
5. decisions.md"永不删除最终选择" = 只读核心记忆块保护【对照 4.2】。
6. 自检清单、产出路径强制、缺失输入先报告不猜测 = 官方建议的 checklists 与 guardrails【对照 1.2】。
7. 阶段 token 消耗登记 = 官方 skill-creator 记 timing 数据的简化版【对照 1.3】。

---

## 五、参考来源汇总(全部 URL)

| # | 来源 | URL |
|---|---|---|
| 1 | Anthropic 工程博客:Agent Skills | https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills |
| 2 | Claude 平台文档:Skill authoring best practices | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices |
| 3 | Claude 平台文档:Agent Skills 总览 | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview |
| 4 | anthropics/skills 仓库 | https://github.com/anthropics/skills |
| 5 | skill-creator SKILL.md 原文 | https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md |
| 6 | Anthropic 工程博客:Effective context engineering | https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents |
| 7 | LangChain:Context engineering (write/select/compress/isolate) | https://www.langchain.com/blog/context-engineering-for-agents |
| 8 | Manus:Context Engineering Lessons | https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus |
| 9 | aihero.dev: A Complete Guide to AGENTS.md | https://www.aihero.dev/a-complete-guide-to-agents-md |
| 10 | morphllm: AGENTS.md Spec Guide | https://www.morphllm.com/agents-md-guide |
| 11 | 0xdevalias gist: Notes on AI Agent Rule/Context Files | https://gist.github.com/0xdevalias/f40bc5a6f84c4c5ad862e314894b2fa6 |
| 12 | HN: Evaluating AGENTS.md | https://news.ycombinator.com/item?id=47034087 |
| 13 | arXiv: Common Mistakes in Configuring Coding Agents | https://arxiv.org/html/2606.15828v2 |
| 14 | Letta: Agent Memory | https://www.letta.com/blog/agent-memory/ |
| 15 | Letta: Memory Blocks | https://www.letta.com/blog/memory-blocks/ |
| 16 | Letta: Benchmarking Agent Memory (filesystem) | https://www.letta.com/blog/benchmarking-ai-agent-memory/ |
| 17 | NirDiamant: Agent Memory Techniques | https://github.com/NirDiamant/Agent_Memory_Techniques |
| 18 | arXiv: Agent Memory Characterization | https://arxiv.org/html/2606.06448v1 |
| 19 | HF Forum: memory systems for long-running agents | https://discuss.huggingface.co/t/how-do-you-design-memory-systems-for-long-running-ai-agents/175584 |
| 20 | Braintrust: prompt versioning | https://www.braintrust.dev/articles/what-is-prompt-versioning |
| 21 | Medium: prompt testing & regression | https://medium.com/@QuarkAndCode/llm-prompt-testing-and-regression-testing-a-practical-guide-e0d44de823cf |
| 22 | Traceloop: LLM-as-judge regression CI/CD | https://www.traceloop.com/blog/automated-prompt-regression-testing-with-llm-as-a-judge-and-ci-cd |
| 23 | Future AGI: prompt regression testing guide | https://futureagi.com/blog/prompt-regression-testing-2026/ |
| 24 | arXiv: (Why) Is My Prompt Getting Worse? | https://arxiv.org/html/2311.11123v2 |

> 置信度说明:来源 1/5/6/7/15 为一手原文全文抓取,要点为原文直接转述,置信度高;来源 2 经检索摘要获得(平台文档多次超时,未取到全文,但其 64/1024 字符与 5k 词限制与仓库内 skill-creator 相互印证),置信度中高;其余为检索摘要,置信度中。
