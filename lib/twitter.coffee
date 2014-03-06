passport = require 'passport'

Strategy = require("passport-twitter").Strategy
CONSUMER_KEY = "wpeHXSNTLF8j1cCLvjgQ3g"
CONSUMER_SECRET = "6n2FEfUUasGyf1HCI9hAs5i13CrJnju80CRleYl0E"
service = "twitter"

module.exports = (app, options) ->
  passport.use new Strategy
    consumerKey: CONSUMER_KEY
    consumerSecret: CONSUMER_SECRET
    callbackURL: options.urlPrefix + "/auth/#{service}/callback"

    (token, tokenSecret, profile, done) ->
      done null,
        provider: profile.provider
        id: profile.id
        access: token
        secret: tokenSecret
        refresh: null
        username: profile.username
        name: profile.displayName

