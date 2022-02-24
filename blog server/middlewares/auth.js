const jwt = require("jsonwebtoken");

let checkToken = (req, res, next) => {
  if (req.headers["authorization"]) {
    const token = req.headers.authorization.split(" ")[1];
    jwt.verify(token, process.env.SECRET, (err, decoded) => {
      if (err) {
        // next(Error("Failed to authenticate token"));
        return res.status(401).json({
            status: false,
            msg: "Failed to authenticate token",
          });
      } else {
        req.user = decoded;
        next();
      }
    });
  } else {
    // next(Error("No token provided"));
    return res.status(401).json({
        status: false,
        msg: "No token provided",
      });
  }
};

module.exports = {
  checkToken: checkToken,
};
