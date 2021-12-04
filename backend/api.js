const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

// defining the Express app
const app = express();

// defining an array to work as the database (temporary solution)
const ads = [
  { title: 'Hello, world (again)!' }
];

// adding Helmet to enhance your API's security
app.use(helmet());

// using bodyParser to parse JSON bodies into JS objects
app.use(bodyParser.json());

// enabling CORS for all requests
app.use(cors());

// adding morgan to log HTTP requests
app.use(morgan('combined'));

// defining an endpoint to return all ads
app.post('/add-email', ({ body: { email, address } }, res) => {
});

app.post('/notify', ({ body: { } }, res) => {
  //send notifcation to email
});

// starting the server
app.listen(3001, () => {
  console.log('listening on port 3001');
});