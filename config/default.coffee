module.exports =
  uploadDir: require('path').join(process.cwd(), 'uploads')
  redis:
    host: 'localhost'
    port: 6379
    purgeQueue: "purge"
    activeQueue: "files"
