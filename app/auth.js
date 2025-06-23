const jwt = require('jsonwebtoken');

app.post('/token', (req, res) => {
  const token = jwt.sign({ user: 'guest' }, 'J8j?Z.|0,6o)');  // Hardcoded weak secret
  res.send(token);
});
