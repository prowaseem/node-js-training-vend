const { Router } = require("express");
const router = Router();
const fs = require("fs");
let books = [];

fs.readFile(__dirname + '/books.json', {
  encoding: 'utf-8',
}, (err, data) => {
  if(err) throw err;
  books = JSON.parse(data);
});


// adding auth header middleware
router.use((request, response, next) => {
  if(!request.headers['auth']) response.status(403).send('Unauthorized');
  next();
});

router.get('/', (request, response) => {
  response.send(books)
});
router.post('/', (request, response) => {
  const book = {
    id: books.length + 1,
    ...request.body,
  };
  books.push(book);
  response.send(books);
});
router.put('/:id', (request, response) => {
  const { params, body } = request;
  if (params && params.id) {
    let book = books.find(book => parseInt(book.id, 10) === parseInt(params.id, 10));
    if (book) {
      if (body.name) book.name = body.name;
      if (body.author) book.author = body.author;
      if (body.published_on) book.published_on = body.published_on;
      books = books.map(bk => {
        if (bk.id === book.id) {
          return book;
        }
        return bk;
      });
      response.send('Book record updated');
    }
  }
});
router.delete('/:id', (request, response) => {
  const { params } = request;
  if (params.id) {
    const book = books.find(book => parseInt(book.id, 10) === parseInt(params.id, 10));
    if (book) {
      books = books.filter(bk => bk.id !== book.id);
      response.send('Book record deleted');
    }
  }
});

module.exports = router;