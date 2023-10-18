const config = {
  tts: {
    plugin: process.env.REACT_APP_TTS_PLUGIN || 'elevenlabs' // 'elevenlabs'
  },
  proxyHost: process.env.REACT_APP_PROXY_HOST || ''
} as const;


export default config;