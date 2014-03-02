passport = require 'passport'

EvernoteStrategy = require("passport-evernote").Strategy
EVERNOTE_CONSUMER_KEY = "mikerobe89"
EVERNOTE_CONSUMER_SECRET = "e473f9f726283f9f"

module.exports = (app, options) ->
  passport.use new EvernoteStrategy
    requestTokenURL: "https://sandbox.evernote.com/oauth"
    accessTokenURL: "https://sandbox.evernote.com/oauth"
    userAuthorizationURL: "https://sandbox.evernote.com/OAuth.action"
    consumerKey: EVERNOTE_CONSUMER_KEY
    consumerSecret: EVERNOTE_CONSUMER_SECRET
    callbackURL: options.urlPrefix + "/auth/evernote/callback"

    (token, tokenSecret, profile, done) ->
      done null,
        provider: profile.provider
        id: profile.id
        access: token
        secret: tokenSecret
        refresh: null

