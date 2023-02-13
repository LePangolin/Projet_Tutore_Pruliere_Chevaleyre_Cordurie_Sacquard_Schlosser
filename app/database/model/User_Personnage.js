const supabase = require("../supabase");

async function createLink(idChar, idUser, fn){
    return await supabase.from('utilisateur_personnage').insert({
        id_personnage: idChar,
        id_utilisateur: idUser,
    })
}

module.exports = {
    createLink,
};