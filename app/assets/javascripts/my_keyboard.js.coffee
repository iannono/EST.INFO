# keyboard binding for navigate

# next
KeyboardJS.on 'j', ->
  selected = $(".selected")
  if selected.length > 0
    if selected.attr("id") == $(".entry").last().attr("id")
      return
    selected.removeClass("selected")
    selected.nextAll(".entry").first().trigger("select.entry")
  else
    $(".entry").first().trigger("select.entry")

# scroll down
KeyboardJS.on 'shift + j', ->
  $("body").scrollTop($("body").scrollTop() + 30) 

# prev
KeyboardJS.on 'k', ->
  selected = $(".selected")
  if selected.length > 0
    if selected.attr("id") == $(".entry").first().attr("id")
      return
    selected.removeClass("selected")
    selected.prevAll(".entry").first().trigger("select.entry")

# scroll up
KeyboardJS.on 'shift + k', ->
  $("body").scrollTop($("body").scrollTop() - 30) 

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

