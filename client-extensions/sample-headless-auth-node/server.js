const express = require('express');
const axios = require('axios');
const app = express();
const port = 8080;

// Environment variables injected by Liferay/LDM
const liferayHost = process.env.COM_LIFERAY_LXC_DXP_MAIN_DOMAIN || 'localhost:8080';
const liferayProtocol = process.env.COM_LIFERAY_LXC_DXP_SERVER_PROTOCOL || 'http';
const clientId = process.env.LXC_CLIENT_ID;
const clientSecret = process.env.LXC_CLIENT_SECRET;

app.get('/', async (req, res) => {
  try {
    if (!clientId || !clientSecret) {
      return res.status(500).send('Missing LXC_CLIENT_ID or LXC_CLIENT_SECRET environment variables. Ensure these are set in your environment.');
    }

    const liferayUrl = `${liferayProtocol}://${liferayHost}`;
    
    // 1. Get Access Token (Client Credentials Grant)
    console.log(`Requesting token from ${liferayUrl}/o/oauth2/token...`);
    
    const tokenResponse = await axios.post(`${liferayUrl}/o/oauth2/token`, new URLSearchParams({
      'client_id': clientId,
      'client_secret': clientSecret,
      'grant_type': 'client_credentials'
    }));

    const accessToken = tokenResponse.data.access_token;
    console.log('Successfully obtained access token.');

    // 2. Call Headless API (e.g., Get sites list - better for service accounts)
    console.log('Calling Headless API...');
    const apiResponse = await axios.get(`${liferayUrl}/o/headless-delivery/v1.0/sites`, {
      headers: {
        'Authorization': `Bearer ${accessToken}`
      }
    });

    res.json({
      message: 'Successfully authorized and called Liferay Headless API!',
      sitesData: apiResponse.data
    });

  } catch (error) {
    console.error('Error during headless auth flow:', error.message);
    if (error.response) {
      console.error('Data:', error.response.data);
    }
    res.status(500).send(`Auth flow failed: ${error.message}`);
  }
});

app.listen(port, () => {
  console.log(`Sample Headless Auth extension listening at http://localhost:${port}`);
});
