# 🎓 Multi-Agent Course Generator

An AI-powered course generation system built with **Google ADK** and **A2A protocol**. Enter any topic and a team of specialized AI agents will research, fact-check, and write a complete course for you.

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Frontend (port 8000)               │
│              React-like UI  ·  app/main.py           │
└─────────────────────┬───────────────────────────────┘
                      │ A2A
┌─────────────────────▼───────────────────────────────┐
│              Orchestrator (port 8004)                │
│         SequentialAgent + LoopAgent pipeline         │
└────┬──────────────────┬──────────────────┬───────────┘
     │ A2A              │ A2A              │ A2A
┌────▼──────┐    ┌──────▼──────┐   ┌──────▼──────────┐
│ Researcher│    │    Judge    │   │ Content Builder  │
│ port 8001 │    │  port 8002  │   │   port 8003      │
│           │    │             │   │                  │
│ Searches  │    │ Evaluates   │   │ Transforms       │
│ the web   │    │ research    │   │ findings into    │
│ via Gemini│    │ quality     │   │ a structured     │
│           │    │ (pass/fail) │   │ course           │
└───────────┘    └─────────────┘   └──────────────────┘
```

### Pipeline Flow

1. **Researcher** — searches the web using Google Search to gather information on the topic
2. **Judge** — evaluates the research quality (`pass` / `fail`)
3. If `fail` → feedback is sent back to the Researcher (up to 3 iterations)
4. If `pass` → **Content Builder** transforms findings into a structured course
5. The final course is streamed back to the user's browser

## Prerequisites

- Python 3.12+
- [uv](https://docs.astral.sh/uv/) package manager
- A [Google Gemini API key](https://ai.google.dev/gemini-api/docs/api-key)

## Setup

**1. Clone and install dependencies:**
```bash
git clone <repo-url>
cd mutliagent-course-generator
uv sync
```

**2. Set your Gemini API key in each agent's `.env`:**
```bash
echo "GOOGLE_API_KEY=your_key_here" > agents/researcher/.env
echo "GOOGLE_API_KEY=your_key_here" > agents/judge/.env
echo "GOOGLE_API_KEY=your_key_here" > agents/content_builder/.env
echo "GOOGLE_API_KEY=your_key_here" > agents/orchestrator/.env
```

Or copy the root `.env`:
```bash
echo "GOOGLE_API_KEY=your_key_here" > .env
```

## Running Locally

Start all agents and the frontend with a single command:

```bash
./run_local.sh
```

This starts:
| Service | Port |
|---|---|
| Researcher Agent | 8001 |
| Judge Agent | 8002 |
| Content Builder Agent | 8003 |
| Orchestrator Agent | 8004 |
| Frontend App | 8000 |

Open [http://localhost:8000](http://localhost:8000) in your browser.

## Running with Docker

Build and run individual agents:
```bash
docker build -t researcher agents/researcher/
docker build -t judge agents/judge/
docker build -t content-builder agents/content_builder/
docker build -t course-app app/

docker run -d --name researcher -p 8001:8001 researcher
docker run -d --name judge -p 8002:8002 judge
docker run -d --name content-builder -p 8003:8003 content-builder
docker run -d -p 8000:8000 -e AGENT_SERVER_URL=http://host.docker.internal:8004 course-app
```

## Project Structure

```
mutliagent-course-generator/
├── agents/
│   ├── researcher/        # Web research agent (port 8001)
│   ├── judge/             # Quality evaluation agent (port 8002)
│   ├── content_builder/   # Course writing agent (port 8003)
│   └── orchestrator/      # Pipeline coordinator (port 8004)
├── app/
│   ├── main.py            # FastAPI backend + SSE streaming
│   └── frontend/          # HTML/CSS/JS frontend
├── shared/
│   ├── adk_app.py         # Shared ADK server launcher
│   └── a2a_utils.py       # A2A utilities
└── run_local.sh           # Start all services locally
```

## Tech Stack

- **[Google ADK](https://google.github.io/adk-docs/)** — Agent framework
- **[A2A Protocol](https://github.com/google/a2a)** — Agent-to-agent communication
- **[Gemini 2.5 Pro](https://ai.google.dev/)** — LLM powering all agents
- **FastAPI + uvicorn** — HTTP servers
- **uv** — Python package management
