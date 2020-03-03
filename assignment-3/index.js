const express = require("express");
const bodyParser = require("body-parser");
const books = require("./books");

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/books', books);

const listener = app.listen(3000, () => console.log(`Server started at ${listener.address().port}`));

module.exports = listener;
