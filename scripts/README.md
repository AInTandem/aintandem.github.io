# AinTandem Website Scripts

This directory contains scripts for managing and previewing the AinTandem website locally.

## Preview Scripts

### start-preview.sh
This script sets up the complete environment and starts the Jekyll development server. It will:
- Check for required tools (Ruby, Jekyll, Bundler)
- Install any missing dependencies
- Install required gems
- Start the Jekyll server

Usage:
```bash
./scripts/start-preview.sh
```

### quick-preview.sh
This is a simpler script that assumes all dependencies are already installed. It will:
- Check that you're in the correct directory
- Start the Jekyll server

Usage:
```bash
./scripts/quick-preview.sh
```

## Accessing the Site

Once the server is running, you can access the site at:
- Main site: http://localhost:4000
- Kai English documentation: http://localhost:4000/kai/en/
- Kai Chinese documentation: http://localhost:4000/kai/zh/

## Stopping the Server

To stop the server, press `Ctrl+C` in the terminal where it's running.

## Requirements

- Ruby (version 2.5 or higher)
- Jekyll
- Bundler

The `start-preview.sh` script will automatically install Jekyll and Bundler if they're not already installed.