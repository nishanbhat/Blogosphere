const express = require("express");
const middleware = require("../middlewares/auth");
const router = express.Router();

const cloud = require("../cloudinaryconfig");
const file = require("../fileupload");

const BlogPost = require("../models/blogPost.model");
const User = require("../models/user.model");
const Comments = require("../models/comment.model");

// blogs
router.get("/getUserBlogs", middleware.checkToken, async (req, res, next) => {
  try {
    // const user = await User.findById(req.user.id, {
    //   fields: { blogs: 1 },
    // }).populate("blogs");
    const blogs = await BlogPost.find({
      user: req.user.id,
    });
    res.status(200).json({ data: blogs });
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

router.get("/getOtherBlogs", middleware.checkToken, async (req, res, next) => {
  try {
    const blogs = await BlogPost.find({
      user: req.user.id,
    });

    res.status(200).json({ data: blogs });
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

router.get("/getAllBlogs", async (req, res, next) => {
  try {
    const blogs = await BlogPost.find({});
    res.status(200).json({ data: blogs });
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

router.get("/:id", middleware.checkToken, async (req, res, next) => {
  try {
    const blog = await BlogPost.findById({ _id: req.params.id });
    res.status(200).json({ data: blog });
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

router.post("/createBlog", middleware.checkToken, async (req, res, next) => {
  try {
    const userexist = await User.findById(req.user.id);
    if (userexist === null) {
      throw new Error("User doesn't exist");
    }
    const blogPost = await BlogPost.create({
      user: req.user.id,
      title: req.body.title,
      body: req.body.body,
    });
    userexist.blogs.push(blogPost._id);
    await userexist.save();
    res.status(201).json({ blog: blogPost });
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

router.patch(
  "/updateBlog/:id",

  middleware.checkToken,
  async (req, res, next) => {
    try {
      const blogexist = await BlogPost.findOne({ _id: req.params.id });
      if (blogexist === null) {
        throw new Error("Blog does not exist");
      }
      if (blogexist.user.toString() !== req.user.id) {
        throw new Error("Not authorised to update blog");
      }
      const blog = await BlogPost.findOneAndUpdate(
        { _id: req.params.id, user: req.user.id },
        {
          $set: {
            title: req.body.title ? req.body.title : blogexist.title,
            body: req.body.body ? req.body.body : blogexist.body,
          },
        },
        { new: true }
      );
      res.status(200).json({ data: blog });
    } catch (err) {
      res.status(403).json({ msg: err.message });
      next(err);
    }
  }
);

router.patch(
  "/add/coverImage/:id",
  middleware.checkToken,
  file.multerUpload.single("img"), // image is used as key in form body
  async (req, res, next) => {
    try {
      if (req.file) {
        const blog_exist = await BlogPost.findOne({
          _id: req.params.id,
        });
        if (blog_exist === null) {
          throw new Error("Blog does not exist");
        }
        const old_public_id = blog_exist.coverImage.public_id;
        const image = file.dataUri(req).content;
        const result = await cloud.uploader.upload(image, {
          folder: "blog_app/blogs",
          // use_filename: true,
          unique_filename: true,
        });
        if (old_public_id != "") {
          console.log("deleting image");
          const del = await cloud.uploader.destroy(old_public_id);
        }
        const blog = await BlogPost.findOneAndUpdate(
          { _id: req.params.id },
          {
            $set: {
              "coverImage.url": result.url,
              "coverImage.public_id": result.public_id,
            },
          },
          { new: true }
        );
        const msg = {
          msg: "image updated successfully",
          data: blog.toJSON(),
        };
        res.status(200).json({ msg });
      } else {
        throw new Error("File not added");
      }
    } catch (err) {
      res.status(500).json({ msg: err.message });
      next(err);
    }
  }
);

router.delete("/delete/:id", middleware.checkToken, async (req, res, next) => {
  try {
    // BlogPost.findOneAndDelete({
    //   $and: [{ user: req.user.id }, { _id: req.params.id }],
    // });
    const blogexist = await BlogPost.findOne({ _id: req.params.id });
    if (blogexist === null) {
      throw new Error("Blog does not exist");
    }
    const old_public_id = blogexist.coverImage.public_id;
    if (blogexist.user.toString() !== req.user.id) {
      throw new Error("Not authorised to delete blog");
    }
    const blog = await BlogPost.findOneAndDelete({
      _id: req.params.id,
    });
    await Comments.deleteMany({ blog: req.params.id });
    if (old_public_id != "") {
      console.log("deleting image");
      const del = await cloud.uploader.destroy(old_public_id);
    }
    await User.updateOne(
      { _id: req.user.id },
      { $pull: { blogs: req.params.id } }
    );
    const msg = {
      msg: "Blog successfully deleted",
      id: blog._id,
      title: blog.title,
      body: blog.body,
    };
    res.status(200).json({ msg });
  } catch (err) {
    res.status(403).json({ msg: err.message });
    next(err);
  }
});

// comments
router.get(
  "/getBlogComments/:id",
  middleware.checkToken,
  async (req, res, next) => {
    try {
      // const blog = await BlogPost.findById(req.params.id, {
      //   fields: { comments: 1 },
      // }).populate("comments");
      const comments = await Comments.find({
        blog: req.params.id,
      }).populate({ path: "user", select: "username _id" });
      res.status(200).json({ data: comments });
    } catch (err) {
      res.status(500).json({ msg: err.message });
      next(err);
    }
  }
);

router.post(
  "/:id/addComment",
  middleware.checkToken,
  async (req, res, next) => {
    try {
      const blogexist = await BlogPost.findOne({ _id: req.params.id });
      if (blogexist === null) {
        throw new Error("Blog does not exist");
      }

      // if (blogexist.user.toString() === req.user.id) {
      //   throw new Error("Not authorised to add comments");
      // }
      const comment = await Comments.create({
        user: req.user.id,
        blog: blogexist,
        content: req.body.content,
      });
      Comments.populate(comment, { path: "user", select: "username _id" });
      blogexist.comments.push(comment._id);
      await blogexist.save();
      // const { password, blogs, ...user } = userexist.toJSON();
      // blogPost.user = user;
      res.status(201).json({ msg: comment });
    } catch (err) {
      res.status(500).json({ msg: err.message });
      next(err);
    }
  }
);

router.patch(
  "/updateComment/:id",
  middleware.checkToken,
  async (req, res, next) => {
    try {
      const commentexist = await Comments.findOne({ _id: req.params.id });
      if (commentexist === null) {
        throw new Error("Comment does not exist");
      }
      if (commentexist.user.toString() !== req.user.id) {
        throw new Error("Not authorised to update comment");
      }
      const comment = await Comments.findOneAndUpdate(
        { _id: req.params.id, user: req.user.id },
        {
          $set: {
            content: req.body.content ? req.body.content : commentexist.content,
          },
        },
        { new: true }
      );
      res.status(200).json({ data: comment });
    } catch (err) {
      res.status(403).json({ msg: err.message });
      next(err);
    }
  }
);

router.delete(
  "/deleteComment/:id",
  middleware.checkToken,
  async (req, res, next) => {
    try {
      const commentexist = await Comments.findOne({ _id: req.params.id });
      if (commentexist === null) {
        throw new Error("Comment does not exist");
      }
      if (commentexist.user.toString() !== req.user.id) {
        throw new Error("Not authorised to delete comment");
      }
      const comment = await Comments.findOneAndDelete({
        _id: req.params.id,
      });
      await BlogPost.updateOne(
        { _id: comment.blog },
        { $pull: { comments: req.params.id } }
      );
      const msg = {
        msg: "Comment successfully deleted",
        id: comment._id,
        content: comment.content,
        user: comment.user,
        blog: comment.blog,
      };
      res.status(200).json({ msg });
    } catch (err) {
      res.status(403).json({ msg: err.message });
      next(err);
    }
  }
);

//likes and dislikes
router.get(
  "/:id/likeDislikeStatus",
  middleware.checkToken,
  async (req, res, next) => {
    try {
      // const user = await User.findById(req.user.id, {
      //   fields: { blogs: 1 },
      // }).populate("blogs");
      const blogexist = await BlogPost.findOne({ _id: req.params.id });
      if (blogexist === null) {
        throw new Error("Blog does not exist");
      }
      if (
        blogexist.likedUsers.filter((user) => user.toString() === req.user.id)
          .length > 0
      ) {
        res.status(200).json({ Status: "liked" });
      } else if (
        blogexist.dislikedUsers.filter(
          (user) => user.toString() === req.user.id
        ).length > 0
      ) {
        res.status(200).json({ Status: "disliked" });
      } else {
        res.status(200).json({ Status: null });
      }
    } catch (err) {
      res.status(500).json({ msg: err.message });
      next(err);
    }
  }
);

router.patch("/:id/like", middleware.checkToken, async (req, res, next) => {
  try {
    const blogexist = await BlogPost.findOne({ _id: req.params.id });
    if (blogexist === null) {
      throw new Error("Blog does not exist");
    }
    if (blogexist.user.toString() === req.user.id) {
      throw new Error("Cannot like your own blog");
    }
    if (
      blogexist.likedUsers.filter((user) => user.toString() === req.user.id)
        .length <= 0
    ) {
      if (
        blogexist.dislikedUsers.filter(
          (user) => user.toString() === req.user.id
        ).length > 0
      ) {
        blogexist.dislikedUsers.pull(req.user.id);
      }
      blogexist.likedUsers.push(req.user.id);
      blogexist.likes = blogexist.likedUsers.length;
      blogexist.dislikes = blogexist.dislikedUsers.length;
      await blogexist.save();
      res.status(201).json({ blog: blogexist });
    } else {
      throw new Error("Already liked");
    }
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

router.patch("/:id/dislike", middleware.checkToken, async (req, res, next) => {
  try {
    const blogexist = await BlogPost.findOne({ _id: req.params.id });
    if (blogexist === null) {
      throw new Error("Blog does not exist");
    }
    if (blogexist.user.toString() === req.user.id) {
      throw new Error("Cannot dislike your own blog");
    }
    if (
      blogexist.dislikedUsers.filter((user) => user.toString() === req.user.id)
        .length <= 0
    ) {
      if (
        blogexist.likedUsers.filter((user) => user.toString() === req.user.id)
          .length > 0
      ) {
        blogexist.likedUsers.pull(req.user.id);
      }
      blogexist.dislikedUsers.push(req.user.id);
      blogexist.likes = blogexist.likedUsers.length;
      blogexist.dislikes = blogexist.dislikedUsers.length;
      await blogexist.save();
      res.status(201).json({ blog: blogexist });
    } else {
      throw new Error("Already disliked");
    }
  } catch (err) {
    res.status(500).json({ msg: err.message });
    next(err);
  }
});

module.exports = router;
