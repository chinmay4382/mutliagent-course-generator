#!/bin/bash
# Run the agents locally using uvicorn
lsof -ti:8000,8001,8002,8003,8004 | xargs kill -9 2>/dev/null
cd "$(dirname "$0")"
echo "Starting Researcher Agent on port 8001..."
pushd agents/researcher
uv run python ../../shared/adk_app.py --host 0.0.0.0 --port 8001 --a2a . &
RESEARCHER_PID=$!
popd

echo "Starting Judge Agent on port 8002..."
pushd agents/judge
uv run python ../../shared/adk_app.py --host 0.0.0.0 --port 8002 --a2a . &
JUDGE_PID=$!
popd

echo "Starting Content Builder Agent on port 8003..."
pushd agents/content_builder
uv run python ../../shared/adk_app.py --host 0.0.0.0 --port 8003 --a2a . &
CONTENT_BUILDER_PID=$!
popd


echo "Starting Orchestrator Agent on port 8004..."
pushd agents/orchestrator
uv run python ../../shared/adk_app.py --host 0.0.0.0 --port 8004 --a2a . &
ORCHESTRATOR_PID=$!
popd

# Wait a bit for them to start up
sleep 5


echo "Starting Orchestrator Agent on port 8000..."
pushd app
export AGENT_SERVER_URL=http://localhost:8004

uv run uvicorn main:app --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!
popd