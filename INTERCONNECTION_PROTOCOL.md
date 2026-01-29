# 设备互联协议文档 v2.0

本文档描述了 TimeWidgets 应用中“设备互联”功能的通信协议与工作流程。该功能旨在局域网环境下，实现主设备（Master）向从设备（Slave）高效、稳定地同步设置和课表数据。

## 1. 概述

设备互联采用 **主从架构 (Master-Slave)**，但在 v2.0 中引入了 **长连接 (Persistent Connection)** 和 **自定义传输协议 (TimeWidgets Transfer Protocol)** 以提升性能和稳定性。

*   **主设备 (Master)**：主动发现、维护连接池、发送心跳、推送数据。
*   **从设备 (Slave)**：广播存在、监听 TCP 端口、解析协议包、被动接收数据。

## 2. 发现与配对 (Discovery & Pairing)

### 2.1 首次发现 (UDP Broadcast)
*   **协议**: UDP Broadcast
*   **端口**: 8899
*   **广播频率**: 每 2 秒一次
*   **内容**: JSON (包含 `name`, `port`, `type`, `authToken`)

### 2.2 配对与 IP 恢复
*   **配对**: Master 保存 Slave 的 `authToken`。
*   **IP 恢复**: Master 连接失败时，向 UDP 8901 广播 `auth_recovery` 请求；Slave 收到后立即广播最新 IP。

## 3. 传输协议 (Transfer Protocol)

v2.0 弃用了纯 JSON 传输，改用自定义二进制协议，支持 **GZip 压缩** 和 **分包处理**。

### 3.1 数据包结构

所有 TCP 通信均遵循以下包结构：

| 字段 | 长度 (Byte) | 说明 |
| :--- | :--- | :--- |
| Magic 1 | 1 | 固定值 `0x54` ('T') |
| Magic 2 | 1 | 固定值 `0x57` ('W') |
| Version | 1 | 协议版本 (当前 `0x01`) |
| Type | 1 | 包类型 (见下表) |
| Length | 4 | Payload 长度 (大端序 uint32) |
| Payload | N | GZip 压缩后的 JSON 数据 |

### 3.2 包类型 (Packet Type)

| 值 | 名称 | 说明 |
| :--- | :--- | :--- |
| 0x01 | Handshake | 建立连接后的首个包，包含设备信息 |
| 0x02 | SyncData | 同步数据 (设置、课表) |
| 0x03 | Heartbeat | 心跳包 (空 Payload)，用于保活 |
| 0x04 | Ack | 确认包 (可选) |
| 0x05 | Disconnect | 断开连接通知 |

## 4. 连接管理

### 4.1 长连接与心跳
*   **连接池**: Master 维护 `_activeConnections` 映射表，复用 TCP 连接，避免频繁握手开销。
*   **心跳机制**: Master 每 10 秒向所有活跃连接发送 `Heartbeat` 包。Slave 收到后维持连接活跃状态。

### 4.2 粘包与分包处理
*   接收端通过解析 Header 中的 `Length` 字段，精确读取完整的 Payload，解决了 TCP 流式传输中的粘包和半包问题。

## 5. 数据同步
同步数据 (Type 0x02) 的 Payload 解压后为 JSON：
```json
{
  "settings": { ... },
  "timetable": { ... }
}
```

## 6. 安全性
*   **身份验证**: Handshake 包中包含 `authToken`。
*   **加密**: 目前仅通过 GZip 压缩混淆，未来版本将引入 AES 加密。
