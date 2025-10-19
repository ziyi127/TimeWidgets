const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3000;

// 中间件
app.use(cors());
app.use(express.json());

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

// API路由
// 获取课程表
app.get('/api/timetable', (req, res) => {
  res.json({
    success: true,
    data: timetableData
  });
});

// 获取当前课程
app.get('/api/current-course', (req, res) => {
  const currentCourse = timetableData.find(course => course.isCurrent) || null;
  res.json({
    success: true,
    data: currentCourse
  });
});

// 获取天气信息
app.get('/api/weather', (req, res) => {
  res.json({
    success: true,
    data: weatherData
  });
});

// 获取倒计时信息
app.get('/api/countdown', (req, res) => {
  res.json({
    success: true,
    data: countdownData
  });
});

// 启动服务器
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`API endpoints available at http://localhost:${PORT}/api`);
});