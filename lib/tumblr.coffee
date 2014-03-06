passport = require 'passport'

Strategy = require("passport-tumblr").Strategy
CONSUMER_KEY = "prbOiPsVCzuOxEeUxV4iz0jpfB4uEhvgs7GuDsTYRVbnTXHXul"
CONSUMER_SECRET = "BtIjlFliS7gSU4diz4y3vjoWpwQXvxXrGNXtiKytdgYcEaX2T7"
service = "tumblr"

module.exports = (app, options) ->
  passport.use new Strategy
    consumerKey: CONSUMER_KEY
    consumerSecret: CONSUMER_SECRET
    callbackURL: options.urlPrefix + "/auth/#{service}/callback"

    (token, tokenSecret, profile, done) ->
      done null,
        provider: profile.provider
        id: profile.username
        access: token
        secret: tokenSecret
        refresh: null
        username: profile.username
        email: null
        name: null

