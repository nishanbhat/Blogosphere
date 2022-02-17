const express = require("express");
const User = require("../models/user.model");
const jwt = require("jsonwebtoken");
const middleware = require("../middlewares/auth");
const router = express.Router();
const sendEmail = require("../email");

// router.post("/register", (req, res) => {
//   const { username, password, email } = req.body;
//   User.findOne({ username: username, email: email }).then((user) => {
//     if (user) {
//       return res.status(400).json({ msg: "User already exists" });
//     }
//     const newuser = new User({
//       username: username,
//       password: password,
//       email: email,
//     });
//     newuser
//       .save()
//       .then((_) => {
//         const { password, ...profile } = _.toJSON();
//         res.status(200).json({ msg: profile });
//       })
//       .catch((err) => {
//         res.status(403).json({ msg: err });
//       });
//   });
// });

router.get("/:username", middleware.checkToken, async (req, res, next) => {
  try {
    const user = await User.findOne({
      username: req.params.username,
    });

    if (!user) {
      throw new Error("No such user found");
    }

    const { password, ...profile } = user.toJSON();

    res.status(200).json({
      data: profile,
      username: req.params.username,
    });
  } catch (err) {
    res.status(500).json({
      msg: err.message,
    });
    next(err);
  }
});

router.get("/checkusername/:username", async (req, res, next) => {
  try {
    const user = await User.findOne({
      username: req.params.username,
    });
    if (user !== null) {
      return res.json({
        Status: true,
      });
    } else
      return res.json({
        Status: false,
      });
  } catch (err) {
    res.status(500).json({
      msg: err.message,
    });
    next(err);
  }
});

router.get("/checkemail/:email", async (req, res, next) => {
  try {
    const user = await User.findOne({
      email: req.params.email,
    });
    if (user !== null) {
      return res.json({
        Status: true,
        username: user.username,
      });
    } else
      return res.json({
        Status: false,
        username: null,
      });
  } catch (err) {
    res.status(500).json({
      msg: err.message,
    });
    next(err);
  }
});

router.post("/login", async (req, res, next) => {
  try {
    const user = await User.findOne({
      username: req.body.username,
    });

    if (user === null) {
      throw new Error("user does not exist");
    }

    const { id, username } = user;
    const valid = await user.comparePassword(req.body.password); //comparing if passwords match. returns true if they match

    if (valid) {
      const token = jwt.sign(
        {
          id,
          username,
        },
        process.env.SECRET
      );
      res.status(200).json({
        token: token,
        id: id,
        msg: "success",
      });
    } else {
      throw new Error("Invalid password");
    }
  } catch (err) {
    let num = 500;
    if (err.message != "user does not exist") {
      num = 403;
    }
    res.status(500).json({
      msg: err.message,
    });
    next(err);
  }
});

router.post("/register", async (req, res, next) => {
  try {
    const userexist = await User.findOne({
      email: req.body.email,
    });
    if (userexist !== null) {
      throw new Error("Email already taken");
    }
    const user = await User.create(req.body);
    const { id, username, email } = user;
    res.status(201).json({
      id,
      username,
      email,
    });
  } catch (err) {
    if (err.message != "Email already taken") {
      err.message = "Username already taken";
    }
    res.status(403).json({
      msg: err.message,
    });
    next(err);
  }
});

router.patch(
  "/update/:username",
  middleware.checkToken,
  async (req, res, next) => {
    try {
      const userexist = await User.findOne({
        username: req.params.username,
      });
      if (userexist === null) {
        throw new Error("user does not exist");
      }
      if (userexist._id.toString() !== req.user.id) {
        throw new Error("Not authorised to update username");
      }
      // const user = await User.findOneAndUpdate(
      //   { username: req.params.username },
      //   { $set: { password: req.body.password } },
      //   { new: true }
      // );
      const user = await User.findOne({
        username: req.params.username,
      });
      console.log(user);
      user.password = req.body.password;
      await user.save();
      const msg = {
        msg: "password successfully updated",
        id: user._id,
        username: user.username,
        email: user.email,
        // password: user.password,
      };
      res.status(200).json({
        msg,
      });
    } catch (err) {
      res.status(403).json({
        msg: err.message,
      });
      next(err);
    }
  }
);

router.delete(
  "/delete/:username",
  middleware.checkToken,
  async (req, res, next) => {
    try {
      const userexist = await User.findOne({
        username: req.params.username,
      });
      if (userexist === null) {
        throw new Error("user does not exist");
      }
      if (userexist._id.toString() !== req.user.id) {
        throw new Error("Not authorised to delete user");
      }
      const user = await User.findOneAndDelete({
        username: req.params.username,
      });
      const msg = {
        msg: "user successfully deleted",
        id: user._id,
        username: user.username,
        email: user.email,
      };
      res.status(200).json({
        msg,
      });
    } catch (err) {
      res.status(403).json({
        msg: err.message,
      });
      next(err);
    }
  }
);

router.post("/getVerificationMail", async (req, res, next) => {
  try {
    const { username, password, email } = req.body;
    const userexist = await User.findOne({
      email: email,
    });
    if (userexist !== null) {
      throw new Error("Email already taken");
    }
    const token = jwt.sign(
      {
        username,
        password,
        email,
      },
      process.env.SECRET,
      {
        expiresIn: "10m",
      }
    );
    const mailObj = {
      from: "abhisheksudhir2000@gmail.com",
      recipients: [email],
      subject: "Account verification",
      html: `
      <h2>Please click on link to activate account(active for only 10 minutes)</h2>
      <h3>
        <a href="${process.env.SERVER_URL}/user/activateAccount/${token}">
        Activate Account
        </a>
      </h3>
      <h3>If it doesn't work, please copy paste the below link in your browser</h3>
      <a href="${process.env.SERVER_URL}/user/activateAccount/${token}">
      ${process.env.SERVER_URL}/user/activateAccount/${token}
      </a>
      `,
    };
    // sendEmail(mailObj).then((res) => {
    //   console.log(res);
    // });
    const message = await sendEmail(mailObj);

    res.status(201).json({
      msg: message,
    });
  } catch (err) {
    res.status(403).json({
      msg: err.message,
    });
    next(err);
  }
});

