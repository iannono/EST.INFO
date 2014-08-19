# keyboard binding for navigate

# next
KeyboardJS.on 'j', ->
  selected = $(".selected")
  if selected.length > 0
    selected.removeClass("selected")
    selected.nextAll(".entry").first().trigger("select.entry")
  else
    $(".entry").first().trigger("select.entry")

# prev
KeyboardJS.on 'k', ->
  selected = $(".selected")
  if selected.length > 0
    selected.removeClass("selected")
    selected.prevAll(".entry").first().trigger("select.entry")

# open
KeyboardJS.on 'o', ->
  selected = $(".selected")
  if selected.length > 0
    selected.trigger("open.entry")

# close
KeyboardJS.on 'c', ->
  selected = $(".selected")
  if selected.length > 0
    selected.trigger("select.entry")

# top
KeyboardJS.on 'h', ->
  selected = $(".selected")
  selected.removeClass("selected")
  $(".entry").first().trigger("select.entry")

