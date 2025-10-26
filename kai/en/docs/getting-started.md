---
layout: default
title: Kai Project - Getting Started Guide
lang: en
---

# Getting Started with Kai Project

This guide will help you set up and start using the Kai container management platform.

## Prerequisites

Before you begin, ensure you have the following installed:

- Docker Engine
- Node.js (v16 or higher)
- pnpm package manager
- Git

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/misterlex223/Kai.git
cd Kai
```

### 2. Install Dependencies

```bash
pnpm install
```

### 3. Environment Configuration

Create a `.env` file in the root directory with the following variables:

```env
IMAGE_NAME=flexy-dev-sandbox:latest
DOCKER_NETWORK=kai-net
PORT=3000
```

## Running the Application

### 1. Start Docker Network

First, ensure you have a Docker network for Kai and Flexy containers:

```bash
docker network create kai-net
```

### 2. Start the Backend

```bash
cd backend
pnpm dev
```

### 3. Start the Frontend

In a new terminal:

```bash
cd frontend
pnpm dev
```

## Creating Your First Flexy Container

1. Open your browser to `http://localhost:5173`
2. Click on "Create New Flexy" button
3. Fill in the form:
   - Container name: e.g., "my-first-flexy"
   - Host path: e.g., "/home/user/my-project"
   - Container path: e.g., "/workspace"
4. Click "Create"

## Using the Shell Interface

After creating a Flexy container:

1. In the container list, click the "Enter Shell" button
2. The terminal interface will load in an iframe
3. You can now run commands inside the container

## API Endpoints

The backend provides the following API endpoints:

- `GET /api/flexy` - List all Flexy containers
- `POST /api/flexy` - Create a new Flexy container
- `DELETE /api/flexy/:id` - Delete a Flexy container
- `POST /api/flexy/:id/start` - Start a Flexy container
- `POST /api/flexy/:id/stop` - Stop a Flexy container

## Development

### Project Structure

```
Kai/
├── backend/          # Node.js Express backend
├── frontend/         # React/Vite frontend
├── docs/             # Documentation
├── templates/        # Templates for various components
└── package.json
```

### Backend Development

The backend is built with Express.js and handles:

- Docker API interactions
- Container lifecycle management
- Proxy routing to Flexy containers
- API authentication and validation

### Frontend Development

The frontend uses:

- React with TypeScript
- Vite for bundling and development
- Tailwind CSS for styling
- Shadcn UI components

## Troubleshooting

### Common Issues

#### Docker Permission Error
If you encounter Docker permission errors, ensure your user is in the docker group:

```bash
sudo usermod -aG docker $USER
```

Then log out and log back in.

#### Port Already in Use
If the ports are already in use, change the PORT environment variable or stop conflicting services.

#### Network Issues
Ensure the Docker network (kai-net by default) exists before starting the application.

## Next Steps

Now that you have Kai running, you can:

1. Explore the container management interface
2. Learn about the API endpoints in the API documentation
3. Review the architecture documentation for deeper understanding
4. Try creating multiple containers and managing them through Kai