const jwt = require("jsonwebtoken");

function validateMiddleware(req, res, next) {
    if(!req.headers.authorization) {
        return next(401);
    }
    const token = req.headers.authorization.split(' ')[1];
    if(!token) {
        return next(401);
    }
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if(err) {
            return next(401);
        }
        req.user = decoded;
        next();
    });
}

module.exports = {
    validateMiddleware,
}