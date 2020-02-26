const { Router } = require('express');
const axios = require('axios');

const router = Router();

axios.default.defaults.baseURL = 'https://swapi.co/';


router.get('/get-all', (request, response) => {
  axios({
    method: 'get',
    url: '/api/films/'
  })
    .then((res) => {
      response.send(res.data);
    })
    .catch((error) => console.error(error));
});

router.get('/get-by-title/:title', (request, response) => {
  axios({
    method: 'get',
    url: '/api/films/'
  })
    .then((res) => {
      const data = res.data.results;
      let films = [];
      if (data) {
        films = data.filter(film =>
          film.title.toLowerCase().includes(request.params.title.toLowerCase()));
      }
      if(films.length > 0) response.send(films);
      else response.send('No data');
    })
    .catch((error) => console.error(error));
});

module.exports = router;

