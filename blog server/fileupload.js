const multer = require("multer");
const path = require("path");
const DatauriParser = require('datauri/parser');

const parser = new DatauriParser();

const storage = multer.memoryStorage();

// const storage = multer.diskStorage({
//   destination: (req, file, callback) => {
//     callback(null, "./uploads");
//   },
//   filename: (req, file, callback) => {
//     callback(null, req.user.username + ".jpg");
//   },
// });

const fileFilter = (req, file, callback) => {
  if (file.mimetype == "image/jpeg" || file.mimetype == "image/png") {
    callback(null, true);
  } else {
    callback(null, false);
  }
};

const multerUpload = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 6, //1024kb*1024kb = 1mb; 1mb * 6 = 6mb
  },
  // fileFilter: fileFilter, // removing filter as the type we get from frontend isn't jpeg or png
});

// for getting the string from the file buffer
const dataUri = (req) =>
  parser.format(path.extname(req.file.originalname).toString(), req.file.buffer);

module.exports = { multerUpload, dataUri };
