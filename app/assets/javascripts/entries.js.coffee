$(document).on 'click', '.entry', (e)->
  entry = $(this)
  entry_id = entry.attr("id")

  if entry.hasClass("current")
    entry.removeClass("current")
    entry.next().hide()
  else
    $(".entry").removeClass("current")
    entry.addClass("current")
    if entry.next(".detail").hasClass("detail")
      entry.next(".detail").show() 
      return

    $.ajax({
      dataType: "json"
      url: "/entries/#{entry_id}"
      success: (data) ->
        if data.result == true
          $(".entry##{entry_id}").after("<div class='detail hide'>#{data.content}</div>").next().fadeIn(700)
        else
          console.log("some error")
    })

$(document).on "page:change", ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next a').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
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
