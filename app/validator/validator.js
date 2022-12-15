const joi = require('joi');

// Schéma de validation pour l'inscription
const schemaSignUp = joi.object({
    username: joi.string().alphanum().min(3).max(15).required(),
    password: joi.string().pattern(new RegExp('^[a-zA-Z0-9]{3,30}$')).required(),
    passwordConfirm: joi.ref('password')
});

// Schéma de validation pour la connexion
const schemaSignIn = joi.object({
    username: joi.string().alphanum().min(3).max(15).required(),
    password: joi.string().pattern(new RegExp('^[a-zA-Z0-9]{3,30}$')).required()
});

/**
 * Middleware de validation pour la connexion
 * @param {*} req 
 * @param {*} res 
 * @param {*} next 
 * @returns 
 */
function validateSignIn(req, res, next) {
    const result = schemaSignIn.validate({username: req.body.username, password: req.body.password});
    if (result.error) {
        res.status(400).send(result.error.details[0].message);
        return;
    }
    next();
}

/**
 * Middleware de validation pour l'inscription
 * @param {*} req
 * @param {*} res
 * @param {*} next
 * @returns
 */
function validateSignUp(req, res, next) {
    const result = schemaSignUp.validate({username: req.body.username, password: req.body.password, passwordConfirm: req.body.passwordConfirm});
    if (result.error) {
        res.status(400).send(result.error.details[0].message);
        return;
    }
    next(); 
}


module.exports = {
    validateSignIn,
    validateSignUp
}