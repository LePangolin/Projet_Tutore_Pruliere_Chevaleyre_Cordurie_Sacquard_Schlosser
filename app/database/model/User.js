const supabase = require("../supabase");
const { createPersonnage } = require("./Personnage");
const { createLink } = require("./User_Personnage");
const crypto = require("crypto");

async function createUser(avatar, pseudo, mdp) {
  let tabChar = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
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
  let user = await supabase.from("utilisateur").update({ avatar_url: avatar }).eq("token", token);
  if (user.error) {
    return { status: 500, statusText: "Erreur serveur" };
  }
  return { status: 200, statusText: "Avatar mis à jour" };
}

module.exports = {
  createUser,
  getUser,
  updateAvatar,
};
