const express = require('express');
const path = require('path');
const app = express();

// 정적 파일 제공 (HTML 파일 위치)
app.use(express.static(path.join(__dirname, '/')));

app.listen(3000, () => {
    console.log('Server is running on http://localhost:3000');
});

