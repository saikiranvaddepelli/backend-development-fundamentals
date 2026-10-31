const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.status(200).send('Welcome to the Node.js and Express server!');
});

app.get('/about', (req, res) => {
  res.status(200).json({
    name: 'Oddepelly Sai Kiran',
    registrationNumber: '252U1R5116',
    section: 'Backend Development Fundamentals - Section A'
  });
});

app.get('/time', (req, res) => {
  res.status(200).json({
    currentTime: new Date().toISOString()
  });
});

app.use((req, res) => {
  res.status(404).send('404 Not Found: The requested resource does not exist.');
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
