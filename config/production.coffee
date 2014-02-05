redisenv = require('url').parse(process.env.REDISTOGO_URL)

module.exports =
  redis:
    host: redisenv.hostname
    port: redisenv.port
    auth: redisenv.auth.split(':')[1]
  s3:
    key:    process.env.AWS_ACCESS_KEY_ID
    secret: process.env.AWS_SECRET_ACCESS_KEY
    bucket: process.env.S3_BUCKET_NAME
    region: process.env.S3_REGION
  librato:
    email: process.env.LIBRATO_EMAIL
    token: process.env.LIBRATO_TOKEN
