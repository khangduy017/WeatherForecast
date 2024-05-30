import sendMail from '../utils/mailer.js';
import catchAsync from '../utils/catchAsync.js';
import REGEX from '../constants/regex.js';
import Validator from '../utils/validator.js';
import Subscribe from '../models/subscribeModel.js';

let verifyList = {};

const subscribeForecast = catchAsync(async (req, res) => {
  const data = req.body;

  if (!Validator.isMatching(data.email, REGEX.EMAIL)) {
    res.status(400).json({
      status: 'error',
      message: 'Invalid email address. Please try again.',
    });
  }

  const subcribe = await Subscribe.findOne({ email: data.email });
  if (subcribe) {
    return res.status(400).json({
      status: 'error',
      message: 'Email already subscribed. Please try again.',
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

const resendCode = catchAsync(async (req, res) => {
  const data = req.body;

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
  await Subscribe.create({
    email: data.email,
    location: data.location,
  });

  res.status(200).json({
    status: 'success',
    message: 'Verified successfully',
  });
});

const unsubscribeForecast = catchAsync(async (req, res) => {
  const data = req.body;

  try {
    await Subscribe.deleteOne({ 'email': data.email });
  } catch (error) {
    console.log(error);
    return res.status(400).json({
      status: 'error',
      message: 'Email not found. Please try again.',
    });
  }

  res.status(200).json({
    status: 'success',
    message: 'Unsubscribe successfully!',
  });
});

export default { subscribeForecast, verifyForecast,resendCode, unsubscribeForecast };