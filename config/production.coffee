redisenv = require('url').parse(process.env.REDISTOGO_URL)

module.exports =
  redis:
    host: redisenv.hostname
    port: redisenv.port
    auth: redisenv.auth.split(':')[1]
