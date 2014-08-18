# keyboard binding for navigate

# next
KeyboardJS.on 'j', ->
  selected = $(".selected")
  if selected.length > 0
    selected.removeClass("selected")
    selected.next().addClass("selected")
  else
    $(".entry").first().addClass("selected")

  console.log("j")

# prev
KeyboardJS.on 'k', ->
  selected = $(".selected")
  if selected.length > 0
    selected.removeClass("selected")
    selected.prev().addClass("selected")
  console.log("k")

# open
KeyboardJS.on 'o', ->
  console.log("o")

# close
KeyboardJS.on 'c', ->
  console.log("c")

# top
KeyboardJS.on 'h', ->
  console.log("h")

