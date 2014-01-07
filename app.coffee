express = require('express')
http    = require('http')
path    = require('path')

app     = express()
server  = require('http').createServer(app)

# if process.env.REDISTOGO_URL
#     redisenv = require('url').parse(process.env.REDISTOGO_URL)
#   console.log redisenv
#   primus  = new require('primus')(server, redis: {
#                                       host: redisenv.hostname,
#                                             port: redisenv.port,
#                                               auth: redisenv.auth.split(':')[1]
#                                             }, transformer: 'websockets')
#           else
#     primus  = new require('primus')(server,
#                                   redis: host: 'localhost', port: 6379
#                                           transformer: 'websockets')
          
Appun.configure ->
  app.set('port', process.env.PORT or 5000)
  app.use(express.favicon())
  app.use(express.logger('dev'))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(express.static(path.join(__dirname, 'out')))

app.configure 'development', ->
  app.use(express.errorHandler())

docpadInstanceConfiguration =
  # Give it our express application and http server
  serverExpress: app
  serverHttp: server
  # Tell it not to load the standard middlewares (as we handled that above)
  middlewareStandard: false

docpadInstance = require('docpad').createInstance docpadInstanceConfiguration, (err) ->
  if err then console.log(err.stack)

  # Tell DocPad to perform a generation, extend our server with its routes,
  # and watch for changes
  docpadInstance.action 'generate server watch', (err) ->
    if err then console.log(err.stack)

app.set('docpadInstance', docpadInstance)
  
require('./routes')(app)

server.listen(app.get('port'))
