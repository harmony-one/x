import * as process from 'process';

export default () => ({
  port: parseInt(process.env.PORT, 10) || 3000,
  twitter: {
    bearerToken: process.env.TWITTER_BEARER_TOKEN || ''
  }
});
