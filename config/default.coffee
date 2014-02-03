{join} = require('path')

module.exports =
  upload_dir: join(process.cwd(), 'uploads')
  redis:
    host: 'localhost'
    port: 6379
