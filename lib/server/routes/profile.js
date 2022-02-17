const express = require("express");
const router = express.Router();

const cloud = require("../cloudinaryconfig");
const file = require("../fileupload");

const Profile = require("../models/profile.model");
const middleware = require("../middlewares/auth");

router.get("/checkProfile", middleware.checkToken, async (req, res, next) => {
  try {
    const profile = await Profile.findOne({ username: req.user.username });
    if (profile !== null) {
      return res.json({
        Status: true,
        username: req.user.username,
        img: profile.img.url,
      });
    } else
      return res.json({
        Status: false,
        username: req.user.username,
      });
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

router.get("/getData", middleware.checkToken, async (req, res, next) => {
  try {
    const profile = await Profile.findOne({ username: req.user.username });

    if (!profile) {
      throw new Error("No such profile found");
    }
    res.status(200).json({ data: profile });
  } catch (err) {
    if ((err.message = "No such profile found")) {
      res.status(401).json({ data: [] });
    } else {
      res.status(500).json({ msg: err.message });
      next(err);
    }
  }
});

router.post("/add", middleware.checkToken, async (req, res, next) => {
  try {
    const profile_exist = await Profile.findOne({
      username: req.user.username,
    });
    if (profile_exist !== null) {
      throw new Error("User already has created the profile");
    }
    const profile = await Profile.create({
      username: req.user.username,
      name: req.body.name,
      profession: req.body.profession,
      DOB: req.body.DOB,
      titleline: req.body.titleline,
      about: req.body.about,
    });
    // const { id, username, email } = user;
    res
      .status(201)
      .json({ msg: "Sucessfully created profile", data: profile.toJSON() });
  } catch (err) {
    res.status(400).json({ msg: err.message });
    next(err);
  }
});

router.patch(
  "/add/image",
  middleware.checkToken,
  file.multerUpload.single("img"), // image is used as key in form body
  async (req, res, next) => {
    try {
      if (req.file) {
        const profile_exist = await Profile.findOne({
          username: req.user.username,
        });
        if (profile_exist === null) {
          throw new Error("Profile does not exist");
        }
        const old_public_id = profile_exist.img.public_id;
        const image = file.dataUri(req).content;
        const result = await cloud.uploader.upload(image, {
          folder: "blog_app/profiles",
          // use_filename: true,
          unique_filename: true,
        });
        if (old_public_id != "") {
          console.log("deleting image");
          const del = await cloud.uploader.destroy(old_public_id);
        }
        const profile = await Profile.findOneAndUpdate(
          { username: req.user.username },
          {
            $set: { "img.url": result.url, "img.public_id": result.public_id },
          },
          { new: true }
        );
        // const msg = {
        //   msg: "image updated successfully",
        //   data: profile.toJSON(),
        // };
        res.status(200).json({ data: profile });
      } else {
        throw new Error("File not added");
      }
    } catch (err) {
      res.status(500).json({ msg: err.message });
      next(err);
    }
  }
);

router.patch("/update", middleware.checkToken, async (req, res, next) => {
  try {
    const profile_exist = await Profile.findOne({
      username: req.user.username,
    });
    if (profile_exist === null) {
      throw new Error("No such profile found");
    }

    const profile = await Profile.findOneAndUpdate(
      { username: req.user.username },
      {
        $set: {
          name: req.body.name ? req.body.name : profile_exist.name,
          profession: req.body.profession
            ? req.body.profession
            : profile_exist.profession,
          DOB: req.body.DOB ? req.body.DOB : profile_exist.DOB,
          titleline: req.body.titleline
            ? req.body.titleline
            : profile_exist.titleline,
          about: req.body.about ? req.body.about : profile_exist.about, //about:""
        },
      },
      { new: true }
    );
    res.status(200).json({ data: profile });
  } catch (err) {
    if ((err.message = "No such profile found")) {
      res.status(401).json({ data: [] });
    } else {
      res.status(500).json({ msg: err.message });
      next(err);
    }
  }
});

// router.post(
//   "/imagetest",
//   file.multerUpload.single("img"), // image is used as key in form body
//   async (req, res, next) => {
//     try {
//       if (req.file) {
//         const image = file.dataUri(req).content;
//         const result = await cloud.uploader.upload(image, {
//           folder: "blog_app/profiles",
//           // use_filename: true,
//           unique_filename: true,
//         });
//         const msg = {
//           msg: "image updated successfully",
//           "img.url": result.url,
//           "img.public_id": result.public_id,
//         };
//         res.status(200).json({ msg });
//       } else {
//         throw new Error("File not added");
//       }
//     } catch (err) {
//       res.status(500).json({ msg: err.message });
//       next(err);
//     }
//   }
// );

// router.delete("/imagetest", async (req, res, next) => {
//   try {
//     const result = await cloud.uploader.destroy(req.body.img.public_id);
//     res.status(200).json(result);
//   } catch (err) {
//     res.status(500).json({ msg: err.message });
//     next(err);
//   }
// });

module.exports = router;
