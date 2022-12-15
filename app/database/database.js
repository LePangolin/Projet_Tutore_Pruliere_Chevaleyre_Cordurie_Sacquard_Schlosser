const conf = require('../config/databaseConf.json');
const fs = require('fs');
const log = require('../log/logger.js');

/**
 * Fonction qui permet de créer une instance de knex
 * @returns {Knex}
 */
function createKnex(){
    return knex = require('knex')({
        client: 'mysql',
        connection: conf
    });
}


/**
 * Fonction qui permet de créer une table
 * @param {Strinf} tableName 
 * @param {JSON} tableSchema 
 * @param {Function} fn 
 * @returns {void}
 * @example createTable('users', function (table) {}, function(){})
 */
function createTable(tableName, tableSchema, fn = function(){}) {
    let knex = createKnex();
    knex.schema.createTable(tableName, tableSchema).then(function () {
        log.createLog("database", "Table " + tableName + " created", "info");
        knex.destroy();
        fn();
    }).catch(function (err) {
        log.createLog("database", err, "error");
    });
}

/**
 * Fonction qui permet de supprimer une table
 * @param {String} tableName 
 * @param {Function} fn 
 * @returns {void}
 * @example dropTable('users', function(){})
 */
function dropTable(tableName, fn = function(){}) {
    let knex = createKnex();
    knex.schema.dropTable(tableName).then(function () {
        log.createLog("database", "Table " + tableName + " dropped", "info");
        knex.destroy();
        fn();
    }).catch(function (err) {
        log.createLog("database", err, "error");
    });
}

/**
 * Fonction qui permet d'insérer des données dans une table
 * @param {String} tableName
 * @param {JSON} data
 * @param {Function} fn
 * @returns {void}
 * @example insert('users', {name: 'admin2', password: 'admin2', created_at: new Date(), updated_at: new Date()}, function(){})
*/
function insert(tableName, data, fn = function(){}) {
    let knex = createKnex();
    knex(tableName).insert(data).then(function () {
        log.createLog("database", "Data inserted in " + tableName, "info");
        knex.destroy();
        fn()
    }).catch(function (err) {
        log.createLog("database", err, "error");
    });
}

/**
 * Fonction qui permet de selectionner des données dans une table
 * @param {String} tableName
 * @param {JSON} where
 * @param {Function} fn
 * @returns {void}
 * @example select('users', ['id', 'name'], {id: 1}, function(result){})
 */
function select(tableName, data, where = {}, fn) {
    let knex = createKnex();
    knex(tableName).where(where).select(data).then(function (result) {
        fn(result);
        knex.destroy();
    }).catch(function (err) {
        log.createLog("database", err, "error");
    });
}

/**
 * Fonction qui permet de mettre a jour des données dans une table
 * @param {String} tableName
 * @param {JSON} data
 * @param {JSON} where
 * @param {Function} fn
 * @returns {void}
 * @example update('users', {name: 'admin2'}, {id: 1}, function(){})
 */
function update(tableName, data, where = {}, fn = function(){}) {
    let knex = createKnex();
    knex(tableName).where(where).update(data).then(function (result) {
        log.createLog("database", "Data updated in " + tableName, "info");
        knex.destroy();
        fn();
    }).catch(function (err) {
        log.createLog("database", err, "error");
    });
}

/**
 * Fonction qui permet de récupérer toutes les données d'une table
 * @param {String} tableName
 * @param {JSON} data
 * @param {Function} fn
 * @returns {void}
 * @example all('users', ['id', 'name'], function(result){})
 */
function all(tableName, data, fn) {
    let knex = createKnex();
    knex(tableName).select(data).then(function (result) {
        knex.destroy();
        fn(result);
    }).catch(function (err) {
        log.createLog("database", err, "error");
    });
}

/**
 * Fonction qui permet de récupérer la dernière donnée d'une table
 * @param {String} tableName
 * @param {JSON} data
 * @param {Function} fn
 * @returns {void}
 * @example last('users', ['id', 'name'], function(result){})
 */
function last(tableName, data, fn) {
    let knex = createKnex();
    knex(tableName).select(data).orderBy('id', 'desc').limit(1).then(function (result) {
        knex.destroy();
        fn(result);
    }).catch(function (err) {
        log.createLog("database", err, "error");
    });
}

/**
 * Fonction qui permet de remplir la base de données
 * @returns {void}
 * @example seed()
 */
function seeding(){
    let knex = createKnex();
    knex.schema.hasTable('seeders').then(function(exists) {
        if(exists){
            last('seeders', ['version'], function(result){
                let seeders = fs.readdirSync('./database/seeders');
                let lastSeeder = result[0].version;
                let index = seeders.indexOf(lastSeeder);
                if(index < seeders.length - 1){
                    for(let i = index + 1; i < seeders.length; i++){
                        let version = require('./seeders/' + seeders[i]);
                        version.seed();
                        insert('seeders', {
                            version: seeders[i],
                            created_at: new Date(),
                            updated_at: new Date()
                        });
                    }
                }else{
                    log.createLog("database", "Database is up to date", "info");
                }
            });
        }else{
            createTable('seeders', function (table) {
                table.increments('id');
                table.string('version');
                table.timestamps();
            }, function(){
                let seeders = fs.readdirSync('./database/seeders');
                seeders.forEach(function(seeder){
                    let version = require('./seeders/' + seeder);
                    version.seed();
                    insert('seeders', {
                        version: seeder,
                        created_at: new Date(),
                        updated_at: new Date()
                    });
                });
            })
        }
        knex.destroy();
    });
}

seeding();

module.exports = {
    createTable,
    dropTable,
    insert,
    select,
    update,
    all,
    last,
    seeding
}
