const express = require('express');
const session = require('express-session');

// Création de l'application
const app = express();

// Body parser
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Création de la session
app.use(session({
    secret : 'cucurbitaceae',
    httpOnly : true,
    expires : new Date(Date.now() + 3600000),
}));

// Routes
const userRouter = require('./router/user');
app.use('/user', userRouter);

const partieRouter = require('./router/partie');
app.use('/partie', partieRouter);


// Création des routes statiques
app.use("/js",express.static('public/js'));
app.use("/css",express.static('public/css'));
app.use("/img",express.static('public/img'));
app.use("/font",express.static('public/font'));


// Configuration de bodyParser
app.use(express.json());

// Route de base
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/html/index.html');
});

// Lancement du serveur
app.listen(3000, () => console.log('Example app listening on port 8100!'));