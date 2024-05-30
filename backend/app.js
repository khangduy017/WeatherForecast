import express from 'express';
import rateLimit from 'express-rate-limit';
import mongoSanitize from 'express-mongo-sanitize';
import xss from 'xss-clean';
import hpp from 'hpp';
import cors from 'cors';
import globalErrorhandler from "./controllers/ErrorController.js"
import weatherRouter from './routes/weatherRoutes.js';
import subscribeForecastRouter from './routes/subscribeForecastRoutes.js';


const limiter = rateLimit({
  // limiter is now become a middleware function
  max: 1000,
  windowMs: 60 * 60 * 1000,
  message: 'Too many requests from this IP, please try this again in an hour!',
});

const app = express();
app.use(limiter);

app.use(cors());
app.use(mongoSanitize());
app.use(xss());
app.use(hpp());
app.use(
  express.urlencoded({
    extended: true
  })
);

app.use(express.json({ limit: '10mb' }));

app.use('/weatherForecast/api/v1/weather', weatherRouter)
app.use('/weatherForecast/api/v1/subscribe-forecast', subscribeForecastRouter)

app.use(globalErrorhandler);

export default app;