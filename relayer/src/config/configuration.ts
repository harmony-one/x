export default () => ({
  port: parseInt(process.env.PORT, 10) || 3000,
  deepgram: {
    apiKey: process.env.DEEPGRAM_API_KEY || ''
  }
});
