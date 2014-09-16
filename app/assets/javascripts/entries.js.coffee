
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
  
# == binding events to entry ==
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

    # $(".detail").hide() unless entry_id == $(".selected").attr("id")
    entry.trigger("move.entry.adjust")

    if entry.next().hasClass("detail") && !entry.next().is(':visible')
      entry.next().fadeIn()
    else if entry.next().hasClass("detail") && entry.next().is(":visible")
      entry.next().fadeOut()
    else 
      $.ajax({
        dataType: "json"
        url: "/entries/#{entry_id}"
        success: (data) ->
          if data
            content = "<div class='detail'>#{data.content}<p class='bottom'>#{data.source}&nbsp;&nbsp;#{data.city || ''}&nbsp;&nbsp;#{data.time}<span class='right'><a href='#{data.product}' target='_blank'>原帖链接</a></span></p></div>"
            $(".entry##{entry_id}").after(content).next().fadeIn(700)
          else
            console.log("some error")
      })

  $(document).on "move.entry.down", ".entry", (e) ->
    entry = $(this)
    entry.trigger("move.entry.adjust")

    if Math.abs(entry.offset().top - ($(window).height() + $("body").scrollTop())) <= 176
      $("body").scrollTop($("body").scrollTop() + 88) 


  $(document).on "move.entry.up", ".entry", (e) ->
    entry = $(this)
    entry.trigger("move.entry.adjust")

    if Math.abs(entry.offset().top - $("body").scrollTop()) <= 88
      $("body").scrollTop($("body").scrollTop() - 88) 

  $(document).on "move.entry.adjust", ".entry", (e) ->
    entry = $(this)

    if ($("body").scrollTop() - entry.offset().top) >= 88
      $("body").scrollTop($("body").scrollTop() - ($("body").scrollTop() - entry.offset().top + $(window).height() / 2))
      return

    if (entry.offset().top - ($(window).height() + $("body").scrollTop())) >= 88
      $("body").scrollTop($("body").scrollTop() + (entry.offset().top - $(window).height() / 2))
      return


