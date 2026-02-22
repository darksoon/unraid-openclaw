# 🦞 OpenClaw Unraid Template — Community Edition

**[🇩🇪 Deutsch](#-deutsch) | [🇬🇧 English](#-english)**

---

## 🇩🇪 Deutsch

Verbessertes Unraid-Template für [OpenClaw](https://github.com/openclaw/openclaw) mit sofortigen Updates, 15+ LLM-Providern, kostenlosen Web-Search-Alternativen und vollem Feature-Zugriff.

### Warum dieses Template?

Das [Original-Template](https://github.com/jdhill777/openclaw-unraid) ist ein guter Startpunkt, hat aber Einschränkungen:

| Problem | Original | Dieses Template |
|---|---|---|
| **Updates kommen nicht** | `:latest` Tag hinkt auf ghcr.io hinterher | `:main` — sofort bei jedem Push |
| **Wenig Provider** | 5 API Keys | **15+ Provider** inkl. xAI, Cerebras, Kimi, DeepSeek, Ollama |
| **Kein Web Search Free Tier** | Nur Brave (Free Tier eingestellt!) | **SearXNG** (kostenlos!), Tavily, Serper |
| **Browser crasht** | Kein shm-size | `--shm-size=2g` für stabiles Chromium |
| **Kein Sandbox-Mode** | Kein Docker Socket | Docker Socket für Agent-Isolation |
| **CLI umständlich** | `node dist/index.js ...` | `docker exec -it OpenClaw openclaw [cmd]` |
| **Keine Zeitzone** | — | `TZ` konfigurierbar (Cron Jobs!) |

### Installation

**Schritt 1: Template installieren**
```bash
# Via Unraid SSH:
mkdir -p /boot/config/plugins/dockerMan/templates-user
curl -o /boot/config/plugins/dockerMan/templates-user/openclaw.xml \
  https://raw.githubusercontent.com/darksoon/unraid-openclaw/main/openclaw.xml
```

Oder das Script nutzen:
```bash
curl -fsSL https://raw.githubusercontent.com/darksoon/unraid-openclaw/main/install.sh | bash
```

**Schritt 2: Container erstellen**
1. Unraid UI → Docker → **Add Container** → Template: **OpenClaw**
2. **Gateway Token** generieren: `openssl rand -hex 24`
3. Mindestens **einen API Key** eintragen (z.B. Anthropic, OpenRouter oder Gemini)
4. **Apply**

**Alternativ: Secrets via .env-Datei**

Das Install-Script erstellt automatisch eine `.env`-Datei unter `/mnt/user/appdata/openclaw/config/.env`.
```bash
# Keys eintragen
nano /mnt/user/appdata/openclaw/config/.env
```
Dann im Template bei "Env File" den Pfad `/mnt/user/appdata/openclaw/config/.env` eintragen.
Template-Variablen können leer bleiben — .env überschreibt bei Konflikten.

**Schritt 3: Zugriff**
```
http://DEINE-IP:18789/?token=DEIN_TOKEN
```

**Schritt 4: Optional - Onboarding**
```bash
docker exec -it OpenClaw openclaw onboard
```
Führt durch die erste Einrichtung (Modell-Auswahl, Skills, etc.)

### Image Tag: `:main` vs `:latest`

| Tag | Verhalten | Empfehlung |
|---|---|---|
| `:main` | Sofort bei jedem Push auf den main-Branch | ✅ **Empfohlen** |
| `:latest` | Nur bei getaggten Releases — **hinkt oft Tage hinterher!** | ⚠️ Nicht empfohlen |
| `:2026.2.21` | Gepinnte Version, manuell ändern | Für maximale Stabilität |

**Warum `:main`?** Es kam vor, dass `2026.2.21` released wurde, aber `:latest` noch auf `2026.1.30` zeigte. Mit `:main` bekommst du alles sofort.

**Manuell updaten:** Unraid Docker → OpenClaw → **Force Update** (oder `docker pull ghcr.io/openclaw/openclaw:main`)

### CLI-Zugriff

```bash
docker exec -it OpenClaw openclaw doctor              # Health Check
docker exec -it OpenClaw openclaw models list          # Verfügbare Modelle
docker exec -it OpenClaw openclaw onboard              # Setup Wizard
docker exec -it OpenClaw openclaw channels login       # WhatsApp QR
docker exec -it OpenClaw openclaw channels add --channel telegram --token "TOKEN"
docker exec -it OpenClaw openclaw config set agents.defaults.model.primary anthropic/claude-opus-4-6
docker exec -it OpenClaw openclaw skills install humanizer
docker exec -it OpenClaw openclaw --version
```

### Kostenlose Web Search Alternativen

Brave hat sein Free Tier eingestellt! Hier sind die Alternativen:

#### SearXNG — Komplett kostenlos, self-hosted (empfohlen für Unraid!)

Aggregiert Google, DuckDuckGo, Brave, Bing und 70+ Engines. Einfach als zweiten Container auf Unraid:

```bash
docker run -d \
  --name searxng \
  --restart unless-stopped \
  -p 8888:8080 \
  -e SEARXNG_BASE_URL=http://localhost:8888 \
  searxng/searxng:latest
```

Dann im Template **SearXNG URL** auf `http://DEINE-UNRAID-IP:8888` setzen und den Skill installieren:
```bash
docker exec -it OpenClaw openclaw skills install local-websearch
```

#### Serper.dev — 2.500 Abfragen/Monat kostenlos
Google Search API. Registrieren auf [serper.dev](https://serper.dev), Key im Template eintragen.

#### Tavily — Free Tier mit KI-optimierten Ergebnissen
Registrieren auf [app.tavily.com](https://app.tavily.com), Key eintragen.

### Provider mit zusätzlicher Config

Einige Provider brauchen neben dem API Key auch eine Konfiguration in `/mnt/user/appdata/openclaw/config/openclaw.json`. Siehe [PROVIDERS.md](PROVIDERS.md) für vollständige Anleitungen.

**Kurzübersicht:**
- **Anthropic, OpenAI, OpenRouter, Gemini, xAI, Groq, Cerebras, Mistral** → Nur API Key im Template setzen, fertig!
- **DeepSeek, Moonshot/Kimi, MiniMax, Ollama** → API Key im Template + `models.providers` Config in openclaw.json
- **SearXNG** → Keine API Key nötig, nur URL

### Troubleshooting

```bash
# Logs anschauen
docker logs OpenClaw 2>&1 | tail -100

# Config reparieren
cat > /mnt/user/appdata/openclaw/config/openclaw.json << 'EOF'
{"gateway":{"mode":"local","bind":"lan","controlUi":{"allowInsecureAuth":true},"auth":{"mode":"token"}}}
EOF
docker restart OpenClaw

# Version prüfen
docker exec -it OpenClaw openclaw --version
```

---

## 🇬🇧 English

Improved Unraid template for [OpenClaw](https://github.com/openclaw/openclaw) with instant updates, 15+ LLM providers, free web search alternatives, and full feature access.

### Why this template?

The [original template](https://github.com/jdhill777/openclaw-unraid) is a good starting point but has limitations:

| Issue | Original | This Template |
|---|---|---|
| **Updates don't arrive** | `:latest` tag lags behind on ghcr.io | `:main` — instant on every push |
| **Few providers** | 5 API keys | **15+ providers** incl. xAI, Cerebras, Kimi, DeepSeek, Ollama |
| **No free web search** | Brave only (free tier killed!) | **SearXNG** (free!), Tavily, Serper |
| **Browser crashes** | No shm-size | `--shm-size=2g` for stable Chromium |
| **No sandbox mode** | No Docker socket | Docker socket for agent isolation |
| **Clunky CLI** | `node dist/index.js ...` | `docker exec -it OpenClaw openclaw [cmd]` |
| **No timezone** | — | Configurable `TZ` (cron jobs!) |

### Installation

**Step 1: Install template**
```bash
# Via Unraid SSH:
mkdir -p /boot/config/plugins/dockerMan/templates-user
curl -o /boot/config/plugins/dockerMan/templates-user/openclaw.xml \
  https://raw.githubusercontent.com/darksoon/unraid-openclaw/main/openclaw.xml
```

Or use the install script:
```bash
curl -fsSL https://raw.githubusercontent.com/darksoon/unraid-openclaw/main/install.sh | bash
```

**Step 2: Create container**
1. Unraid UI → Docker → **Add Container** → Template: **OpenClaw**
2. Generate **Gateway Token**: `openssl rand -hex 24`
3. Enter at least **one API key** (e.g. Anthropic, OpenRouter, or Gemini)
4. **Apply**

**Alternative: Secrets via .env file**

The install script automatically creates a `.env` file at `/mnt/user/appdata/openclaw/config/.env`.
```bash
# Edit keys
nano /mnt/user/appdata/openclaw/config/.env
```
Then set "Env File" in the template to `/mnt/user/appdata/openclaw/config/.env`.
Template variables can be left empty — .env overrides on conflicts.

**Step 3: Access**
```
http://YOUR-IP:18789/?token=YOUR_TOKEN
```

**Step 4: Optional - Onboarding**
```bash
docker exec -it OpenClaw openclaw onboard
```
Guides through initial setup (model selection, skills, etc.)

### Image Tag: `:main` vs `:latest`

| Tag | Behavior | Recommendation |
|---|---|---|
| `:main` | Updated on every push to main branch | ✅ **Recommended** |
| `:latest` | Only on tagged releases — **often lags behind by days!** | ⚠️ Not recommended |
| `:2026.2.21` | Pinned version, change manually | For maximum stability |

**Why `:main`?** There have been cases where `2026.2.21` was released but `:latest` still pointed to `2026.1.30`. With `:main` you get everything instantly.

**Manual update:** Unraid Docker → OpenClaw → **Force Update** (or `docker pull ghcr.io/openclaw/openclaw:main`)

### CLI Access

```bash
docker exec -it OpenClaw openclaw doctor              # Health check
docker exec -it OpenClaw openclaw models list          # Available models
docker exec -it OpenClaw openclaw onboard              # Setup wizard
docker exec -it OpenClaw openclaw channels login       # WhatsApp QR
docker exec -it OpenClaw openclaw channels add --channel telegram --token "TOKEN"
docker exec -it OpenClaw openclaw config set agents.defaults.model.primary anthropic/claude-opus-4-6
docker exec -it OpenClaw openclaw skills install humanizer
docker exec -it OpenClaw openclaw --version
```

### Free Web Search Alternatives

Brave killed their free tier! Here are the alternatives:

#### SearXNG — Completely free, self-hosted (recommended for Unraid!)

Aggregates Google, DuckDuckGo, Brave, Bing and 70+ engines. Run as a second container on Unraid:

```bash
docker run -d \
  --name searxng \
  --restart unless-stopped \
  -p 8888:8080 \
  -e SEARXNG_BASE_URL=http://localhost:8888 \
  searxng/searxng:latest
```

Then set **SearXNG URL** in the template to `http://YOUR-UNRAID-IP:8888` and install the skill:
```bash
docker exec -it OpenClaw openclaw skills install local-websearch
```

#### Serper.dev — 2,500 queries/month free
Google Search API. Register at [serper.dev](https://serper.dev), enter key in template.

#### Tavily — Free tier with AI-optimized results
Register at [app.tavily.com](https://app.tavily.com), enter key in template.

### Providers with additional config

Some providers need config in `/mnt/user/appdata/openclaw/config/openclaw.json` in addition to the API key. See [PROVIDERS.md](PROVIDERS.md) for complete guides.

**Quick overview:**
- **Anthropic, OpenAI, OpenRouter, Gemini, xAI, Groq, Cerebras, Mistral** → Just set API key in template, done!
- **DeepSeek, Moonshot/Kimi, MiniMax, Ollama** → API key in template + `models.providers` config in openclaw.json
- **SearXNG** → No API key needed, just the URL

### Troubleshooting

```bash
# Check logs
docker logs OpenClaw 2>&1 | tail -100

# Fix config
cat > /mnt/user/appdata/openclaw/config/openclaw.json << 'EOF'
{"gateway":{"mode":"local","bind":"lan","controlUi":{"allowInsecureAuth":true},"auth":{"mode":"token"}}}
EOF
docker restart OpenClaw

# Check version
docker exec -it OpenClaw openclaw --version
```

---

## License

MIT — Free to use, modify, and distribute.

## Credits

- **OpenClaw** — [Peter Steinberger](https://twitter.com/steipete) and the OpenClaw community
- **Original Template** — [@jdhill777](https://github.com/jdhill777/openclaw-unraid)
- **This Template** — [@darksoon](https://github.com/darksoon/unraid-openclaw)
