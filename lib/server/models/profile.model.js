const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const Profile = Schema(
  {
    username: {
      type: String,
      required: true,
      unique: true,
    },
    name: String,
    profession: String,
    DOB: String,
    titleline: String,
    about: String,
    img: {
      url: {
        type: String,
        default: "",
      },
      public_id: {
        type: String,
        default: "",
      },
    },
  },
  {
    timestamp: true,
  }
);

module.exports = mongoose.model("Profile", Profile);
