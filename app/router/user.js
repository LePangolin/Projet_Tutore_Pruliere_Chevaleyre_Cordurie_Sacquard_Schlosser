const express = require("express");
const router = express.Router();
const User = require("../database/model/User");
const jwt = require("jsonwebtoken");
const {validateMiddleware} = require("../middleware/validateMiddleware");

router.post("/login", async (req, res, next) => {
  if (!req.body.pseudo || !req.body.mdp) {
    next(400);
  } else {
    let result = await User.getUser(req.body.pseudo, req.body.mdp);
    if (result.error) {
      next(500);
    } else {
      if (result) {
        console.log(result);
        const token = jwt.sign({ id: result.id }, process.env.JWT_SECRET, { expiresIn: '1h' });
        res.setHeader("Content-Type", "application/json");
        res.statusCode = 200;
        res.send(
          JSON.stringify({
            message: "Utilisateur connecté",
            code: 200,
            data: {
              token: token,
              refresh_token: result.token,
              pseudo: result.pseudo,
              avatar_url: result.avatar_url,
              amelioration: result.amelioration,
              score: result.monnaie,
              personnage: result.personnage,
            },
          })
        );
      } else {
        next(401);
      }
    }
  }
});

router.post("/register", async (req, res, next) => {
  if (!req.body) {
    next(400);
  }
  if (!req.body.pseudo || !req.body.mdp) {
    next(400);
  } else {
    let result = await User.createUser(
      req.body.avatar,
      req.body.pseudo,
      req.body.mdp
    );
    console.log(result);
    if (result.error) {
      next(500);
    } else {
      let token = jwt.sign({ id: result.id }, process.env.JWT_SECRET, { expiresIn: '1h' });
      res.setHeader("Content-Type", "application/json");
      res.statusCode = result.status;
      res.send(
        JSON.stringify({
          message: result.statusText,
          code: result.status,
          data: {
            token: token,
            refresh_token: result.data.token,
            pseudo: result.data.pseudo,
            avatar_url: result.data.avatar_url,
            amelioration: result.data.amelioration,
            score: result.data.monnaie,
            personnage: result.data.personnage,
          },
        })
      );
    }
  }
});

router.put("/avatar", validateMiddleware, async (req, res, next) => {
  if (!req.body) {
    next(400);
  }
  if (!req.body.avatar) {
    next(400);
  } else {
    let result = await User.updateAvatar(
       req.user ? req.user.id : null,
       req.body.avatar);
    if (result.error) {
      next(500);
    } else {
      res.setHeader("Content-Type", "application/json");
      res.statusCode = result.status;
      res.send(
        JSON.stringify({
          message: result.statusText,
          code: result.status,
        })
      );
    }
  }
});

router.put("/amelioration", validateMiddleware, async (req, res, next) => {
  if (!req.body) {
    next(400);
  }
  if (!req.body.token || !req.body.amelioration) {
    next(400);
  } else {
    let result = await User.updateAmelioration(
      req.user ? req.user.id : null,
      req.body.amelioration
    );
    if (result.error) {
      next(500);
    } else {
      res.setHeader("Content-Type", "application/json");
      res.statusCode = result.status;
      res.send(
        JSON.stringify({
          message: result.statusText,
          code: result.status,
        })
      );
    }
  }
});

router.put("/score", validateMiddleware, async (req, res, next) => {
  if (!req.body) {
    next(400);
  }
  if (!req.body.token || !req.body.score) {
    next(400);
  } else {
    let result = await User.updateScore(
      req.user ? req.user.id : null,
      req.body.score
    );
    if (result.error) {
      next(500);
    } else {
      res.setHeader("Content-Type", "application/json");
      res.statusCode = result.status;
      res.send(
        JSON.stringify({
          message: result.statusText,
          code: result.status,
        })
      );
    }
  }
});


router.post("/party", validateMiddleware, async (req, res, next) => {
  if (!req.body) {
    next(400);
  }
  if (!req.body.score || !req.body.seed || !req.body.custom) {
    next(400);
  } else {
    let result = await User.savePartie(
      req.user ? req.user.id : null,
      req.body.score,
      req.body.seed,
      req.body.custom
    );
    if (result.error) {
      next(500);
    } else {
      res.setHeader("Content-Type", "application/json");
      res.statusCode = result.status;
      res.send(
        JSON.stringify({
          message: result.statusText,
          code: result.status,
        })
      );
    }
  }
});

router.get("/party/best/:token", async (req, res, next) => {
  if (!req.params.token) {
    next(400);
  } else {
    let result = await User.getBestPartie(req.params.token);
    if (result.error) {
      next(500);
    } else {
      res.setHeader("Content-Type", "application/json");
      res.statusCode = result.status;
      res.send(
        JSON.stringify({
          message: result.statusText,
          code: result.status,
          data: result.data,
        })
      );
    }
  }
});




router.all("*", (req, res, next) => {
  next(404);
});

module.exports = router;
