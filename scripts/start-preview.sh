#!/bin/bash

# Script to start local preview of the Jekyll site
# This script sets up the environment and starts the Jekyll development server

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the correct directory
if [[ ! -f "_config.yml" ]]; then
    print_error "This script must be run from the root of the Jekyll site directory."
    print_error "Please navigate to the aintandem.github.io directory and try again."
    exit 1
fi

# Set up environment variables
export GEM_HOME="$HOME/.gem"
export PATH="$HOME/.gem/bin:$PATH"

print_info "Checking for required tools..."

# Check if Ruby is installed
if ! command -v ruby &> /dev/null; then
    print_error "Ruby is not installed. Please install Ruby before running this script."
    exit 1
fi

# Check if Jekyll is installed
if ! command -v jekyll &> /dev/null; then
    print_error "Jekyll is not installed. Installing Jekyll..."
    gem install jekyll bundler
fi

# Check if Bundler is installed
if ! command -v bundle &> /dev/null; then
    print_error "Bundler is not installed. Installing Bundler..."
    gem install bundler
fi

print_info "Installing required gems..."
bundle install

# Check if installation was successful
if [ $? -ne 0 ]; then
    print_error "Failed to install required gems. Please check the error messages above."
    exit 1
fi

print_info "Starting Jekyll server..."
print_info "The site will be available at http://localhost:4000"
print_info "Press Ctrl+C to stop the server"

# Start the Jekyll server
bundle exec jekyll serve --watch --drafts --host=0.0.0.0 --port=4000