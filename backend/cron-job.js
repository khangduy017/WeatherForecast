import cron from 'node-cron';
import sendMail from './utils/mailer.js';

cron.schedule('*/1 * * * *', () => {
  const currentTime = new Date().toLocaleString();
  console.log(`hello (${currentTime})`);
  // sendMail(
  //   'khangduy017@gmail.com',
  //   'Test cron job',
  //   'Use this code to complete subscription'
  // );
});

export default cron;