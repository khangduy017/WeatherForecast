import sendMail from '../utils/mailer.js';
import catchAsync from '../utils/catchAsync.js';
import REGEX from '../constants/regex.js';
import Validator from '../utils/validator.js';

let verifyList = {};

const subscribeForecast = catchAsync(async (req, res) => {
  const data = req.body;

  if (!Validator.isMatching(data.email, REGEX.EMAIL)) {
    res.status(400).json({
      status: 'error',
      message: 'Invalid email address',
    });
  }

  let verifyCode = Math.floor(100000 + Math.random() * 900000);
  await sendMail(
    data.email,
    'Your OTP code is [' + verifyCode + ']',
    'Use this code to complete subscription: ' + verifyCode
  );
  verifyList[data.email] = verifyCode;

  res.status(200).json({
    status: 'success',
    message: 'Subscribed successfully',
  });
});

const verifyForecast = catchAsync(async (req, res) => {
  const data = req.body;

  if (data.code !== verifyList[data.email].toString()) return next(new AppError('Invalid OTP code', 400));
  verifyList[data.email] = null;
  res.status(200).json({
    status: 'success',
    message: 'Verified successfully',
  });
});

export default { subscribeForecast, verifyForecast };