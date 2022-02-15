const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const BlogPost = Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    title: {
      type: String,
      required: true,
    },
    body: {
      type: String,
      required: true,
    },
    coverImage: {
      url: {
        type: String,
        default: "",
      },
      public_id: {
        type: String,
        default: "",
      },
    },
    likes: {
      type: Number,
      default: 0,
    },
    likedUsers: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
    dislikes: {
      type: Number,
      default: 0,
    },
    dislikedUsers: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
    comments: [{ type: mongoose.Schema.Types.ObjectId, ref: "Comment" }],
  },
  { timestamps: true }
);

module.exports = mongoose.model("BlogPost", BlogPost);
