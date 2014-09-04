# ====NProgress====
NProgress.configure
  speed: 700
  minimum: 0.7
  ease: 'ease'

startSpinner = ->
  NProgress.start()
increaseSpinner = ->
  NProgress.inc()
stopSpinner = ->
  NProgress.done()
removeSpinner = ->
  NProgress.remove()

$(document).on "page:fetch", startSpinner
$(document).on "page:change", stopSpinner
$(document).on "page:restore", removeSpinner

$(document).ready ->
  startSpinner()
$(document).ajaxStart ->
  increaseSpinner()
$(document).ajaxStop ->
  stopSpinner()
