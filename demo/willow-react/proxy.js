const httpProxy = require('http-proxy');
//
// Create your proxy server and set the target in the options.
//
const proxy = httpProxy.createProxyServer({
    target: 'localhost:8000',
    secure: false
}).listen(8000); // See (†)

proxy.on('proxyRes', function (proxyRes, req, res) {
    console.log('Raw [target] response', JSON.stringify(proxyRes.headers, true, 2));


    proxyRes.headers['x-reverse-proxy'] = "custom-proxy";
    proxyRes.headers['cache-control'] = "max-age=10000";

    console.log('Updated [proxied] response', JSON.stringify(proxyRes.headers, true, 2));

    // Do not use res.setHeader as they won't override headers that are already defined in proxyRes
    // res.setHeader('cache-control', 'max-age=10000');
    // res.setHeader('x-reverse-proxy', 'custom-proxy');

});