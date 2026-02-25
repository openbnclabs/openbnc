<p align="center">
  <img src="openbncbanner.jpg" alt="openbnc" width="100%" />
</p>

# openbnc

> 连接加密基础设施与自主 AI 智能体的桥梁。

---

## openbnc 是什么？

openbnc 是一个实验性的开源项目，探索将自主 AI 智能体置于加密基础设施核心时会发生什么。

我们相信，去中心化技术的下一篇章不仅仅是钱包之间的价值流转——而是能够代表用户进行推理、行动和协作的智能体。openbnc 正是我们构建这座桥梁的尝试：一个轻量级、可自托管的 AI 智能体运行时，从底层设计之初便以加密原生世界为核心目标。

这不是一个成熟的产品，而是一场实验——我们认为最有趣的实验都应该在公开环境中进行。

---

## 愿景

加密生态系统已经为无需信任的价值交换构建了卓越的基础设施。AI 生态系统也为智能自动化构建了卓越的基础设施。然而，这两个世界在很大程度上仍然相互隔离，仅靠笨拙的集成和脆弱的封装层勉强相连。

openbnc 提出了一个简单的问题：**如果 AI 智能体成为去中心化网络的一等公民，会怎样？**

我们设想这样的未来：

- 任何人都能部署一个代表自己自主运行的个人 AI 智能体
- 智能体可以原生地与链上协议交互，无需中心化中间商
- AI 计算与加密经济激励机制协同对齐，构建自我持续的生态系统
- "运行 AI"与"参与网络"之间的壁垒彻底消失

这一愿景雄心勃勃。我们从小处着手，在开放环境中持续迭代，并邀请社区共同塑造 openbnc 的未来。

---

## 核心原则

**默认自主。** 部署在 openbnc 上的智能体被设计为独立行动——不是等待提示词的被动聊天机器人，而是能够调度任务、监控条件并采取有意义行动的主动参与者。

**可自托管，主权在我。** 智能体归你所有。openbnc 可在你的硬件、服务器或本地机器上运行，无平台锁定，无第三方数据收集。

**提供商无关。** 我们不认为任何单一 AI 模型会永远胜出。openbnc 支持多个 AI 提供商，让你无需重建整套配置便可更换底层智能。

**开放且实验性。** 我们之所以提前分享这项工作，是因为我们认为 openbnc 所探讨的问题至关重要——也因为最好的答案将来自社区，而非单一团队。

---

## 现状

openbnc 目前处于早期实验性开发阶段。API 会发生变化，功能可能出现故障，这是有意为之。

如果你觉得这令人兴奋而非令人担忧，那么你来对地方了。

---

## 社区与链接

- **官网**: https://bncchain.com/
- **X (Twitter)**: https://x.com/BNCCHAIN

---

*openbnc 是一个开源项目，欢迎贡献代码、分享想法和提出建设性反馈。*

---

## 部署指南

### 支持的 LLM Provider

openbnc 不绑定任何单一模型，支持以下 Provider：

| Provider | 说明 |
|----------|------|
| `ollama` | 本地运行模型，无需 API Key |
| `openrouter` | 一个 Key 访问 100+ 模型（默认）|
| `openai` | GPT-4o、o1 等 OpenAI 模型 |
| `anthropic` | Claude 3.5 / Claude 4 系列 |
| `gemini` | Google Gemini 模型 |
| `bedrock` | AWS Bedrock |
| `copilot` | GitHub Copilot |
| `glm` | 智谱 GLM（国产模型）|
| `compatible` | 任意兼容 OpenAI 格式的接口 |
| `telnyx` | Telnyx AI |

### 支持的消息频道

将你的智能体接入你已在使用的平台：

`Telegram` · `Discord` · `Slack` · `WhatsApp` · `QQ` · `钉钉` · `飞书` · `Signal` · `Matrix` · `Mattermost` · `IRC` · `Nostr` · `iMessage` · `邮件` · `Nextcloud Talk`

---

### 环境依赖

