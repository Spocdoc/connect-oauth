OAUTH_POLL_MS = 100
oauthTimer = null
oauthChild = null
oauthCb = null

checkOauthChild = ->
  window['oauthFailed']() if oauthChild.closed
  return

startOauth = (service, cb) ->
  if oauthChild
    oauthChild.close()
    clearInterval oauthTimer
    oauthCb? "EANOTHER"

  oauthCb = cb

  oauthChild = window.open "/auth/#{service}"
  oauthTimer = setInterval checkOauthChild, OAUTH_POLL_MS
  return

stopOauth = ->
  clearInterval oauthTimer
  oauthCb = oauthChild = null
  return

window['oauthFailed'] = ->
  cb = oauthCb
  stopOauth()
  cb? "EFAILED"
  return

window['oauthSucceeded'] = (info_) ->
  # build a local object inheriting from Object (otherwise it apparently doesn't)
  info = {}
  info[k] = v for k,v of info_
  cb = oauthCb
  stopOauth()
  cb? null, info
  return

module.exports = {startOauth, stopOauth}
