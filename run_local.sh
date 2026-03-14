#!/bin/bash
# Run the agents locally using uvicorn

echo "Starting Researcher Agent on port 8001..."
pushd agents/researcher
uv run ../../shared/adk_app.py --host 0.0.0.0 --port 8001 --a2a . &
RESEARCHER_PID=$!
popd

echo "Starting Judge Agent on port 8002..."
pushd agents/judge
uv run ../../shared/adk_app.py --host 0.0.0.0 --port 8002 --a2a . &
JUDGE_PID=$!
popd

echo "Starting Content Builder Agent on port 8003..."
pushd agents/content_builder
uv run ../../shared/adk_app.py --host 0.0.0.0 --port 8003 --a2a . &
CONTENT_BUILDER_PID=$!
popd


echo "Starting Orchestrator Agent on port 8004..."
pushd agents/orchestrator
uv run ../../shared/adk_app.py --host 0.0.0.0 --port 8004 --a2a . &
ORCHESTRATOR_PID=$!
popd

# Wait a bit for them to start up
sleep 5