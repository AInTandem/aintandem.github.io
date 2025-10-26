---
layout: docs-with-lang-switcher
title: Kai Project - Technical Architecture
lang: en
---

# Kai Project - Technical Architecture

## Overview

The Kai–Flexy Container Management Platform is a web-based container management system that allows users to manage multiple Flexy containers through a web interface. The system utilizes Kai as a management interface which handles multiple Flexy containers, providing a routing proxy to access each Flexy's built-in ttyd shell without directly exposing container ports.

## System Components

### Kai (Management Interface)

- **Web UI**: React/Vite/Tailwind/Shadcn
- **Multi-container management**: Manage multiple Flexy containers
- **Reverse proxy**: Route user web requests to each Flexy's ttyd (port 9681)
- **Container controls**: Interface for operations (create, delete, start/stop, status view)

### Flexy (AI Agent Container)

- **AI Agent container**: Engineering-focused AI agent container
- **ttyd shell**: Provides ttyd shell on port 9681
- **No port mapping**: Only accessible via Kai routing
- **Folder mapping support**: Allows mounting host folders to container

## Architecture

### Technology Stack

#### Frontend
- React + Vite + TailwindCSS + Shadcn UI
- TypeScript for type safety
- API abstraction layer
- Environment-based configuration

#### Backend
- Node.js (Express or Fastify)
- Docker Engine API integration
- HTTP proxy middleware (for routing)
- SQLite/Firestore/Postgres for metadata storage

#### Container Management
- Docker Engine API
- Container lifecycle management
- Network configuration
- Volume mounting capabilities

### System Environment

- Docker Engine API access required
- Pre-built Flexy images (with ttyd pre-installed)
- Kai and Flexy on the same Docker Network
- Configuration via environment variables

### Key Environment Variables

- `IMAGE_NAME`: Flexy image name (default: `flexy-dev-sandbox:latest`)
- `DOCKER_NETWORK`: Docker network name for Kai-Flexy communication (default: `kai-net`)

## Core Features

### 1. Container Management UI

#### Container List
- Display all Flexys (ID, name, status, folder mapping, creation time)
- Operation buttons for:
  - Enter Shell (routes through Kai to ttyd)
  - Start/Stop
  - Delete

#### Create New Flexy
- Form-based creation with:
  - Flexy name
  - Folder mapping (host path → container path)
- Docker API call to create container:
  ```bash
  docker run -d --name flexy_<id> -v /host/path:/container/path flexy-dev-sandbox:latest
  ```

#### Shell Interface
- Iframe or WebSocket proxy
- Access via `https://kai.local/flexy/{id}/shell`
- Requests forwarded to `http://flexy_{id}:9681`

### 2. Backend API

#### Container API Endpoints
- `GET /api/flexy`: Retrieve Flexy list
- `POST /api/flexy`: Create Flexy (with mapping)
- `DELETE /api/flexy/:id`: Delete container
- `POST /api/flexy/:id/start`: Start container
- `POST /api/flexy/:id/stop`: Stop container

#### Routing
- `GET /flexy/:id/shell/*`: Proxy to `http://flexy_{id}:9681/*`
- `GET /flexy/:id/docs/*`: Proxy to `http://flexy_{id}:8080/*` (optional)

#### Host Directory Browsing
- `POST /api/host/directories`: List host directories (limited to user home)
- Request body may include `currentPath`
- Path normalization and access control

### 3. Flexy Catalog (Persistent Management)

- Purpose: Long-term management of multiple Flexy projects with names and local paths
- Data Model: `FlexyCatalogItem { id: string, name: string, hostPath: string, containerId?: string, createdAt: ISO }`
- Storage:
  - Local: JSON file or SQLite (deployment strategy dependent)
  - Team/Cloud: External DB (future expansion)
- API Endpoints:
  - `GET /api/catalog/flexy`: List catalog
  - `POST /api/catalog/flexy`: Add `{ name, hostPath }`
  - `DELETE /api/catalog/flexy/{id}`: Remove catalog item (not necessarily delete container)

## Non-functional Requirements

### Security
- Flexy containers not directly exposed
- Kai API authentication (JWT/Session)
- Shell routing includes login token verification

### Scalability
- Kai supports multiple Flexys
- Pluggable routing layer (Node.js proxy or Nginx/Traefik)
- Distributed container management support

### Usability
- UI follows Shadcn UI design guidelines
- List filtering and search capabilities
- Responsive design for various device sizes

## Deployment Architecture

```
[ Browser ]
     |
     v
[ Kai Web UI (React) ]  <--> [ Kai API (Node.js) ]
                                   |
                                   v
                     [ Docker Engine / API ]
                                   |
        ------------------------------------------------
        |                       |                      |
   [ Flexy A (ttyd:9681) ]  [ Flexy B (ttyd:9681) ]  ...
        ^                       ^
        |                       |
        -------- Kai Routing ----
```

## Development Guidelines

### Frontend Development
- Use Vite for development server
- Component-based architecture
- TypeScript interfaces for API responses
- Tailwind CSS for styling with Shadcn UI components
- Environment-specific configuration

### Backend Development
- Express.js with type-safe routing
- Docker API wrapper for container operations
- HTTP proxy middleware for request routing
- Database abstraction layer for metadata persistence
- Comprehensive error handling

## API Contract

- OpenAPI specification available at `docs/specs/api/openapi.yaml`
- Runtime schema available at `/openapi.json`
- Consistent error codes and response formats
- Validation against contract specifications

## Testing Strategy

### Frontend
- Unit tests with Vitest
- Integration tests for API interactions
- Component testing with React Testing Library

### Backend
- Unit tests for business logic
- Integration tests for Docker API interactions
- End-to-end tests with Playwright or MCP Puppeteer
- API contract validation