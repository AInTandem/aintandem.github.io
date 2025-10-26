---
layout: default
title: Kai Project - API Reference
lang: en
---

# Kai Project API Reference

This document provides a comprehensive reference to all API endpoints available in the Kai container management platform.

## Base URL

All API endpoints are prefixed with `/api`. For example, to access the Flexy containers list, use `/api/flexy`.

## Authentication

Most API endpoints require authentication. The system supports:

- JWT tokens in the Authorization header: `Authorization: Bearer <token>`
- Session-based authentication with cookies

## Common Response Format

All API responses follow the same structure:

```json
{
  "success": true,
  "data": {},
  "message": "Operation successful",
  "timestamp": "2023-01-01T00:00:00Z"
}
```

For errors:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Error description",
    "details": {}
  },
  "timestamp": "2023-01-01T00:00:00Z"
}
```

## Container Management API

### List Flexy Containers

`GET /api/flexy`

Retrieve a list of all Flexy containers.

#### Query Parameters
- `status` (optional): Filter by container status (running, stopped, paused)
- `limit` (optional): Maximum number of containers to return (default: 10)
- `offset` (optional): Number of containers to skip (for pagination)

#### Response
```json
{
  "success": true,
  "data": {
    "containers": [
      {
        "id": "container-id-1",
        "name": "my-flexy-container",
        "status": "running",
        "image": "flexy-dev-sandbox:latest",
        "createdAt": "2023-01-01T00:00:00Z",
        "hostPath": "/home/user/project",
        "containerPath": "/workspace"
      }
    ],
    "total": 1,
    "limit": 10,
    "offset": 0
  },
  "message": "Containers retrieved successfully"
}
```

### Create Flexy Container

`POST /api/flexy`

Create a new Flexy container.

#### Request Body
```json
{
  "name": "my-new-flexy",
  "image": "flexy-dev-sandbox:latest",
  "hostPath": "/home/user/project",
  "containerPath": "/workspace",
  "env": {
    "ENV_VAR": "value"
  }
}
```

#### Response
```json
{
  "success": true,
  "data": {
    "id": "new-container-id",
    "name": "my-new-flexy",
    "status": "created",
    "image": "flexy-dev-sandbox:latest",
    "createdAt": "2023-01-01T00:00:00Z",
    "hostPath": "/home/user/project",
    "containerPath": "/workspace"
  },
  "message": "Container created successfully"
}
```

### Get Flexy Container Details

`GET /api/flexy/:id`

Retrieve detailed information about a specific Flexy container.

#### Response
```json
{
  "success": true,
  "data": {
    "id": "container-id",
    "name": "my-flexy-container",
    "status": "running",
    "image": "flexy-dev-sandbox:latest",
    "createdAt": "2023-01-01T00:00:00Z",
    "hostPath": "/home/user/project",
    "containerPath": "/workspace",
    "ports": [
      {
        "hostPort": 32768,
        "containerPort": 9681
      }
    ],
    "volumes": [
      {
        "hostPath": "/home/user/project",
        "containerPath": "/workspace",
        "mode": "rw"
      }
    ]
  },
  "message": "Container details retrieved successfully"
}
```

### Delete Flexy Container

`DELETE /api/flexy/:id`

Remove a Flexy container.

#### Response
```json
{
  "success": true,
  "data": {
    "id": "deleted-container-id"
  },
  "message": "Container deleted successfully"
}
```

### Start Flexy Container

`POST /api/flexy/:id/start`

Start a stopped Flexy container.

#### Response
```json
{
  "success": true,
  "data": {
    "id": "container-id",
    "status": "starting"
  },
  "message": "Container start request submitted"
}
```

### Stop Flexy Container

`POST /api/flexy/:id/stop`

Stop a running Flexy container.

#### Response
```json
{
  "success": true,
  "data": {
    "id": "container-id",
    "status": "stopping"
  },
  "message": "Container stop request submitted"
}
```

### Restart Flexy Container

`POST /api/flexy/:id/restart`

Restart a Flexy container.

#### Response
```json
{
  "success": true,
  "data": {
    "id": "container-id",
    "status": "restarting"
  },
  "message": "Container restart request submitted"
}
```

## Flexy Catalog API

### List Catalog Items

`GET /api/catalog/flexy`

Retrieve a list of all Flexy catalog items (persistent management).

#### Response
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "catalog-item-id",
        "name": "My Project",
        "hostPath": "/home/user/my-project",
        "containerId": "container-id",
        "createdAt": "2023-01-01T00:00:00Z"
      }
    ]
  },
  "message": "Catalog items retrieved successfully"
}
```

### Add Catalog Item

`POST /api/catalog/flexy`

Add a new item to the Flexy catalog.

#### Request Body
```json
{
  "name": "My Project",
  "hostPath": "/home/user/my-project"
}
```

#### Response
```json
{
  "success": true,
  "data": {
    "id": "new-catalog-item-id",
    "name": "My Project",
    "hostPath": "/home/user/my-project",
    "createdAt": "2023-01-01T00:00:00Z"
  },
  "message": "Catalog item added successfully"
}
```

### Delete Catalog Item

`DELETE /api/catalog/flexy/:id`

Remove an item from the Flexy catalog.

#### Response
```json
{
  "success": true,
  "data": {
    "id": "deleted-catalog-item-id"
  },
  "message": "Catalog item removed successfully"
}
```

## Host Directory API

### List Host Directories

`POST /api/host/directories`

List directories on the host system, limited to the user's home directory for security.

#### Request Body
```json
{
  "currentPath": "/home/user/projects"  // Optional, defaults to user's home
}
```

#### Response
```json
{
  "success": true,
  "data": {
    "path": "/home/user/projects",
    "directories": [
      {
        "name": "project1",
        "path": "/home/user/projects/project1",
        "modified": "2023-01-01T00:00:00Z"
      },
      {
        "name": "project2",
        "path": "/home/user/projects/project2",
        "modified": "2023-01-02T00:00:00Z"
      }
    ],
    "files": [
      {
        "name": "README.md",
        "path": "/home/user/projects/README.md",
        "size": 1024,
        "modified": "2023-01-01T00:00:00Z"
      }
    ]
  },
  "message": "Directory listing retrieved successfully"
}
```

## System API

### Health Check

`GET /api/health`

Check the health status of the Kai system.

#### Response
```json
{
  "success": true,
  "data": {
    "status": "healthy",
    "timestamp": "2023-01-01T00:00:00Z",
    "services": {
      "api": "healthy",
      "docker": "healthy",
      "database": "healthy"
    }
  },
  "message": "Health check passed"
}
```

### Ready Check

`GET /api/ready`

Check if the Kai system is ready to handle requests.

#### Response
```json
{
  "success": true,
  "data": {
    "ready": true,
    "timestamp": "2023-01-01T00:00:00Z"
  },
  "message": "System is ready"
}
```

## Error Codes

The API uses the following standard error codes:

- `CONTAINER_NOT_FOUND`: The specified container does not exist
- `DOCKER_ERROR`: Error communicating with Docker daemon
- `PERMISSION_DENIED`: Insufficient permissions to perform the action
- `VALIDATION_ERROR`: Request parameters failed validation
- `NETWORK_ERROR`: Network-related issue
- `INTERNAL_ERROR`: Unexpected internal server error

## Webhook Events

The system can send webhook notifications for container lifecycle events. Configure webhooks through the settings API.