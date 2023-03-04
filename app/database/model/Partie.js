const supabase = require("../supabase");

async function createPartie(score, seed, isCustom) {
  return await supabase.from("partie").insert({
    score: score,
    seed: seed,
    custom: isCustom,
  });
}


module.exports = {
  createPartie,
};
