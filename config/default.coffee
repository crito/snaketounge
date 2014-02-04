{join} = require('path')

module.exports =
  uploadDir: join(process.cwd(), 'uploads')
  redis:
    host: 'localhost'
    port: 6379
    purgeQueue: "purge"
    activeQueue: "files"
