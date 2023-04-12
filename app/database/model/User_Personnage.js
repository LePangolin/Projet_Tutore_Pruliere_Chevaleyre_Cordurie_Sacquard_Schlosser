const supabase = require("../supabase");

async function createLink(idChar, idUser, fn){
    return await supabase.from('utilisateur_personnage').insert({
        id_personnage: idChar,
        id_utilisateur: idUser,
    })
}

async function getPerso(idUser){
    let link = await supabase.from('utilisateur_personnage').select('id_personnage').eq('id_utilisateur', idUser)
    if(link.error){
        return {status: 500, statusText: 'Erreur serveur'}
    } else if(link.data.length == 0){
        return {status: 404, statusText: 'Personnage non trouvé', data: []}
    }
    else{
        return {data : await supabase.from('personnage').select('*').eq('id', link.data[0].id_personnage)}
    }
}



module.exports = {
    createLink,
    getPerso
};