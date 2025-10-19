const WebSocket = require('ws');
const path = require('path');

// 模拟数据
const timetableData = [
  {
    subject: "高等数学",
    teacher: "张老师",
    time: "08:00-09:40",
    classroom: "A101",
    isCurrent: true
  },
  {
    subject: "数据结构",
    teacher: "李老师", 
    time: "10:00-11:40",
    classroom: "B205",
    isCurrent: false
  },
  {
    subject: "计算机网络",
    teacher: "王老师",
    time: "14:00-15:40",
    classroom: "C302",
    isCurrent: false
  }
];

const weatherData = {
  location: "北京",
  temperature: 25,
  condition: "晴",
  humidity: 45,
  windSpeed: 10,
  icon: "sunny"
};

const countdownData = {
  id: '1',
  title: '期末考试',
  description: '计算机科学期末考试',
  targetDate: new Date(Date.now() + 45 * 24 * 60 * 60 * 1000), // 45天后
  type: 'exam',
  progress: 0.65,
  category: '学术'
};

// 创建WebSocket服务器
const wss = new WebSocket.Server({ port: 8081 });

console.log('WebSocket服务器已启动，监听端口8081');
console.log('进程间通信模式已启用');

wss.on('connection', (ws) => {
  console.log('新的WebSocket连接已建立');
  
  ws.on('message', (message) => {
    try {
      const request = JSON.parse(message);
      console.log('收到请求:', request.type);
      
      let response;
      
      switch (request.type) {
        case 'timetable':
          response = {
            success: true,
            data: timetableData
          };
          break;
          
        case 'current-course':
          const currentCourse = timetableData.find(course => course.isCurrent);
          response = {
            success: true,
            data: currentCourse || null
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
            error: '未知请求类型'
          };
      }
      
      ws.send(JSON.stringify(response));
    } catch (error) {
      console.error('处理请求时出错:', error);
      ws.send(JSON.stringify({
        success: false,
        error: error.message
      }));
    }
  });
  
  ws.on('close', () => {
    console.log('WebSocket连接已关闭');
  });
  
  ws.on('error', (error) => {
    console.error('WebSocket错误:', error);
  });
});