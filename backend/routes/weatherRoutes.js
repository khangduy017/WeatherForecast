import express from 'express'
import weatherController from '../controllers/weatherController.js';

const router = express.Router()

router.post('/get-current-weather', weatherController.getWeather);
router.post('/get-forecast-weather', weatherController.getForecastWeather);

export default router;