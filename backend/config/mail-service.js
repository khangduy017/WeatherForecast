import dotenv from 'dotenv';
dotenv.config({ path: './config.env' });


const mailConfig = {
  MAILER:process.env.MAIL_MAILER,
  HOST:process.env.MAIL_HOST,
  POST:process.env.MAIL_POST,
  USERNAME:process.env.MAIL_USERNAME,
  PASSWORD:process.env.MAIL_PASSWORD,
  ENCRYPTION:process.env.MAIL_ENCRYPTION,
  FROM_ADDRESS:process.env.MAIL_FROM_ADDRESS,
  FROM_NAME:process.env.MAIL_FROM_NAME,
}

export default mailConfig