---
layout: default
title: Kai 專案 - 入門指南
lang: zh
---

# Kai 專案入門指南

本指南將協助您設定並開始使用 Kai 容器管理平台。

## 先決條件

開始之前，請確保您已安裝以下軟體：

- Docker Engine
- Node.js（v16 或更高版本）
- pnpm 套件管理器
- Git

## 安裝

### 1. 複製儲存庫

```bash
git clone https://github.com/misterlex223/Kai.git
cd Kai
```

### 2. 安裝相依套件

```bash
pnpm install
```

### 3. 環境配置

在根目錄建立 `.env` 檔案，包含以下變數：

```env
IMAGE_NAME=flexy-dev-sandbox:latest
DOCKER_NETWORK=kai-net
PORT=3000
```

## 執行應用程式

### 1. 啟動 Docker 網路

首先，確保您有 Kai 和 Flexy 容器的 Docker 網路：

```bash
docker network create kai-net
```

### 2. 啟動後端

```bash
cd backend
pnpm dev
```

### 3. 啟動前端

在新終端機中：

```bash
cd frontend
pnpm dev
```

## 建立您的第一個 Flexy 容器

1. 在瀏覽器中開啟 `http://localhost:5173`
2. 點選「建立新 Flexy」按鈕
3. 填寫表單：
   - 容器名稱：例如 "my-first-flexy"
   - 主機路徑：例如 "/home/user/my-project"
   - 容器路徑：例如 "/workspace"
4. 點選「建立」

## 使用 Shell 介面

建立 Flexy 容器後：

1. 在容器清單中，點選「進入 Shell」按鈕
2. 終端機介面將在 iframe 中載入
3. 您現在可以在容器內執行命令

## API 端點

後端提供以下 API 端點：

- `GET /api/flexy` - 列出所有 Flexy 容器
- `POST /api/flexy` - 建立新 Flexy 容器
- `DELETE /api/flexy/:id` - 刪除 Flexy 容器
- `POST /api/flexy/:id/start` - 啟動 Flexy 容器
- `POST /api/flexy/:id/stop` - 停止 Flexy 容器

## 開發

### 專案結構

```
Kai/
├── backend/          # Node.js Express 後端
├── frontend/         # React/Vite 前端
├── docs/             # 文件
├── templates/        # 各種組件的模板
└── package.json
```

### 後端開發

後端使用 Express.js 建置並處理：

- Docker API 互動
- 容器生命週期管理
- Flexy 容器的代理路由
- API 驗證和驗證

### 前端開發

前端使用：

- 帶有 TypeScript 的 React
- Vite 進行捆綁和開發
- Tailwind CSS 進行樣式設計
- Shadcn UI 組件

## 疑難排解

### 常見問題

#### Docker 權限錯誤
如果您遇到 Docker 權限錯誤，請確保您的使用者在 docker 群組中：

```bash
sudo usermod -aG docker $USER
```

然後登出並重新登入。

#### 埠口已在使用中
如果埠口已在使用中，請變更 PORT 環境變數或停止衝突的服務。

#### 網路問題
確保 Docker 網路（預設為 kai-net）在啟動應用程式前存在。

## 下一步

現在您已讓 Kai 運行，您可以：

1. 探索容器管理介面
2. 在 API 文件中了解 API 端點
3. 檢閱架構文件以深入了解
4. 嘗試建立多個容器並透過 Kai 管理它們