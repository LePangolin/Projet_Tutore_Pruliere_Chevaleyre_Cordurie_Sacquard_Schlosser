const express = require("express");
const router = express.Router();
const User = require("../database/model/User");

router.post("/login", async (req, res, next) => {
  if (!req.body.pseudo || !req.body.mdp) {
    next(400);
  } else {
    let result = await User.getUser(req.body.pseudo, req.body.mdp);
    if (result.error) {
      next(500);
    } else {
      if (result) {
        req.session.user = result;
        res.setHeader("Content-Type", "application/json");
        res.statusCode = 200;
        res.send(
          JSON.stringify({
            message: "Utilisateur connecté",
            code: 200,
            data: result,
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
