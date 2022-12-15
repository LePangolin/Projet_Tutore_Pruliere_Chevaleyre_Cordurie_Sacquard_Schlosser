const database = require('../database.js');
const crypto = require('crypto');

/**
 * Fonction qui permet de créer un utilisateur
 * @param {String} username
 * @param {String} password
 * @param {Function} callback
 * @returns {void}
 * @example signUp("admin", "admin", function(err, result){})
 */
function signUp(username, password, callback){
    database.select("users", ['name'], {name: username}, function(result){
        if(result.length > 0){
            return callback("Username already exists", false);
        }else {
            database.insert("users", {
                name: username, 
                password: crypto.createHash('md5').update(password).digest("hex"),
                created_at: new Date(),
                updated_at: new Date()
            }, callback(false, true));
        }
    });
}

/**
 * Fonction qui permet de se connecter
 * @param {String} username
 * @param {String} password
 * @param {Function} callback
 * @returns {void}
 * @example signIn("admin", "admin", function(err, result){})
 */
function signIn(username, password, callback){
    database.select("users", ['name'], {
        name: username, 
        password: crypto.createHash('md5').update(password).digest("hex"),
    }, (result) => {
        if(result.length > 0){
            return callback(false, username);
        }else {
            return callback("Username or password is wrong", false);
        }
    });
}

module.exports = {
    signUp,
    signIn
}