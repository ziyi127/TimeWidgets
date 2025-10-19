# TimeWidgets 后端API设计规范

## 1. API基础信息

- **基础URL**: `/api/v1`
- **协议**: HTTP/HTTPS
- **数据格式**: JSON
- **字符编码**: UTF-8

## 2. API端点设计

### 2.1 获取课程表数据

- **URL**: `/timetable`
- **方法**: `GET`
- **描述**: 获取指定日期的课程表数据
- **查询参数**:
  - `date` (可选): 日期字符串，格式为 `YYYY-MM-DD`，默认为当天日期
- **成功响应**:
  ```json
  {
    "date": "2023-10-15",
    "courses": [
      {
        "subject": "语文",
        "teacher": "张老师",
        "time": "08:30-09:10",
        "classroom": "101教室",
        "isCurrent": true
      },
      {
        "subject": "数学",
        "teacher": "李老师",
        "time": "09:20-10:00",
        "classroom": "102教室",
        "isCurrent": false
      }
    ]
  }
  ```
- **错误响应**:
  ```json
  {
    "error": "Invalid date format",
    "code": 400
  }
  ```

### 2.2 获取当前课程

- **URL**: `/current-course`
- **方法**: `GET`
- **描述**: 获取当前正在进行的课程信息
- **成功响应**:
  ```json
  {
    "subject": "语文",
    "teacher": "张老师",
    "time": "08:30-09:10",
    "classroom": "101教室",
    "isCurrent": true
  }
  ```
- **错误响应**:
  ```json
  {
    "error": "No current course",
    "code": 404
  }
  ```

### 2.3 获取天气信息

- **URL**: `/weather`
- **方法**: `GET`
- **描述**: 获取当前天气信息
- **成功响应**:
  ```json
  {
    "condition": "晴",
    "temperature": "20～25°C",
    "icon": "☀️"
  }
  ```
- **错误响应**:
  ```json
  {
    "error": "Weather service unavailable",
    "code": 503
  }
  ```

### 2.4 获取倒计时信息

- **URL**: `/countdown`
- **方法**: `GET`
- **描述**: 获取下一个重要事件的倒计时信息
- **成功响应**:
  ```json
  {
    "event": "中考",
    "daysRemaining": 10
  }
  ```
- **错误响应**:
  ```json
  {
    "error": "No upcoming events",
    "code": 404
  }
  ```

## 3. HTTP状态码

- `200`: 请求成功
- `400`: 请求参数错误
- `404`: 资源未找到
- `500`: 服务器内部错误
- `503`: 服务不可用

## 4. 错误处理

所有错误响应都遵循统一格式：
```json
{
  "error": "错误描述信息",
  "code": HTTP状态码
}
```