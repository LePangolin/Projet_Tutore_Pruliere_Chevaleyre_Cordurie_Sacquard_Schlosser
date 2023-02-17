const supabase = require("../supabase");

async function createPersonnage(fn) {
    return await supabase.from("personnage").insert({
        santeMax: 1,
        vitesseMax: 1,
        forceMax: 1,
        vueMax: 1,
    });
}


module.exports = {
    createPersonnage,
};
