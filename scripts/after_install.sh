#!/bin/bash
set -e

echo "Starting after_install script..."

# Export environment variables
export HOME="/home/ubuntu"
export MIX_ENV=prod
export PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"

# Function to install Node.js
install_nodejs() {
    echo "Installing Node.js..."
    # Remove any existing nodejs installations
    sudo apt-get remove -y nodejs npm &>/dev/null || true
    sudo apt-get purge -y nodejs npm &>/dev/null || true
    
    # Install prerequisites
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg
    
    # Add Node.js official repository
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    
    # Update and install Node.js
    sudo apt-get update
    sudo apt-get install -y nodejs
    
    # Verify installation
    node --version
    npm --version
    
    echo "Node.js installation completed"
}

# Install Node.js if not present or if npm is not available
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
    install_nodejs
fi

# Double check Node.js and npm are available
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
    echo "ERROR: Node.js or npm installation failed"
    exit 1
fi

echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

# Source asdf if it exists
if [ -f "$HOME/.asdf/asdf.sh" ]; then
    . "$HOME/.asdf/asdf.sh"
    echo "Sourced asdf.sh"
else
    echo "Warning: asdf.sh not found"
fi

# Print environment information
echo "Current working directory: $(pwd)"
echo "HOME directory: $HOME"
echo "PATH: $PATH"

# Check Erlang
if command -v erl >/dev/null 2>&1; then
    echo "Erlang version: $(erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().'  -noshell)"
else
    echo "Error: Erlang not found"
    exit 1
fi

# Check Elixir
if command -v elixir >/dev/null 2>&1; then
    echo "Elixir version: $(elixir --version)"
else
    echo "Error: Elixir not found"
    exit 1
fi

# Navigate to application directory
cd /opt/digistab_store
echo "Changed to directory: $(pwd)"

wget https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3
sudo mv rebar3 /usr/local/bin/
rebar3 --version

# Install hex and rebar
echo "Installing hex and rebar..."
mix local.hex --force
mix local.rebar --force

# Get dependencies
echo "Getting dependencies..."
mix deps.get --only prod

# Install node dependencies for assets
echo "Installing node dependencies..."
cd assets
echo "In assets directory: $(pwd)"
# Check if package.json exists
if [ ! -f "package.json" ]; then
    echo "Error: package.json not found in $(pwd)"
    exit 1
fi
npm install --legacy-peer-deps
cd ..

# Compile and deploy assets
echo "Compiling and deploying assets..."
mix compile
mix assets.deploy

# Create production release
echo "Creating production release..."
mix release --overwrite

# Ensure the release was created
if [ ! -f "_build/prod/rel/digistab_store/bin/digistab_store" ]; then
    echo "Error: Release creation failed - binary not found"
    exit 1
fi

echo "After install script completed successfully"