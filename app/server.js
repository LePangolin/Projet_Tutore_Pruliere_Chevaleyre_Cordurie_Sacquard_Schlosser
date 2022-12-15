const express = require('express');
const database = require('./database/database.js');

// Création de l'application
const app = express();

// Création des routes statiques
app.use("/js",express.static('public/js'));
app.use("/css",express.static('public/css'));

// Route de base
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/html/index.html');
});

// Lancement du serveur
app.listen(3010, () => console.log('Example app listening on port 3010!'));
