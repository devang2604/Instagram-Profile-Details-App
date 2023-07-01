const express = require('express');
const axios = require('axios');
const cheerio = require('cheerio');

const app = express();

app.get('/profile/:username', async (req, res) => {
  const username = req.params.username;

  try {
    const response = await axios.get(`https://www.instagram.com/${username}`);
    const $ = cheerio.load(response.data);

    const followers = $('meta[property="og:description"]').attr('content');
    const followerCount = followers ? followers.split(' ')[0] : 'N/A';

    const following = $('meta[property="og:description"]').attr('content');
    const followingCount = following ? following.split(' ')[2] : 'N/A';

    const postsCount = $('span.g47SY').eq(0).text() || 'N/A';

    const profileDetails = {
      username,
      followers: followerCount,
      following: followingCount,
      posts: postsCount,
    };

    res.json(profileDetails);
  } catch (error) {
    console.error('Error:', error.message);
    res.status(500).json({ error: 'An error occurred' });
  }
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});