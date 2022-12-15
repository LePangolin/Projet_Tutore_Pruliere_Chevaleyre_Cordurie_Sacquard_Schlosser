const express = require('express');
const validator = require('./validator/validator.js');
const bodyParser = require('body-parser');
const User = require('./database/model/user.js');
const log = require('./log/logger.js');
const session = require('express-session');



// Création de l'application
const app = express();

// Création de la session
app.use(session({
    secret : 'cucurbitaceae',
    httpOnly : true,
    expires : new Date(Date.now() + 3600000),
}));


// Création des routes statiques
app.use("/js",express.static('public/js'));
app.use("/css",express.static('public/css'));


// Configuration de bodyParser
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Route de base
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/html/index.html');
});

// Route de connexion avec vérification des données
app.post("/signIn", validator.validateSignIn, (req, res) => {
    User.signIn(req.body.username, req.body.password, (err, result) => {
        if(err){
            log.createLog("app", "L'utilisateur " + req.body.username + " n'a pas été connecté : " + err, "error")
            res.status(500).send(err);
        }else{
            log.createLog("app", "L'utilisateur " + req.body.username + " a été connecté", "info")
            req.session.user = result;
            res.status(200).send("L'utilisateur a bien été connecté");
        }
    });
});

// Route d'inscription avec vérification des données
app.post("/signUp", validator.validateSignUp, (req, res) => {
    User.signUp(req.body.username, req.body.password, (err , result) => {
        if(err){
            log.createLog("app", "L'utilisateur " + req.body.username + " n'a pas été créé : " + err, "error")
            res.status(500).send(err);
        }else{
            log.createLog("app", "L'utilisateur " + req.body.username + " a été créé", "info")
            res.status(200).send("L'utilisateur a bien été créé");
        }
    });
});

// Lancement du serveur
app.listen(3010, () => console.log('Example app listening on port 3010!'));
