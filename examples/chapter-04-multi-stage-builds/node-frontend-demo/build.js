const fs = require('node:fs');
fs.mkdirSync('dist', { recursive: true });
fs.copyFileSync('src/index.html', 'dist/index.html');
console.log('Created dist/index.html');
