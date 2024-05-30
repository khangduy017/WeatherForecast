import catchAsync from '../utils/catchAsync.js';
import dotenv from 'dotenv';
import axios from 'axios';

dotenv.config({ path: './config.env' });

const APIkey = process.env.APIKey

const getWeather = catchAsync(async (req, res) => {
  // console.log(APIkey);
  console.log(req.body);

  const location = req.body.location;
  const url = `http://api.weatherapi.com/v1/forecast.json?q=${location}&days=5&&hour=7&key=${APIkey}`;
  // const response = await fetch(url);
  // const responseData = await response.json();
  let data = {}
  try {
    const responseData = await axios.get(url);
    // console.log(responseData.data.location.country);
    responseData.data.forecast.forecastday.shift()
    data = {
      current: {
        cityName: responseData.data.location.name,
        time: responseData.data.location.localtime,
        temperature: responseData.data.current.temp_c,
        wind: responseData.data.current.wind_mph,
        humidity: responseData.data.current.humidity,
        conditionText: responseData.data.current.condition.text,
        conditionIcon: responseData.data.current.condition.icon,
      },
      forecast: responseData.data.forecast.forecastday.map((day) => {
        return {
          date: day.date,
          temperature: day.day.avgtemp_c,
          wind: day.day.maxwind_mph,
          humidity: day.day.avghumidity,
          conditionText: day.day.condition.text,
          conditionIcon: day.day.condition.icon,
        };
      }),
    }
  } catch (error) {
    console.error('Error fetching weather data:', error);
    console.log(error.message)
    if (error.message.includes('ENOTFOUND')) {
      return res.status(400).json({
        status: 'internet',
        data: {},
      });
    } else {
      return res.status(400).json({
        status: 'notfound',
        data: {},
      });
    }


  }

  res.status(200).json({
    status: 'success',
    data: data,
  });
});

const getForecastWeather = catchAsync(async (req, res) => {
  console.log(APIkey);
  console.log(req.body);

  const location = req.body.location;
  const url = `http://api.weatherapi.com/v1/forecast.json?q=${location}&days=14&&hour=7&key=${APIkey}`;
  // const response = await fetch(url);
  // const responseData = await response.json();
  let data = {}
  try {
    const responseData = await axios.get(url);
    // console.log(responseData.data.location.country);
    responseData.data.forecast.forecastday.shift()
    data = {
      current: {
        cityName: responseData.data.location.name,
        time: responseData.data.location.localtime,
        temperature: responseData.data.current.temp_c,
        wind: responseData.data.current.wind_mph,
        humidity: responseData.data.current.humidity,
        conditionText: responseData.data.current.condition.text,
        conditionIcon: responseData.data.current.condition.icon,
      },
      forecast: responseData.data.forecast.forecastday.map((day) => {
        return {
          date: day.date,
          temperature: day.day.avgtemp_c,
          wind: day.day.maxwind_mph,
          humidity: day.day.avghumidity,
          conditionText: day.day.condition.text,
          conditionIcon: day.day.condition.icon,
        };
      }),
    }
  } catch (error) {
    console.error('Error fetching weather data:', error);
  }

  res.status(200).json({
    status: 'success',
    data: data,
  });
});

export default { getWeather, getForecastWeather }
