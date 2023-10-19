const config = {
  proxyHost: process.env.REACT_APP_PROXY_HOST || 'https://x-proxy.fly.dev'
} as const;


export default config;
