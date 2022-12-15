const database = require('../database.js');

function seed(){
    database.insert('users', {
        name: 'admin2',
        password  : 'admin2',
        created_at: new Date(),
        updated_at: new Date()
    });
}

module.exports = {
    seed
}