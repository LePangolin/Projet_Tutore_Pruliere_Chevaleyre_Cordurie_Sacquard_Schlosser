const database = require('../database.js');

function seed(){
    database.createTable('users', function (table) {
        table.increments('id');
        table.string('name');
        table.string('password');
        table.timestamps();
    }, function(){
        database.insert('users', {
            name: 'admin',
            password: 'admin',
            created_at: new Date(),
            updated_at: new Date()
        });
    });
}

module.exports = {
    seed
}