passport = require 'passport'
debug = global.debug 'oauth'

Strategy = require("passport-google-oauth").OAuth2Strategy
CLIENT_ID = "959111264612-9ek4igs9dbb4sqta65inevb63kp2vqfv.apps.googleusercontent.com"
CLIENT_SECRET = "oZgMfnLhZii3SffALyd5l3Vh"
service = "google"

module.exports = (app, options) ->
  passport.use new Strategy
    clientID: CLIENT_ID
    clientSecret: CLIENT_SECRET
    callbackURL: options.urlPrefix + "/auth/#{service}/callback"
    scope: [ 'https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/userinfo.email' ]

    (req, unused, obj, profile, done) ->
      debug "oauth got profile",profile
      done null,
        provider: profile.provider
        id: profile.id
        access: obj.access_token
        secret: obj.id_token
        refresh: null
        name: profile.displayName
        picture: profile._json.picture
        email: email = (profile.emails?[0]?.value or null)
        username: if email then email.replace(/@.*$/,'') else null


