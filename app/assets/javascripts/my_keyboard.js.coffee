# keyboard binding for navigate

# next
KeyboardJS.on 'j', ->
  selected = $(".selected")
  if selected.length > 0
    if selected.attr("id") == $(".entry").last().attr("id")
      return
    selected.removeClass("selected")
    entry = selected.nextAll(".entry").first()
    console.log(entry.attr("id"))
    entry.trigger("select.entry")
    entry.trigger("move.entry.down")
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
    entry = selected.prevAll(".entry").first()
    console.log(entry.attr("id"))
    entry.trigger("select.entry")
    entry.trigger("move.entry.up")

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

# bottom
KeyboardJS.on 'l', ->
  selected = $(".selected")
  selected.removeClass("selected")
  $(".entry").last().trigger("select.entry")

