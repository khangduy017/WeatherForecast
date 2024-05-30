import express from 'express'
import subscribeForecastController from '../controllers/subscribeForecastController.js';

const router = express.Router()

router.post('/subscribe-forecast', subscribeForecastController.subscribeForecast);
router.post('/verify-code', subscribeForecastController.verifyForecast);
router.post('/unsubscribe-forecast', subscribeForecastController.unsubscribeForecast);
router.post('/resend-code', subscribeForecastController.resendCode);

export default router;