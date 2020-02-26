const http = require('http');
const fs = require('fs');

const app = http.createServer((request, response) => {
  const file = fs.readdirSync('.').find(file => file.indexOf('.txt') !== -1);
  fs.readFile(file, 'utf-8', (error, contents) => {
    if(error) {
      console.error(error);
      return;
    }
    response.end(contents);
  })
});

const listener = app.listen(3000, (Server) => {
  console.log(`Server started at port ${listener.address().port}`);
});