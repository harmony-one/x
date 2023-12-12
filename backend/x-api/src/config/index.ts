import * as process from 'process';

export default () => ({
  port: parseInt(process.env.PORT, 10) || 3000,
  twitter: {
    username: process.env.TWITTER_USERNAME || ''
  }
});
