const express = require('express');
const cors = require('cors');
const net = require('net');
const fs = require('fs');
const path = require('path');

// 配置
const USE_HTTP = process.env.USE_HTTP === 'true'; // 是否使用HTTP模式
const PORT = process.env.PORT || 3000;
const PIPE_NAME = '\\\\.\\pipe\\TimeWidgetsPipe';

// 模拟数据
const timetableData = [
  {
    subject: "数学",
    teacher: "张老师",
    time: "08:00-09:30",
    classroom: "A101",
    isCurrent: false
  },
  {
    subject: "英语",
    teacher: "李老师",
    time: "10:00-11:30",
    classroom: "B202",
    isCurrent: true
  },
  {
    subject: "物理",
    teacher: "王老师",
    time: "14:00-15:30",
    classroom: "C303",
    isCurrent: false
  }
];

const weatherData = {
  city_name: "北京",
  description: "晴",
  temperature: "22℃",
  temperature_range: "8℃~18℃",
  aqilevel: 90,
  humidity: 65,
  wind: "东南风,2级",
  pressure: 1016,
  sunrise: 80760000,
  sunset: 34440000,
  weather_type: 0,
  publish_time: "1508143200000",
  locale: "zh_CN"
};

const countdownData = {
  id: '1',
  title: 'Final Exam',
  description: 'Computer Science Final Examination',
  targetDate: new Date('2024-12-15T09:00:00Z').toISOString(),
  type: 'exam',
  progress: 0.65,
  category: 'Academic'
};

// 处理请求的函数
function handleRequest(requestType, params = {}) {
  let response;
  
  switch(requestType) {
    case 'timetable':
      response = {
        success: true,
        data: timetableData
      };
      break;
      
    case 'current-course':
      const currentCourse = timetableData.find(course => course.isCurrent) || null;
      response = {
        success: true,
        data: currentCourse
      };
      break;
      
    case 'weather':
      response = {
        success: true,
        data: weatherData
      };
      break;
      
    case 'countdown':
      response = {
        success: true,
        data: countdownData
      };
      break;
      
    default:
      response = {
        success: false,
        error: `Unknown request type: ${requestType}`
      };
  }
  
  return response;
}

// HTTP服务器（用于兼容性）
if (USE_HTTP) {
  const app = express();
  app.use(cors());
  app.use(express.json());

  // API路由
  app.get('/api/timetable', (req, res) => {
    res.json(handleRequest('timetable'));
  });

  app.get('/api/current-course', (req, res) => {
    res.json(handleRequest('current-course'));
  });

  app.get('/api/weather', (req, res) => {
    res.json(handleRequest('weather'));
  });

  app.get('/api/countdown', (req, res) => {
    res.json(handleRequest('countdown'));
  });

  app.listen(PORT, () => {
    console.log(`HTTP Server is running on port ${PORT}`);
  });
}

// 命名管道服务器（进程间通信）
function startPipeServer() {
  const server = net.createServer((stream) => {
    console.log('客户端连接到命名管道');
    
    let buffer = '';
    
    stream.on('data', (data) => {
      buffer += data.toString();
      
      // 尝试解析完整的JSON消息
      try {
        const message = JSON.parse(buffer);
        buffer = ''; // 清空缓冲区
        
        console.log('收到请求:', message);
        
        // 处理请求
        const response = handleRequest(message.type, message.params);
        
        // 发送响应
        stream.write(JSON.stringify(response) + '\n');
        console.log('发送响应:', response);
      } catch (e) {
        // 数据不完整，等待更多数据
        if (!(e instanceof SyntaxError)) {
          console.error('处理请求时出错:', e);
          stream.write(JSON.stringify({
            success: false,
            error: e.message
          }) + '\n');
        }
      }
    });
    
    stream.on('end', () => {
      console.log('客户端断开连接');
    });
    
    stream.on('error', (err) => {
      console.error('管道错误:', err);
    });
  });
  
  // 删除已存在的管道（如果有）
  try {
    fs.unlinkSync(PIPE_NAME);
  } catch (e) {
    // 管道不存在，忽略错误
  }
  
  server.listen(PIPE_NAME, () => {
    console.log(`命名管道服务器已启动: ${PIPE_NAME}`);
  });
  
  server.on('error', (err) => {
    console.error('管道服务器错误:', err);
  });
}

// 启动命名管道服务器
startPipeServer();

console.log('服务器已启动');
console.log('HTTP模式:', USE_HTTP ? '启用' : '禁用');
console.log('进程间通信模式: 启用');