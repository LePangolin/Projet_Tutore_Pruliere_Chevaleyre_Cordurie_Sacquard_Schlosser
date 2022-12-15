const database = require('../database.js');

function seed(){
    database.createTable('users', function (table) {
        table.increments('id');
        table.string('name');
        table.string('password');
        table.timestamps();
    });
}

module.exports = {
    seed
}