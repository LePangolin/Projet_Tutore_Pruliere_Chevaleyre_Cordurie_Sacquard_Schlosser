const supabase = require("../supabase");
const { createPersonnage } = require("./Personnage");
const { createPartie } = require("./Partie");
const { createLinkPartie, getMeilleurPartie } = require("./User_Partie");
const crypto = require("crypto");

async function createUser(avatar, pseudo, mdp) {
  let tabChar = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
  ];
  let user = await getUser(pseudo, mdp);
  if (user.data.length > 0) {
    return { status: 409, statusText: "Pseudo déjà utilisé" };
  } else {
    if (!avatar) {
      avatar = "http://serverchronochroma.alwaysdata.net/img/avatar.png";
    }
    let longToken = 10;
    let token = "";
    for (let i = 0; i < longToken; i++) {
      token += tabChar[Math.floor(Math.random() * tabChar.length)];
    }
    let newuser = await supabase.from("utilisateur").insert({
      avatar_url: avatar,
      pseudo: pseudo,
      token: token,
      motdepasse: crypto
        .createHmac("sha256", "cucurbitacae")
        .update(mdp)
        .digest("hex"),
    });
    if (newuser.error) {
      return { status: 500, statusText: "Erreur serveur" };
    } else {
      let newchar = await createPersonnage();
      if (newchar.error) {
        return { status: 500, statusText: "Erreur serveur" };
      } else {
        let user = await getUser(pseudo, mdp);
        let char = (
          await supabase
            .from("personnage")
            .select("*")
            .order("id", { ascending: false })
            .limit(1)
        ).data[0];
        let link = await createLink(char.id, user.id);
        if (link.error) {
          return { status: 500, statusText: "Erreur serveur" };
        } else {
          user.personnage = char;
          return { status: 201, statusText: "Utilisateur créé", data: user };
        }
      }
    }
  }
}

async function getUser(pseudo, mdp, fn) {
  let user = await supabase
    .from("utilisateur")
    .select("id, avatar_url, pseudo, score, token")
    .eq("pseudo", pseudo)
    .eq(
      "motdepasse",
      crypto.createHmac("sha256", "cucurbitacae").update(mdp).digest("hex")
    );
  if (user.error) {
    return { status: 500, statusText: "Erreur serveur" };
  } else if (user.data.length == 0) {
    return { status: 404, statusText: "Utilisateur non trouvé", data: [] };
  } else {
    let char = await supabase
      .from("utilisateur_personnage")
      .select("id_personnage")
      .eq("id_utilisateur", user.data[0].id);
    if (char.error) {
      return { status: 500, statusText: "Erreur serveur" };
    } else if (char.data.length == 0) {
      return user.data[0];
    } else {
      let charData = await supabase
        .from("personnage")
        .select("*")
        .eq("id", char.data[0].id_personnage);
      if (charData.error) {
        return { status: 500, statusText: "Erreur serveur" };
      } else {
        user.data[0].personnage = charData.data[0];
        user.data[0].status = 200;
        return user.data[0];
      }
    }
  }
}

async function updateAvatar(token, avatar) {
  let user = await supabase
    .from("utilisateur")
    .update({ avatar_url: avatar })
    .eq("token", token);
  if (user.error) {
    return { status: 500, statusText: "Erreur serveur" };
  }
  return { status: 200, statusText: "Avatar mis à jour" };
}

async function updateAmelioration(token, amelioration) {
  let user = await supabase.from("utilisateur").select("id").eq("token", token);
  if (user.error) {
    return { status: 500, statusText: "Erreur serveur" };
  }
  let char = await getPerso(user.data[0].id);
  if (!char.data) {
    return { status: 500, statusText: "Erreur serveur" };
  }
  switch (amelioration) {
    case "vie":
      char.data.data[0].santeMax += 1;
      break;
    case "vitesse":
      char.data.data[0].vitesseMax += 1;
      break;
    case "force":
      char.data.data[0].forceMax += 1;
      break;
    case "vue":
      char.data.data[0].vueMax += 1;
      break;
    default:
      return { status: 400, statusText: "Amélioration inconnue" };
  }
  let update = await supabase
    .from("personnage")
    .update({
      santeMax: char.data.data[0].santeMax,
      vitesseMax: char.data.data[0].vitesseMax,
      forceMax: char.data.data[0].forceMax,
      vueMax: char.data.data[0].vueMax,
    })
    .eq("id", char.data.data[0].id);
  if (update.error) {
    return { status: 500, statusText: "Erreur serveur" };
  }
  return { status: 200, statusText: "Amélioration mise à jour" };
}


async function savePartie(token, score, seed, isCustom){
  let user = await supabase.from("utilisateur").select("id").eq("token", token);
  if(user.error){
    console.log("User throw error");
    return {status: 500, statusText: "Erreur serveur"};
  }
  let newPartie = await createPartie(score, seed, isCustom);
  console.log(newPartie);
  if(newPartie.error){
    console.log("Partie1 throw error");
    return {status: 500, statusText: "Erreur serveur"};
  }
  let partie = await supabase.from("partie").select("*").order("id", {ascending: false}).limit(1);
  console.log(partie);
  if(partie.error){
    console.log("Partie2 throw error");
    return {status: 500, statusText: "Erreur serveur"};
  }
  let link = await createLinkPartie(partie.data[0].id, user.data[0].id);
  console.log(link);
  if(link.error){
    console.log("Link throw error");
    return {status: 500, statusText: "Erreur serveur"};
  }
  return {status: 200, statusText: "Partie sauvegardée"};
}

async function getBestPartie(token){
  let user = await supabase.from("utilisateur").select("id").eq("token", token);
  if(user.error){
    return {status: 500, statusText: "Erreur serveur"};
  }
  let partie = await getMeilleurPartie(user.data[0].id);
  if(!partie.data){
    return {status: 500, statusText: "Erreur serveur"};
  }
  return {status: 200, statusText: "Partie récupérée", data: partie.data.data[0]};
}

module.exports = {
  createUser,
  getUser,
  updateAvatar,
  updateAmelioration,
  savePartie,
  getBestPartie
};