router.get("/activateAccount/:token", async (req, res, next) => {
  try {
    const token = req.params.token;
    if (token) {
      const decoded = await jwt.verify(token, process.env.SECRET);
      const { iat, exp, ...body } = decoded;
      const userexist = await User.findOne({
        email: decoded.email,
      });
      if (userexist !== null) {
        throw new Error("Verification already done");
      }
      const user = await User.create(body);
      const { id, username, email } = user;
      res.status(201).json({
        id,
        username,
        email,
      });
    } else {
      throw Error("Something went wrong");
    }
  } catch (err) {
    res.status(403).json({
      msg: err.message,
    });
    next(err);
  }
});

router.post("/getOtpVerificationMail", async (req, res, next) => {
  try {
    const { username, password, email } = req.body;
    const userexist = await User.findOne({
      email: email,
    });
    if (userexist !== null) {
      throw new Error("Email already taken");
    }
    const num = Math.floor(100000 + Math.random() * 900000);
    const token = jwt.sign(
      {
        username,
        password,
        email,
        num,
      },
      process.env.SECRET,
      {
        expiresIn: "10m",
      }
    );
    const mailObj = {
      from: "abhisheksudhir2000@gmail.com",
      recipients: [email],
      subject: "Account verification",
      html: `
      <h2>OTP for verifying account</h2>
      <p>Below is the otp for verifying your account password. It is valid for only 10 minutes</p>
      <h2>${num}</h2>
      `,
    };
    const message = await sendEmail(mailObj);
    res.status(201).json({
      msg: message,
      token: token,
    });
    // res.status(201).json({ msg: message });
  } catch (err) {
    res.status(403).json({
      msg: err.message,
    });
    next(err);
  }
});

router.post("/activateAccountByOtp/:token", async (req, res, next) => {
  try {
    const token = req.params.token;
    if (token) {
      const otp = req.body.otp;
      const decoded = await jwt.verify(token, process.env.SECRET);
      const { iat, exp, num, ...body } = decoded;
      // console.log(typeof(otp));
      // console.log(typeof(num));
      if (otp.toString() !== num.toString()) {
        throw new Error("Incorrect otp");
      }
      const userexist = await User.findOne({
        email: decoded.email,
      });
      if (userexist !== null) {
        throw new Error("Verification already done");
      }
      const user = await User.create(body);
      const { id, username, email } = user;
      res.status(201).json({
        id,
        username,
        email,
      });
    } else {
      throw Error("Something went wrong");
    }
  } catch (err) {
    res.status(403).json({
      msg: err.message,
    });
    next(err);
  }
});

router.post("/forgotPassword", async (req, res, next) => {
  try {
    const email = req.body.email;
    const userexist = await User.findOne({
      email: email,
    });
    if (userexist === null) {
      throw new Error("Email doesn't exist");
    }
    const num = Math.floor(100000 + Math.random() * 900000);
    const token = jwt.sign(
      {
        num,
      },
      process.env.SECRET,
      {
        expiresIn: "5m",
      }
    );
    const user = await User.findOneAndUpdate(
      {
        email: email,
      },
      {
        $set: {
          otp: token,
        },
      },
      {
        new: true,
      }
    );
    const { password, otp, blogs, ...userdetails } = user.toJSON();
    const mailObj = {
      from: "testhalkhabar@gmail.com",
      recipients: [email],
      subject: `Request for password change for username: ${userdetails.username}`,
      html: `
      <h2>OTP for changing password</h2>
      <br />
      <p>Below is the otp for changing your account password. It is valid for only 5 minutes</p>
      <h1>${num}</h1>
      `,
    };
    // sendEmail(mailObj).then((res) => {
    //   console.log(res);
    // });
    const message = await sendEmail(mailObj);

    res.status(201).json({
      msg: message,
      user: userdetails,
    });
  } catch (err) {
    res.status(403).json({
      msg: err.message,
    });
    next(err);
  }
});

router.post("/getOtp/:id", async (req, res, next) => {
  try {
    const otp = req.body.otp;
    const userexist = await User.findById({
      _id: req.params.id,
    });
    if (userexist === null) {
      throw new Error("Email doesn't exist");
    }
    const decoded = await jwt.verify(userexist.otp, process.env.SECRET);

    console.log(typeof decoded.num);

    if (otp !== decoded.num) {
      throw new Error("Incorrect otp");
    }

    const message = "Correct otp";

    res.status(201).json({
      msg: message,
      token: userexist.otp,
    });
  } catch (err) {
    res.status(403).json({
      msg: err.message,
    });
    next(err);
  }
});

router.patch("/update/:id/:token", async (req, res, next) => {
  try {
    const user = await User.findById({
      _id: req.params.id,
    });
    if (user === null) {
      throw new Error("User does not exist");
    }
    await jwt.verify(user.otp, process.env.SECRET);
    if (user.otp != req.params.token) {
      throw new Error("Userotp and token don't match");
    }
    user.password = req.body.password;
    user.otp = null;
    await user.save();
    const msg = {
      msg: "password successfully updated",
      id: user._id,
      username: user.username,
      email: user.email,
      otp: user.otp,
      // password: user.password,
    };
    res.status(200).json({
      msg,
    });
  } catch (err) {
    res.status(403).json({
      msg: err.message,
    });
    next(err);
  }
});

module.exports = router;