- [Rust](https://rustup.rs/) 1.93+
- [Node.js](https://nodejs.org/) 18+ 及 npm（用于构建 Web 控制台）
- Visual Studio 2022 Build Tools，需勾选**使用 C++ 的桌面开发**（仅 Windows）

---

### 从源码构建

**1. 克隆仓库**

```bash
git clone https://github.com/openbnclabs/openbnc.git
cd openbnc
```

**2. 构建 Web 控制台**

```bash
cd web
npm install
npx vite build
cd ..
```

**3. 编译 Rust 二进制**

```bash
cargo build --release
```

编译产物位于 `target/release/openbnc`（Windows 为 `openbnc.exe`）。

---

### 配置

首次运行时，openbnc 会在 `~/.openbnc/config.toml` 自动生成配置文件。

最简单的配置方式是使用环境变量：

| 变量 | 说明 |
|------|------|
| `PROVIDER` | LLM Provider（`ollama`、`openrouter`、`openai` 等）|
| `API_KEY` | Provider 的 API Key（Ollama 填服务地址）|
| `OPENBNC_MODEL` | 使用的模型名称 |

---

### 快速启动

**方式 A — 本地 Ollama（无需 API Key）**

```bash
# 安装 Ollama：https://ollama.com
ollama pull qwen2.5:7b

# 启动 openbnc
PROVIDER=ollama API_KEY=http://localhost:11434 OPENBNC_MODEL=qwen2.5:7b ./openbnc daemon
```

Windows PowerShell：

```powershell
$env:PROVIDER="ollama"; $env:API_KEY="http://localhost:11434"; $env:OPENBNC_MODEL="qwen2.5:7b"; .\target\release\openbnc.exe daemon
```

**方式 B — OpenRouter（推荐云端方案）**

```bash
PROVIDER=openrouter API_KEY=你的Key ./openbnc daemon
```

启动后访问 **http://localhost:42617** 打开 Web 控制台。

---

### 配对（首次登录）

openbnc 使用一次性配对码保障安全。首次启动（无已有会话）时，终端会打印：

```
🔐 PAIRING REQUIRED — use this one-time code:
┌─────────────────┐
│  ABC123          │
└─────────────────┘
```

在 Web 控制台输入此码完成配对。Token 会持久化保存，后续启动无需重复配对。

重置配对：清空 `~/.openbnc/config.toml` 中的 `paired_tokens`：

```toml
paired_tokens = []
```

---

### 接入 Telegram

**1. 通过 [@BotFather](https://t.me/BotFather) 创建 Bot**

```
/newbot
```

复制获得的 Bot Token（格式：`123456789:ABCdef...`）。

**2. 写入配置文件** (`~/.openbnc/config.toml`)：

```toml
[channels_config.telegram]
bot_token = "你的Bot Token"
allowed_users = ["你的Telegram用户名"]
stream_mode = "partial"
interrupt_on_new_message = true
```

**3. 使用 `daemon` 启动（而非 `gateway`）**

```bash
./openbnc daemon
```

`daemon` 命令会同时启动网关、所有已配置的消息频道和任务调度器。

---

### 代理配置（适用于需要代理的用户）

若需要代理访问外部 API（如 Telegram、OpenRouter）：

```toml
[proxy]
enabled = true
http_proxy = "http://127.0.0.1:7890"
https_proxy = "http://127.0.0.1:7890"
no_proxy = ["localhost", "127.0.0.1"]
```

> **注意：** 使用本地 Ollama 时，务必将 `localhost` 和 `127.0.0.1` 加入 `no_proxy`，避免代理拦截本地请求导致连接失败。

---

### `gateway` 与 `daemon` 的区别

| 命令 | 启动内容 |
|------|---------|
| `openbnc gateway` | 仅启动 HTTP 网关和 Web 控制台 |
| `openbnc daemon` | 网关 + 所有消息频道 + 心跳监控 + 定时任务 |

接入 Telegram 等消息频道时，请使用 `daemon`。
