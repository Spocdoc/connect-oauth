passport = require 'passport'

Strategy = require("passport-github").Strategy
CONSUMER_KEY = "2cca29ac2c8cd5b75cc0"
CONSUMER_SECRET = "5a755cde367338a6fa92007f617c7c5be7b292d8"
service = "github"

module.exports = (app, options) ->
  passport.use new Strategy
    clientID: CONSUMER_KEY
    clientSecret: CONSUMER_SECRET
    callbackURL: options.urlPrefix + "/auth/#{service}/callback"

    (accessToken, refreshToken, profile, done) ->
      done null,
        provider: profile.provider
        id: profile.id
        access: accessToken
        secret: null
        refresh: null
        name: profile.displayName or null
        email: profile.emails?[0]?.value or null
        username: profile.username


