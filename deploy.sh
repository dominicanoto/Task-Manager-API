#!/usr/bin/env bash
# Run from Linux, WSL or Git Bash: bash deploy.sh [up|down|status|logs]
set -Eeuo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

usage() {
    echo "Usage: bash deploy.sh [up|down|status|logs]"
}

action="${1:-up}"
if (( $# > 1 )); then
    usage >&2
    exit 2
fi
case "$action" in
    up|down|status|logs) ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
esac

if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is missing. Install Docker Engine or Docker Desktop." >&2
    exit 1
fi
if ! docker info >/dev/null 2>&1; then
    echo "Docker daemon is unavailable. Start Docker and check access permissions." >&2
    exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
    echo "Docker Compose v2 is required." >&2
    exit 1
fi

case "$action" in
    up)
        docker compose config --quiet
        if ! docker compose up --build --detach --wait --wait-timeout 180; then
            docker compose ps --all >&2
            docker compose logs --no-color --tail=100 >&2
            exit 1
        fi
        docker compose ps
        echo "API: http://localhost:${APP_PORT:-8080}/tasks"
        echo "Gateway: http://localhost:${GATEWAY_PORT:-8081}/tasks"
        ;;
    down) docker compose down ;;
    status) docker compose ps --all ;;
    logs) docker compose logs --follow --tail=100 ;;
esac
