jade = require 'jade'
passport = require 'passport'
fs = require 'fs'
path = require 'path'
require 'debug-fork'
debug = global.debug 'oauth'

# requires express.session (for Oauth 1) and express.cookieParser

state = "QjjsYtwzNtE90sdCv+tTGqk4v/6gZXoRfw5tZv+5cDDusuXVU/wUZc9U"

authSucceeded = do ->
  jadeSrc = fs.readFileSync path.resolve(__dirname, "lib/auth/succeeded.jade"), encoding:'utf-8'
  jadeFn = jade.compile jadeSrc, client: false, clientDebug: false
  (req, res, info) -> res.end jadeFn oauth: info

authFailed = do ->
  jadeSrc = fs.readFileSync path.resolve(__dirname, "lib/auth/failed.jade"), encoding:'utf-8'
  jadeFn = jade.compile jadeSrc, client: false, clientDebug: false
  htmlSrc = jadeFn()
  (req, res) -> res.end htmlSrc

module.exports = fn = (app, options={}) ->
  options.protocol ||= 'http'
  options.host ||= '127.0.0.1'

  options.urlPrefix = "#{options.protocol}://#{options.host}#{if options.port then ":#{options.port}" else ''}"

  app.configure ->
    app.use passport.initialize()
    app.use passport.session()

  for fileName in fs.readdirSync path.resolve(__dirname,'./lib') when fileName isnt 'auth' and fileName.charAt(0) isnt '.'
    do (service = path.basename fileName, path.extname fileName) ->
      require("./lib/#{service}") app, options

      app.get "/auth/#{service}", passport.authenticate(service, state: state)

      app.get "/auth/#{service}/callback", (req, res, next) ->
        handler = passport.authenticate service, (err, info) ->
          debug "oauth error: ",err if err?
          debug "oauth info: ",info if info?
          return authFailed req, res if err? or !info
          authSucceeded req, res, info
        handler req, res, next

  return

fn.startOauth = (service, cb) ->
  cb "EINVALID" # can't call this on the server

fn.stopOauth = ->
