---
layout: docs-with-lang-switcher
title: Kai 專案 - 技術架構
lang: zh
---

# Kai 專案 - 技術架構

## 概述

Kai–Flexy 容器管理平台是一個基於網頁的容器管理系統，讓使用者能透過網頁介面管理多個 Flexy 容器。系統利用 Kai 作為管理介面來處理多個 Flexy 容器，提供路由代理來存取每個 Flexy 內建的 ttyd shell，而無需直接暴露容器埠口。

## 系統組件

### Kai（管理介面）

- **網頁 UI**：React/Vite/Tailwind/Shadcn
- **多容器管理**：管理多個 Flexy 容器
- **反向代理**：路由使用者網頁請求至各 Flexy 的 ttyd（埠口 9681）
- **容器控制**：操作介面（建立、刪除、啟停、狀態檢視）

### Flexy（AI 智能體容器）

- **AI 智能體容器**：工程導向的 AI 智能體容器
- **ttyd shell**：在埠口 9681 提供 ttyd shell
- **無埠口映射**：僅能透過 Kai 路由存取
- **資料夾映射支援**：允許將主機資料夾掛載至容器

## 架構

### 技術棧

#### 前端
- React + Vite + TailwindCSS + Shadcn UI
- TypeScript 確保型別安全
- API 抽象層
- 環境為基礎的配置

#### 後端
- Node.js（Express 或 Fastify）
- Docker Engine API 整合
- HTTP 代理中介軟體（用於路由）
- SQLite/Firestore/Postgres 用於中繼資料儲存

#### 容器管理
- Docker Engine API
- 容器生命週期管理
- 網路配置
- 卷冊掛載功能

### 系統環境

- 需要 Docker Engine API 存取權限
- 預先建置的 Flexy 映像檔（預先安裝 ttyd）
- Kai 與 Flexy 在同一 Docker 網路
- 透過環境變數配置

### 重要環境變數

- `IMAGE_NAME`：Flexy 映像檔名稱（預設：`flexy-dev-sandbox:latest`）
- `DOCKER_NETWORK`：Kai-Flexy 通訊的 Docker 網路名稱（預設：`kai-net`）

## 核心功能

### 1. 容器管理 UI

#### 容器清單
- 顯示所有 Flexy（ID、名稱、狀態、資料夾映射、建立時間）
- 操作按鈕包含：
  - 進入 Shell（透過 Kai 路由至 ttyd）
  - 啟動/停止
  - 刪除

#### 建立新 Flexy
- 表單為基礎的建立方式包含：
  - Flexy 名稱
  - 資料夾映射（主機路徑 → 容器路徑）
- Docker API 呼叫建立容器：
  ```bash
  docker run -d --name flexy_<id> -v /host/path:/container/path flexy-dev-sandbox:latest
  ```

#### Shell 介面
- Iframe 或 WebSocket 代理
- 透過 `https://kai.local/flexy/{id}/shell` 存取
- 請求轉發至 `http://flexy_{id}:9681`

### 2. 後端 API

#### 容器 API 端點
- `GET /api/flexy`：取得 Flexy 清單
- `POST /api/flexy`：建立 Flexy（含映射）
- `DELETE /api/flexy/:id`：刪除容器
- `POST /api/flexy/:id/start`：啟動容器
- `POST /api/flexy/:id/stop`：停止容器

#### 路由
- `GET /flexy/:id/shell/*`：代理至 `http://flexy_{id}:9681/*`
- `GET /flexy/:id/docs/*`：代理至 `http://flexy_{id}:8080/*`（選用）

#### 主機目錄瀏覽
- `POST /api/host/directories`：列出主機目錄（限於使用者家目錄）
- 請求本文可包含 `currentPath`
- 路徑正規化與存取控制

### 3. Flexy 型錄（持久化管理）

- 目的：長期管理多個 Flexy 專案與其名稱及本機路徑
- 資料模型：`FlexyCatalogItem { id: string, name: string, hostPath: string, containerId?: string, createdAt: ISO }`
- 儲存：
  - 本機：JSON 檔案或 SQLite（部署策略相依）
  - 團隊/雲端：外部資料庫（未來擴充）
- API 端點：
  - `GET /api/catalog/flexy`：列出型錄
  - `POST /api/catalog/flexy`：新增 `{ name, hostPath }`
  - `DELETE /api/catalog/flexy/{id}`：移除型錄項目（不一定刪除容器）

## 非功能性需求

### 安全性
- Flexy 容器不直接暴露
- Kai API 驗證（JWT/Session）
- Shell 路由包含登入權杖驗證

### 可擴展性
- Kai 支援多個 Flexy
- 可插入式路由層（Node.js 代理或 Nginx/Traefik）
- 分散式容器管理支援

### 使用性
- UI 遵循 Shadcn UI 設計指南
- 清單過濾與搜尋功能
- 適應各種裝置尺寸的響應式設計

## 部署架構

```
[ 瀏覽器 ]
     |
     v
[ Kai 網頁 UI (React) ]  <--> [ Kai API (Node.js) ]
                                   |
                                   v
                     [ Docker Engine / API ]
                                   |
        ------------------------------------------------
        |                       |                      |
   [ Flexy A (ttyd:9681) ]  [ Flexy B (ttyd:9681) ]  ...
        ^                       ^
        |                       |
        -------- Kai 路由 ----
```

## 開發指南

### 前端開發
- 使用 Vite 作為開發伺服器
- 組件為基礎的架構
- API 回應的 TypeScript 介面
- Shadcn UI 元件搭配 Tailwind CSS 樣式
- 環境特定配置

### 後端開發
- Express.js 搭配型別安全路由
- Docker API 包裝器用於容器操作
- HTTP 代理中介軟體用於請求路由
- 中繼資料持久化的資料庫抽象層
- 全面的錯誤處理

## API 契約

- OpenAPI 規格於 `docs/specs/api/openapi.yaml`
- 執行期規格於 `/openapi.json`
- 一致的錯誤代碼與回應格式
- 契約規格驗證

## 測試策略

### 前端
- 使用 Vitest 的單元測試
- API 互動整合測試
- React Testing Library 的元件測試

### 後端
- 商業邏輯的單元測試
- Docker API 互動整合測試
- Playwright 或 MCP Puppeteer 的端到端測試
- API 契約驗證