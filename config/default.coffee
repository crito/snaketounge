module.exports =
  maxUploadSize: 5 * 1024 * 1024   # 5MB
  uploadDir: require('path').join(process.cwd(), 'uploads')
  redis:
    host: 'localhost'
    port: 6379
    purgeQueue: "purge"
    activeQueue: "files"
