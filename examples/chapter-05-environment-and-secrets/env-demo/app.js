const http = require('http');

const port = process.env.PORT || 3000;
const appName = process.env.APP_NAME || 'MyApp';

const server = http.createServer((req, res) => {
  res.writeHead(200);
  res.end(`Hello from ${appName} on port ${port}`);
});

server.listen(port, () => {
  console.log(`${appName} listening on port ${port}`);
});
