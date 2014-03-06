passport = require 'passport'
debug = global.debug 'oauth'

Strategy = require("passport-linkedin-oauth2").Strategy
CLIENT_ID = "77c9wof3bvonzn"
CLIENT_SECRET = "5gsONtluLNnnjhby"
service = "linkedin"

module.exports = (app, options) ->
  passport.use new Strategy
    clientID: CLIENT_ID
    clientSecret: CLIENT_SECRET
    callbackURL: options.urlPrefix + "/auth/#{service}/callback"
    scope: [ 'r_basicprofile', 'r_emailaddress']
    passReqToCallback: true

    (req, accessToken, refreshToken, profile, done) ->
      req.session.accessToken = accessToken
      debug "oauth got profile",profile
      done null,
        provider: profile.provider
        id: profile.id
        access: accessToken
        secret: null
        refresh: refreshToken
        name: profile.displayName
        email: profile.emails?[0]?.value or null
        username: null


