<p align="center">
  <img src="openbncbanner.jpg" alt="openbnc" width="100%" />
</p>

# openbnc

> Bridging the gap between crypto infrastructure and autonomous AI agents.

---

## What is openbnc?

openbnc is an experimental open-source project exploring what happens when you put autonomous AI agents at the heart of crypto infrastructure.

We believe the next chapter of decentralized technology isn't just about money moving between wallets — it's about intelligent agents that can reason, act, and collaborate on behalf of their users. openbnc is our attempt to build that bridge: a lightweight, self-hostable AI agent runtime designed from the ground up with the crypto-native world in mind.

This is not a finished product. It is an experiment — and we think the most interesting experiments happen in public.

---

## Vision

The crypto ecosystem has built remarkable infrastructure for trustless value exchange. The AI ecosystem has built remarkable infrastructure for intelligent automation. Yet the two worlds remain largely separate, connected only by clumsy integrations and fragile wrappers.

openbnc asks a simple question: **what if AI agents were first-class citizens of the decentralized web?**

We envision a future where:

- Anyone can deploy a personal AI agent that operates autonomously on their behalf
- Agents can interact with on-chain protocols natively, without centralized intermediaries
- AI compute and crypto-economic incentives align to create a self-sustaining ecosystem
- The barrier between "running an AI" and "participating in a network" disappears entirely

This vision is ambitious. We are starting small, iterating in the open, and inviting the community to help shape what openbnc becomes.

---

## Core Principles

**Autonomous by default.** Agents deployed on openbnc are designed to act independently — not as passive chatbots waiting for prompts, but as active participants capable of scheduling tasks, monitoring conditions, and taking meaningful actions.

**Self-hostable and sovereign.** You own your agent. openbnc is built to run on your hardware, your server, or your local machine. No platform lock-in. No data harvested by a third party.

**Provider-agnostic.** We don't believe any single AI model will win forever. openbnc supports multiple AI providers so you can swap the underlying intelligence without rebuilding your setup.

**Open and experimental.** We are sharing this work early because we think the questions openbnc is asking matter — and because the best answers will come from a community, not a single team.

---

## Status

openbnc is currently in early experimental development. APIs will change. Things will break. That's intentional.

If you're the kind of person who finds that exciting rather than alarming, you're in the right place.

---

## Community & Links

- **Website**: https://bncchain.com/
- **X (Twitter)**: https://x.com/BNCCHAIN

---

*openbnc is an open-source project. Contributions, ideas, and critical feedback are all welcome.*

---

## Deployment Guide

### Supported LLM Providers

openbnc is provider-agnostic. You can use any of the following:

| Provider | Description |
|----------|-------------|
| `ollama` | Run models locally — no API key needed |
| `openrouter` | Access 100+ models with a single API key (default) |
| `openai` | GPT-4o, o1, and other OpenAI models |
| `anthropic` | Claude 3.5 / Claude 4 series |
| `gemini` | Google Gemini models |
| `bedrock` | AWS Bedrock |
| `copilot` | GitHub Copilot |
| `glm` | Zhipu GLM (Chinese domestic) |
| `compatible` | Any OpenAI-compatible API endpoint |
| `telnyx` | Telnyx AI |

### Supported Channels

Connect your agent to the messaging platforms you already use:

`Telegram` · `Discord` · `Slack` · `WhatsApp` · `QQ` · `DingTalk` · `Lark (Feishu)` · `Signal` · `Matrix` · `Mattermost` · `IRC` · `Nostr` · `iMessage` · `Email` · `Nextcloud Talk`

---

### Prerequisites

- [Rust](https://rustup.rs/) 1.93+
- [Node.js](https://nodejs.org/) 18+ and npm (for building the web dashboard)
- Visual Studio 2022 Build Tools with **Desktop development with C++** (Windows only)

---

### Build from Source

**1. Clone the repository**

```bash
git clone https://github.com/openbnclabs/openbnc.git
cd openbnc
```

**2. Build the web dashboard**

```bash
cd web
npm install
npx vite build
cd ..
```

**3. Build the Rust binary**

```bash
cargo build --release
```

The binary will be at `target/release/openbnc` (or `openbnc.exe` on Windows).

---

### Configuration

On first run, openbnc creates a config file at `~/.openbnc/config.toml`.

The simplest way to configure is via environment variables:

| Variable | Description |
|----------|-------------|
| `PROVIDER` | LLM provider (`ollama`, `openrouter`, `openai`, etc.) |
| `API_KEY` | API key for the provider (for Ollama: the server URL) |
| `OPENBNC_MODEL` | Model name to use |

---

### Quick Start

**Option A — Local Ollama (no API key required)**

```bash
# Install Ollama: https://ollama.com
ollama pull qwen2.5:7b

# Run openbnc
PROVIDER=ollama API_KEY=http://localhost:11434 OPENBNC_MODEL=qwen2.5:7b ./openbnc daemon
```

On Windows (PowerShell):

```powershell
$env:PROVIDER="ollama"; $env:API_KEY="http://localhost:11434"; $env:OPENBNC_MODEL="qwen2.5:7b"; .\target\release\openbnc.exe daemon
```

**Option B — OpenRouter (recommended for cloud)**

```bash
PROVIDER=openrouter API_KEY=your_openrouter_key ./openbnc daemon
```

Open the web dashboard at **http://localhost:42617**

---

### Pairing (First Login)

openbnc uses a one-time pairing code for security. On first start (no existing sessions), the terminal will print:

```
🔐 PAIRING REQUIRED — use this one-time code:
┌─────────────────┐
│  ABC123          │
└─────────────────┘
```

Enter this code in the web dashboard to pair your browser. The token is then stored locally — you won't need to pair again unless you reset.

To reset pairing, clear `paired_tokens` in `~/.openbnc/config.toml`:

```toml
paired_tokens = []
```

---

### Telegram Integration

**1. Create a bot via [@BotFather](https://t.me/BotFather)**

```
/newbot
```

Copy the bot token (format: `123456789:ABCdef...`).

**2. Add to config** (`~/.openbnc/config.toml`):

```toml
[channels_config.telegram]
bot_token = "YOUR_BOT_TOKEN"
allowed_users = ["your_telegram_username"]
stream_mode = "partial"
interrupt_on_new_message = true
```

**3. Start with `daemon` (not `gateway`)**

```bash
./openbnc daemon
```

The `daemon` command starts the full runtime: gateway + all configured channels + scheduler.

---

### Proxy Configuration (for users behind a firewall or using a proxy)

If you need a proxy to access external APIs (e.g., Telegram, OpenRouter):

```toml
[proxy]
enabled = true
http_proxy = "http://127.0.0.1:7890"
https_proxy = "http://127.0.0.1:7890"
no_proxy = ["localhost", "127.0.0.1"]
```

> **Note:** Always add `localhost` and `127.0.0.1` to `no_proxy` when using a local Ollama instance, to prevent the proxy from intercepting local requests.

---

### `gateway` vs `daemon`

| Command | What it starts |
|---------|---------------|
| `openbnc gateway` | HTTP gateway + web dashboard only |
| `openbnc daemon` | Gateway + all channels + heartbeat + scheduler |

Use `daemon` for production or when using messaging channels like Telegram.
