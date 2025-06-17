const express = require('express');
const _ = require('lodash');
const app = express();

app.get('/greet', (req, res) => {
  const name = req.query.name;
  res.send(`<h1>Hello ${name}</h1>`);  // Reflected XSS
});

app.use((req, res, next) => {
  res.cookie('sessionID', 'abc123');  // Missing HttpOnly, Secure
  next();
});

app.listen(3000);
