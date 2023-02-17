const express = require("express");
const router = express.Router();

const User_Partie = require("../database/model/User_Partie");

router.get("/best", async (req, res, next) => {
  let result = await User_Partie.getMeilleurPartieAll();
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
});

module.exports = router;