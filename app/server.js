const express = require('express');

// Création de l'application
const app = express();

// Body parser
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

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

// Page d'accueil
app.get('/', (req, res) => {
    res.sendFile('public/index.html', { root: '.'});
});

// Lancement du serveur
app.listen(process.env.PORT, () => console.log('API listening on port ' + process.env.PORT));