passport = require 'passport'

Strategy = require("passport-evernote").Strategy
CONSUMER_KEY = "mikerobe89"
CONSUMER_SECRET = "e473f9f726283f9f"
service = "evernote"

module.exports = (app, options) ->
  passport.use new Strategy
    # requestTokenURL: "https://sandbox.evernote.com/oauth"
    # accessTokenURL: "https://sandbox.evernote.com/oauth"
    # userAuthorizationURL: "https://sandbox.evernote.com/OAuth.action"
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
        username: null
        email: null
        name: null

