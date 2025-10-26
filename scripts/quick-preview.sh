#!/bin/bash

# Simple script to start the Jekyll server for local preview
# Assumes all dependencies are already installed

# Define colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# Check if we're in the correct directory
if [[ ! -f "_config.yml" ]]; then
    echo "[ERROR] This script must be run from the root of the Jekyll site directory."
    echo "[ERROR] Please navigate to the aintandem.github.io directory and try again."
    exit 1
fi

print_info "Starting Jekyll server..."
print_info "The site will be available at http://localhost:4000"
print_info "Press Ctrl+C to stop the server"

# Set up environment variables
export GEM_HOME="$HOME/.gem"
export PATH="$HOME/.gem/bin:$PATH"

# Start the Jekyll server
bundle exec jekyll serve --watch --drafts --host=0.0.0.0 --port=4000