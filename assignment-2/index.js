const express = require('express');
const swapi = require('./swapi');

const app = express();

app.use('/swapi', swapi);

const listener = app.listen(3000, () => console.log(`Server started at ${listener.address().port}`));