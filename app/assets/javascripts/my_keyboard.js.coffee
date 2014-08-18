# keyboard binding for navigate

# next
KeyboardJS.on 'j', ->
  selected = $(".selected")
  if selected.length > 0
    selected.removeClass("selected")
    selected.nextAll(".entry").first().addClass("selected")
  else
    $(".entry").first().addClass("selected")

  console.log("j")

# prev
KeyboardJS.on 'k', ->
  selected = $(".selected")
  if selected.length > 0
    selected.removeClass("selected")
    selected.prevAll(".entry").first().addClass("selected")
  console.log("k")

# open
KeyboardJS.on 'o', ->
  selected = $(".selected")
  if selected.length > 0
    selected.trigger("click")
  console.log("o")

# close
KeyboardJS.on 'c', ->
  selected = $(".selected")
  if selected.length > 0
    selected.trigger("click")
  console.log("c")

# top
KeyboardJS.on 'h', ->
  selected = $(".selected")
  selected.removeClass("selected")
  $(".entry").first().addClass("selected")
  console.log("h")

