---
layout: default
title: Kai 專案 - API 參考
lang: zh
---

# Kai 專案 API 參考

本文檔提供 Kai 容器管理平台中所有 API 端點的完整參考。

## 基底 URL

所有 API 端點都以 `/api` 為前綴。例如，要存取 Flexy 容器清單，請使用 `/api/flexy`。

## 驗證

大多數 API 端點需要驗證。系統支援：

- Authorization 標頭中的 JWT 權杖：`Authorization: Bearer <token>`
- 使用 Cookie 的基於工作階段的驗證

## 一般回應格式

所有 API 回應遵循相同結構：

```json
{
  "success": true,
  "data": {},
  "message": "操作成功",
  "timestamp": "2023-01-01T00:00:00Z"
}
```

對於錯誤：

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "錯誤描述",
    "details": {}
  },
  "timestamp": "2023-01-01T00:00:00Z"
}
```

## 容器管理 API

### 列出 Flexy 容器

`GET /api/flexy`

擷取所有 Flexy 容器的清單。

#### 查詢參數
- `status`（選用）：按容器狀態篩選（running, stopped, paused）
- `limit`（選用）：要傳回的最大容器數（預設：10）
- `offset`（選用）：要跳過的容器數（用於分頁）

#### 回應
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
  "message": "容器擷取成功"
}
```

### 建立 Flexy 容器

`POST /api/flexy`

建立新 Flexy 容器。

#### 要求本文
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

#### 回應
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
  "message": "容器建立成功"
}
```

### 取得 Flexy 容器詳細資料

`GET /api/flexy/:id`

擷取特定 Flexy 容器的詳細資料。

#### 回應
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
  "message": "容器詳細資料擷取成功"
}
```

### 刪除 Flexy 容器

`DELETE /api/flexy/:id`

移除 Flexy 容器。

#### 回應
```json
{
  "success": true,
  "data": {
    "id": "deleted-container-id"
  },
  "message": "容器刪除成功"
}
```

### 啟動 Flexy 容器

`POST /api/flexy/:id/start`

啟動已停止的 Flexy 容器。

#### 回應
```json
{
  "success": true,
  "data": {
    "id": "container-id",
    "status": "starting"
  },
  "message": "容器啟動要求已提交"
}
```

### 停止 Flexy 容器

`POST /api/flexy/:id/stop`

停止執行中的 Flexy 容器。

#### 回應
```json
{
  "success": true,
  "data": {
    "id": "container-id",
    "status": "stopping"
  },
  "message": "容器停止要求已提交"
}
```

### 重新啟動 Flexy 容器

`POST /api/flexy/:id/restart`

重新啟動 Flexy 容器。

#### 回應
```json
{
  "success": true,
  "data": {
    "id": "container-id",
    "status": "restarting"
  },
  "message": "容器重新啟動要求已提交"
}
```

## Flexy 型錄 API

### 列出型錄項目

`GET /api/catalog/flexy`

擷取所有 Flexy 型錄項目的清單（持久化管理）。

#### 回應
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "catalog-item-id",
        "name": "我的專案",
        "hostPath": "/home/user/my-project",
        "containerId": "container-id",
        "createdAt": "2023-01-01T00:00:00Z"
      }
    ]
  },
  "message": "型錄項目擷取成功"
}
```

### 新增型錄項目

`POST /api/catalog/flexy`

新增項目至 Flexy 型錄。

#### 要求本文
```json
{
  "name": "我的專案",
  "hostPath": "/home/user/my-project"
}
```

#### 回應
```json
{
  "success": true,
  "data": {
    "id": "new-catalog-item-id",
    "name": "我的專案",
    "hostPath": "/home/user/my-project",
    "createdAt": "2023-01-01T00:00:00Z"
  },
  "message": "型錄項目新增成功"
}
```

### 刪除型錄項目

`DELETE /api/catalog/flexy/:id`

從 Flexy 型錄移除項目。

#### 回應
```json
{
  "success": true,
  "data": {
    "id": "deleted-catalog-item-id"
  },
  "message": "型錄項目移除成功"
}
```

## 主機目錄 API

### 列出主機目錄

`POST /api/host/directories`

列出主機系統上的目錄，為安全起見限於使用者的家目錄。

#### 要求本文
```json
{
  "currentPath": "/home/user/projects"  // 選用，預設為使用者家目錄
}
```

#### 回應
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
  "message": "目錄清單擷取成功"
}
```

## 系統 API

### 健康檢查

`GET /api/health`

檢查 Kai 系統的健康狀態。

#### 回應
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
  "message": "健康檢查通過"
}
```

### 準備檢查

`GET /api/ready`

檢查 Kai 系統是否已準備好處理要求。

#### 回應
```json
{
  "success": true,
  "data": {
    "ready": true,
    "timestamp": "2023-01-01T00:00:00Z"
  },
  "message": "系統已準備就緒"
}
```

## 錯誤代碼

API 使用以下標準錯誤代碼：

- `CONTAINER_NOT_FOUND`：指定的容器不存在
- `DOCKER_ERROR`：與 Docker 守程通訊時發生錯誤
- `PERMISSION_DENIED`：執行操作權限不足
- `VALIDATION_ERROR`：要求參數驗證失敗
- `NETWORK_ERROR`：網路相關問題
- `INTERNAL_ERROR`：未預期的內部伺服器錯誤

## Webhook 事件

系統可以傳送容器生命週期事件的 webhook 通知。透過設定 API 配置 webhook。