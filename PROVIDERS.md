# 🔧 Provider Configuration / Provider-Konfiguration

**[🇩🇪 Deutsch](#-deutsch-1) | [🇬🇧 English](#-english-1)**

---

## 🇬🇧 English

### Built-in Providers (API key only — no extra config needed)

These providers are auto-detected. Just set the API key in the Unraid template:

| Provider | Env Variable | Free Tier | Sign Up |
|---|---|---|---|
| **Anthropic (Claude)** | `ANTHROPIC_API_KEY` | No (pay-as-you-go from $5) | [console.anthropic.com](https://console.anthropic.com) |
| **OpenAI (GPT/o3)** | `OPENAI_API_KEY` | No | [platform.openai.com](https://platform.openai.com) |
| **OpenRouter** | `OPENROUTER_API_KEY` | Yes (free models available!) | [openrouter.ai](https://openrouter.ai) |
| **Google Gemini** | `GEMINI_API_KEY` | Yes (generous!) | [aistudio.google.com](https://aistudio.google.com) |
| **xAI (Grok)** | `XAI_API_KEY` | Limited | [console.x.ai](https://console.x.ai) |
| **Groq** | `GROQ_API_KEY` | Yes (generous!) | [console.groq.com](https://console.groq.com) |
| **Cerebras** | `CEREBRAS_API_KEY` | Yes (30 req/min) | [cloud.cerebras.ai](https://cloud.cerebras.ai) |
| **Mistral** | `MISTRAL_API_KEY` | Limited | [console.mistral.ai](https://console.mistral.ai) |
| **Kimi Coding** | `KIMI_API_KEY` | Yes | Moonshot AI |
| **GitHub Copilot** | `COPILOT_GITHUB_TOKEN` | With subscription | GitHub |
| **HuggingFace** | `HUGGINGFACE_HUB_TOKEN` | Yes | [huggingface.co](https://huggingface.co/settings/tokens) |

### Custom Providers (need openclaw.json config)

These providers need entries in `/mnt/user/appdata/openclaw/config/openclaw.json` in addition to the API key.

> **Tip:** Use `"mode": "merge"` to add providers without overwriting existing config.

#### DeepSeek

Set `DEEPSEEK_API_KEY` in the template, then add to openclaw.json:

```json
{
  "models": {
    "mode": "merge",
    "providers": {
      "deepseek": {
        "baseUrl": "https://api.deepseek.com/v1",
        "apiKey": "${DEEPSEEK_API_KEY}",
        "api": "openai-completions",
        "models": [
          {
            "id": "deepseek-chat",
            "name": "DeepSeek V3.2",
            "reasoning": false,
            "contextWindow": 128000,
            "maxTokens": 8192
          },
          {
            "id": "deepseek-reasoner",
            "name": "DeepSeek Reasoner",
            "reasoning": true,
            "contextWindow": 128000,
            "maxTokens": 65536
          }
        ]
      }
    }
  }
}
```

Set as default:
```bash
docker exec -it OpenClaw openclaw config set agents.defaults.model.primary deepseek/deepseek-chat
```

#### Moonshot / Kimi K2.5

Set `MOONSHOT_API_KEY` in the template, then add to openclaw.json:

```json
{
  "models": {
    "mode": "merge",
    "providers": {
      "moonshot": {
        "baseUrl": "https://api.moonshot.ai/v1",
        "apiKey": "${MOONSHOT_API_KEY}",
        "api": "openai-completions",
        "models": [
          { "id": "kimi-k2.5", "name": "Kimi K2.5" }
        ]
      }
    }
  }
}
```

> **Note:** Kimi Coding (`KIMI_API_KEY`) is a separate built-in provider using the Anthropic-compatible endpoint. Moonshot (`MOONSHOT_API_KEY`) uses the OpenAI-compatible endpoint. They use different API keys!

#### MiniMax (via LM Studio or direct)

```json
{
  "models": {
    "mode": "merge",
    "providers": {
      "lmstudio": {
        "baseUrl": "http://YOUR-LMSTUDIO-IP:1234/v1",
        "apiKey": "LMSTUDIO_KEY",
        "api": "openai-completions",
        "models": [
          {
            "id": "minimax-m2.1-gs32",
            "name": "MiniMax M2.1",
            "contextWindow": 200000,
            "maxTokens": 8192
          }
        ]
      }
    }
  }
}
```

#### Ollama (local models — free!)

Set `OLLAMA_BASE_URL` in the template (e.g. `http://192.168.1.100:11434`), then:

```bash
docker exec -it OpenClaw openclaw config set agents.defaults.model.primary ollama/llama3.1
```

No extra config in openclaw.json needed — Ollama is built-in!

#### NVIDIA NIM

```json
{
  "models": {
    "mode": "merge",
    "providers": {
      "nvidia": {
        "baseUrl": "https://integrate.api.nvidia.com/v1",
        "apiKey": "${NVIDIA_API_KEY}",
        "api": "openai-completions",
        "models": [
          { "id": "deepseek-ai/deepseek-v3.2", "name": "DeepSeek V3.2 (NVIDIA)" },
          { "id": "moonshotai/kimi-k2-instruct", "name": "Kimi K2 (NVIDIA)" }
        ]
      }
    }
  }
}
```

### Multi-Provider Failover

Combine providers with automatic fallback:

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-sonnet-4-5",
        "fallbacks": [
          "openrouter/anthropic/claude-sonnet-4-5",
          "google/gemini-2.0-flash",
          "groq/llama-3.3-70b-versatile"
        ]
      }
    }
  }
}
```

### Web Search Providers

| Provider | Env Variable | Free? | Setup |
|---|---|---|---|
| **SearXNG** | `SEARXNG_URL` | ✅ Unlimited! | Self-host on Unraid |
| **Serper** | `SERPER_API_KEY` | ✅ 2,500/month | [serper.dev](https://serper.dev) |
| **Tavily** | `TAVILY_API_KEY` | ✅ Limited | [app.tavily.com](https://app.tavily.com) |
| **Brave** | `BRAVE_API_KEY` | ❌ Paid only | [brave.com/search/api](https://brave.com/search/api) |
| **Perplexity** | Config only | ❌ Paid | [perplexity.ai](https://perplexity.ai) |

---

## 🇩🇪 Deutsch

### Built-in Provider (nur API Key — keine Extra-Config nötig)

Diese Provider werden automatisch erkannt. Einfach den API Key im Unraid-Template setzen:

| Provider | Env Variable | Free Tier | Anmeldung |
|---|---|---|---|
| **Anthropic (Claude)** | `ANTHROPIC_API_KEY` | Nein (ab $5 Guthaben) | [console.anthropic.com](https://console.anthropic.com) |
| **OpenAI (GPT/o3)** | `OPENAI_API_KEY` | Nein | [platform.openai.com](https://platform.openai.com) |
| **OpenRouter** | `OPENROUTER_API_KEY` | Ja (kostenlose Modelle!) | [openrouter.ai](https://openrouter.ai) |
| **Google Gemini** | `GEMINI_API_KEY` | Ja (großzügig!) | [aistudio.google.com](https://aistudio.google.com) |
| **xAI (Grok)** | `XAI_API_KEY` | Begrenzt | [console.x.ai](https://console.x.ai) |
| **Groq** | `GROQ_API_KEY` | Ja (großzügig!) | [console.groq.com](https://console.groq.com) |
| **Cerebras** | `CEREBRAS_API_KEY` | Ja (30 req/min) | [cloud.cerebras.ai](https://cloud.cerebras.ai) |
| **Mistral** | `MISTRAL_API_KEY` | Begrenzt | [console.mistral.ai](https://console.mistral.ai) |
| **Kimi Coding** | `KIMI_API_KEY` | Ja | Moonshot AI |
| **GitHub Copilot** | `COPILOT_GITHUB_TOKEN` | Mit Abo | GitHub |
| **HuggingFace** | `HUGGINGFACE_HUB_TOKEN` | Ja | [huggingface.co](https://huggingface.co/settings/tokens) |

### Custom Provider (brauchen openclaw.json Config)

Diese Provider brauchen zusätzlich zum API Key Einträge in `/mnt/user/appdata/openclaw/config/openclaw.json`.

> **Tipp:** `"mode": "merge"` verwenden, damit bestehende Config nicht überschrieben wird.

Die Config-Beispiele sind identisch zum englischen Teil oben — die JSON-Syntax ist universal. Siehe die Beispiele unter [English → Custom Providers](#custom-providers-need-openclawjson-config).

### Kostenlos starten (kein Geld ausgeben!)

Beste Kombination für $0:

1. **Modelle:** OpenRouter (kostenlose Modelle) + Groq (Free Tier) + Cerebras (Free Tier)
2. **Web Search:** SearXNG auf Unraid (self-hosted, unbegrenzt)
3. **Lokal:** Ollama mit Llama 3.1 auf deinem Server

```bash
# Ollama installieren (falls noch nicht vorhanden)
docker exec -it OpenClaw openclaw config set agents.defaults.model.primary groq/llama-3.3-70b-versatile

# SearXNG Skill
docker exec -it OpenClaw openclaw skills install local-websearch
```
