import cron from 'node-cron';
import sendMail from './utils/mailer.js';
import Subscribe from './models/subscribeModel.js';
import axios from 'axios';


const APIkey = process.env.APIKey

cron.schedule('0 7 * * *', async () => {
  const currentTime = new Date().toLocaleString();
  console.log(`hello (${currentTime})`);
  const subcribeData = await Subscribe.find();
  // console.log(subcribeData);
  for (let i = 0; i < subcribeData.length; i++) {
    console.log(subcribeData[i]);
    const email = subcribeData[i].email;
    const location = subcribeData[i].location;
    const url = `https://api.weatherapi.com/v1/current.json?q=${location}&key=${APIkey}`
    try {
      const responseData = await axios.get(url);
      const htmlContent = `
    <p>Weather forecast information for ${responseData.data.location.localtime.split(' ')[0]}, in ${responseData.data.location.name}:</p>
    <ul>
        <li><strong>Condition:</strong> ${responseData.data.current.condition.text}</li>
        <li><strong>Temperature:</strong> ${responseData.data.current.temp_c}°C</li>
        <li><strong>Wind:</strong> ${responseData.data.current.wind_mph} M/H</li>
        <li><strong>Humidity:</strong> ${responseData.data.current.humidity}%</li>
    </ul>
`;
      sendMail(
        email,
        `Weather forecast information for ${responseData.data.location.localtime.split(' ')[0]}`,
        htmlContent,
      );
    } catch (error) {
      console.error('Error fetching weather data:', error);
      console.log(error.message)
    }
  }
});

export default cron;