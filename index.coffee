jade = require 'jade'
passport = require 'passport'
fs = require 'fs'
path = require 'path'

# requires express.session (for Oauth 1) and express.cookieParser

authSucceeded = do ->
  jadeSrc = fs.readFileSync path.resolve(__dirname, "lib/auth/succeeded.jade"), encoding:'utf-8'
  jadeFn = jade.compile jadeSrc, client: false, clientDebug: false
  (req, res, info) -> res.end jadeFn oauth: info

authFailed = do ->
  jadeSrc = fs.readFileSync path.resolve(__dirname, "lib/auth/failed.jade"), encoding:'utf-8'
  jadeFn = jade.compile jadeSrc, client: false, clientDebug: false
  htmlSrc = jadeFn()
  (req, res) -> res.end htmlSrc

module.exports = (app, options) ->
  options.protocol ||= 'http'
  options.host ||= '127.0.0.1'

  options.urlPrefix = "#{options.protocol}://#{options.host}#{if options.port then ":#{options.port}" else ''}"

  app.configure ->
    app.use passport.initialize()
    app.use passport.session()

  for service in [ 'evernote' ]
    require("./lib/#{service}") app, options

    app.get "/auth/#{service}", passport.authenticate(service)

    app.get "/auth/#{service}/callback", (req, res, next) ->
      handler = passport.authenticate service, (err, info) ->
        return authFailed req, res if err? or !info
        authSucceeded req, res, info
      handler req, res, next

  return

