
$(document).on 'click', '.entry', (e)->
  $(this).trigger("select.entry")
  $(this).trigger("open.entry") 

$(document).on "page:change", ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next a').attr('href')
      if url && ($(window).scrollTop() > $(document).height() - $(window).height() - 50) && !$("#loading").is(':visible')
        $("#loading").show()
        $.getScript(url)
    $(window).scroll()

$(document).ready ->
  $(".fancybox").fancybox
    openEffect: "elastic"
    closeEffect: "elastic"
    nextEffect: "elastic"
    afterLoad: ->
      @title = "Image " + (@index + 1) + " of " + @group.length + ((if @title then " - " + @title else ""))
  
  $(document).on "select.entry", ".entry", (e)->
    entry = $(this)
    entry_id = entry.attr("id")

    if entry.hasClass("selected") and entry.next().hasClass(".detail") and entry.next().is(":visible")
      entry.removeClass("selected")
    else
      $(".entry").removeClass("selected")
      entry.addClass("selected")
  
  $(document).on "open.entry", ".entry", (e)->
    entry = $(this)
    entry_id = entry.attr("id")

    if entry.next().hasClass("detail") && !entry.next().is(':visible')
      entry.next().fadeIn()
    else if entry.next().hasClass("detail") && entry.next().is(":visible")
      entry.next().fadeOut()
    else 
      $.ajax({
        dataType: "json"
        url: "/entries/#{entry_id}"
        success: (data) ->
          if data.result == true
            $(".entry##{entry_id}").after("<div class='detail'>#{data.content}</div>").next().fadeIn(700)
          else
            console.log("some error")
      })

