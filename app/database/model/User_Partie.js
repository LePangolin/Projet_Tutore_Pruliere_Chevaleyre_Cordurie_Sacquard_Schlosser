const supabase = require("../supabase");

async function createLinkPartie(idPartie, idUser, fn){
    return await supabase.from('utilisateur_partie').insert({
        id_partie: idPartie,
        id_utilisateur: idUser,
    })
}

async function getPartie(idUser){
    let link = await supabase.from('utilisateur_partie').select('id_partie').eq('id_utilisateur', idUser)
    if(link.error){
        return {status: 500, statusText: 'Erreur serveur'}
    } else if(link.data.length == 0){
        return {status: 404, statusText: 'Partie non trouvée', data: []}
    }
    else{
        return {data : await supabase.from('partie').select('*').eq('id', link.data[0].id_partie)}
    }
}

async function getMeilleurPartie(idUser){
    let idParties = await supabase.from('utilisateur_partie').select('id_partie').eq('id_utilisateur', idUser)
    if(idParties.error){
        return {status: 500, statusText: 'Erreur serveur'}
    } else if(idParties.data.length == 0){
        return {status: 404, statusText: 'Partie non trouvée', data: []}
    }else{
        let partie = [];
        for(let i = 0; i < idParties.data.length; i++){
            partie.push(await supabase.from('partie').select('*').eq('id', idParties.data[i].id_partie))
        }
        let bestPartie = partie[0].data[0];
        for(let i = 1; i < partie.length; i++){
            if(!partie[i].data[0]){
                continue;
            }
            if(partie[i].data[0].score > bestPartie.score){
                bestPartie = partie[i].data[0];
            }
        }
        let user = await supabase.from('utilisateur').select('pseudo').eq('id', idUser)
        if(user.error){
            return {status: 500, statusText: 'Erreur serveur'}
        } else if(user.data.length == 0){
            return {status: 404, statusText: 'Utilisateur non trouvé', data: []}
        }
        let data =  await supabase.from('partie').select('*').eq('id', bestPartie.id)
        data.data[0].pseudo = user.data[0].pseudo;
        return {data : data}
    }

}

async function getMeilleurPartieAll(){
    let idUsers = await supabase.from('utilisateur_partie').select('id_utilisateur')
    if(idUsers.error){
        return {status: 500, statusText: 'Erreur serveur'}
    } else if(idUsers.data.length == 0){
        return {status: 404, statusText: 'Partie non trouvée', data: []}
    }
    let idUsersUnique = [];
    idUsers.data.forEach((id) => {
        if(!idUsersUnique.includes(id.id_utilisateur)){
            idUsersUnique.push(id.id_utilisateur)
        }
    })
    idUsers.data = idUsersUnique;
    let data = [];
    for(let i = 0; i < idUsers.data.length; i++){
        let partie = await getMeilleurPartie(idUsers.data[i]);
        if(partie.data.data.length > 0){
            data.push(partie.data.data[0]);
        }
    }
    return {
        status: 200,
        statusText: 'OK',
        data: data}
}

module.exports = {
    createLinkPartie,
    getPartie,
    getMeilleurPartie,
    getMeilleurPartieAll
};
