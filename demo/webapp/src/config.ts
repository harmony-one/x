const config = {
  tts: {
    plugin: process.env.REACT_APP_TTS_PLUGIN || 'elevenlabs' // 'elevenlabs'
  },
  gc: {
    projectId: process.env.REACT_APP_GC_PROJECT_ID || '',
    token: process.env.REACT_APP_GC_TOKEN || ''
  }
} as const;


export default config;