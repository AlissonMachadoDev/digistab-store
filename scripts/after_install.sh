#!/bin/bash

set -e
set -x

SCRIPT_START=$SECONDS
TIMEOUT=1200  # 20 minutos - mais realista
APP_DIR="/opt/digistab_store"

log_progress() {
    local elapsed=$((SECONDS - SCRIPT_START))
    echo "[$(date '+%H:%M:%S')] [$elapsed s] $1"
    
    if [ $elapsed -gt $TIMEOUT ]; then
        echo "TIMEOUT: Script exceeded ${TIMEOUT}s"
        exit 1
    fi
}

retry_command() {
    local max_attempts=3
    local delay=3
    local timeout_duration=120
    local cmd="$@"
    
    for attempt in $(seq 1 $max_attempts); do
        log_progress "Attempt $attempt: $cmd"
        if timeout $timeout_duration bash -c "$cmd"; then
            return 0
        fi
        [ $attempt -lt $max_attempts ] && sleep $delay
    done
    
    echo "FAILED: $cmd after $max_attempts attempts"
    exit 1
}

check_and_install_nodejs() {
    if command -v node &> /dev/null && command -v npm &> /dev/null; then
        log_progress "Node.js already installed: $(node --version)"
        return 0
    fi
    
    log_progress "Installing Node.js..."
    retry_command "
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg &&
        echo 'deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main' | sudo tee /etc/apt/sources.list.d/nodesource.list &&
        sudo apt-get update -qq &&
        sudo apt-get install -y nodejs
    "
    log_progress "Node.js installed: $(node --version)"
}

setup_environment() {
    export HOME="/home/ubuntu"
    export MIX_ENV=prod
    export PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"
    
    if [ ! -f "$HOME/.asdf/asdf.sh" ]; then
        echo "FATAL: asdf.sh not found"
        exit 1
    fi
    
    source "$HOME/.asdf/asdf.sh"
    cd "$APP_DIR" || { echo "FATAL: Cannot cd to $APP_DIR"; exit 1; }
}

install_build_tools() {
    if ! command -v rebar3 &> /dev/null; then
        log_progress "Installing rebar3..."
        retry_command "wget -q https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3 && sudo mv rebar3 /usr/local/bin/"
    fi
    
    log_progress "Installing hex/rebar..."
    timeout 60 mix local.hex --force || exit 1
    timeout 60 mix local.rebar --force || exit 1
}

install_dependencies() {
    log_progress "Getting Elixir dependencies..."
    timeout 300 mix deps.get --only prod || {
        echo "FATAL: mix deps.get failed"
        exit 1
    }
    
    log_progress "Installing npm dependencies..."
    cd assets || exit 1
    
    # Usar npm ci se package-lock.json existe (mais rápido)
    if [ -f "package-lock.json" ]; then
        timeout 300 npm ci --legacy-peer-deps --prefer-offline --no-audit --no-fund || {
            log_progress "npm ci failed, trying npm install..."
            timeout 300 npm install --legacy-peer-deps --prefer-offline --no-audit --no-fund
        }
    else
        timeout 300 npm install --legacy-peer-deps --prefer-offline --no-audit --no-fund
    fi
    
    cd .. || exit 1
}

build_application() {
    log_progress "Compiling application..."
    timeout 240 mix compile || {
        echo "FATAL: mix compile failed"
        exit 1
    }
    
    log_progress "Deploying assets..."
    timeout 300 mix assets.deploy || {
        echo "FATAL: mix assets.deploy failed"
        exit 1
    }
    
    log_progress "Creating release..."
    timeout 300 mix release --overwrite || {
        echo "FATAL: mix release failed"
        exit 1
    }
    
    # Verificação final
    if [ ! -f "_build/prod/rel/digistab_store/bin/digistab_store" ]; then
        echo "FATAL: Release binary not created"
        exit 1
    fi
}

cleanup_temp_files() {
    log_progress "Cleaning up..."
    # Remove cache desnecessário pra economizar espaço
    mix deps.clean --unused --build 2>/dev/null || true
    cd assets && npm cache clean --force 2>/dev/null || true
    cd ..
}

main() {
    log_progress "Starting deployment..."
    
    setup_environment
    check_and_install_nodejs
    install_build_tools
    install_dependencies
    build_application
    cleanup_temp_files
    
    local duration=$((SECONDS - SCRIPT_START))
    log_progress "SUCCESS: Deployment completed in ${duration}s"
}

# Handle script interruption
trap 'echo "Script interrupted at $((SECONDS - SCRIPT_START))s"; exit 1' INT TERM

main "$@"