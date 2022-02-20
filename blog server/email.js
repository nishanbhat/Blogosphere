const nodemailer = require("nodemailer");

const sendEmail = async (mailObj) => {
  const { from, recipients, subject, html } = mailObj;

  try {
    // Create a transporter
    let transporter = nodemailer.createTransport({
      host: "smtp-relay.sendinblue.com",
      port: 587,
      auth: {
        user: process.env.SENDINBLUE_LOGIN_ID,
        pass: process.env.SENDINBLUE_SMPT_KEY,
      },
    });

    // send mail with defined transport object
    let mailStatus = await transporter.sendMail({
      from: from, // sender address
      to: recipients, // list of recipients
      subject: subject, // Subject line
      html: html, // plain html
    });

    console.log(`Message sent: ${mailStatus.messageId}`);
    return `Email sent. Please verify account`;
  } catch (error) {
    console.error(error);
    throw new Error(
      `Something went wrong in the sendmail method. Error: ${error.message}`
    );
  }
};

module.exports = sendEmail;
