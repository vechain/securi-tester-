const jwt = require('jsonwebtoken');

app.post('/token', (req, res) => {
  const token = jwt.sign({ user: 'guest' }, '123456');  // Hardcoded weak secret
  res.send(token);
});
