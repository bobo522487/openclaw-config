#!/bin/bash
# GitHub CLI Setup Script for Docker OpenClaw

# Ensure PATH includes local bin
export PATH="/home/node/.local/bin:$PATH"

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI not found. Installing..."
    # Auto-install if missing
    cd /tmp
    curl -fsSL -L https://github.com/cli/cli/releases/download/v2.50.0/gh_2.50.0_linux_amd64.tar.gz -o gh.tar.gz
    tar -xzf gh.tar.gz
    mkdir -p /home/node/.local/bin
    cp /tmp/gh_2.50.0_linux_amd64/bin/gh /home/node/.local/bin/gh
    chmod +x /home/node/.local/bin/gh
    rm -rf /tmp/gh_2.50.0_linux_amd64 /tmp/gh.tar.gz
    echo "GitHub CLI installed successfully."
fi

# Display version
gh --version

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "⚠️  GitHub CLI not authenticated."
    echo "To authenticate, run: gh auth login"
    echo "Or set GH_TOKEN environment variable with your personal access token."
else
    echo "✅ GitHub CLI is authenticated."
    gh auth status
fi
