# ====NProgress====
NProgress.configure
  speed: 700
  minimum: 0.7
  ease: 'ease'

startSpinner = ->
  NProgress.inc()
stopSpinner = ->
  NProgress.done()
removeSpinner = ->
  NProgress.remove()

$(document).on "page:load", startSpinner
$(document).on "page:fetch", startSpinner
$(document).on "page:change", stopSpinner
$(document).on "page:restore", removeSpinner
$(document).on "page:receive", stopSpinner
$(document).on "ajax:before", startSpinner
$(document).on "ajax:complete", stopSpinner

$(document).ready ->
  startSpinner()
$(document).ajaxStart ->
  startSpinner()
$(document).ajaxStop ->
  stopSpinner()
