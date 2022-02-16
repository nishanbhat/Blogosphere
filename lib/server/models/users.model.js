const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");

const Schema = mongoose.Schema;

const User = Schema(
  {
    username: {
      type: String,
      required: true,
      unique: true,
    },
    password: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
    },
    otp: {
      type: String,
      default: null,
    },
    blogs: [{ type: mongoose.Schema.Types.ObjectId, ref: "BlogPost" }],
  },
  { timestamps: true }
);

//below function takes place before password is saved so that we can encrypt the password
//in edge case or gotcha you need to use the keyword function instead of arrow function
User.pre("save", async function (next) {
  try {
    if (!this.isModified("password")) {
      return next(); //if password isn't modified you send it to next function
    }
    const hashed = await bcrypt.hash(this.password, 10); //hashing function with strength 10
    this.password = hashed; //saving the hashed password in the actual schema object
    return next();
  } catch (err) {
    return next(err);
  }
});

// User.pre("findOneAndUpdate", async function (next) {
//   try {
//     // let update = {...this.getUpdate()};
//     // const docToUpdate = await this.model.findOne(this.getQuery());
//     // const hashed = await bcrypt.hash(docToUpdate.password, 10); 
//     // docToUpdate.password = hashed; 
//     // await docToUpdate.save();
//     // update[$set].password;
//     // console.log(update.password);
//     // if (update.password){
//     //   update.password = await bcrypt.hash(update.password, 10);
//     //   console.log(update.password);
//     //   this.setUpdate(update);
//     //   }
//     // console.log(this.password);
//     return next();
//   } catch (err) {
//     return next(err);
//   }
// });

//to compare the attempted password with the one stored
User.methods.comparePassword = async function (attempt, next) {
  try {
    return await bcrypt.compare(attempt, this.password);
  } catch (err) {
    return next(err);
  }
};

module.exports = mongoose.model("User", User);
