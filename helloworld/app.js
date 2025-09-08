const express = require('express');
const app = express();
const port = 3000;

// Hello World 路由
app.get('/', (req, res) => {
  res.json({
    message: 'Hello World!',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// 健康检查路由
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    uptime: process.uptime()
  });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Hello World app listening at http://0.0.0.0:${port}`);
});