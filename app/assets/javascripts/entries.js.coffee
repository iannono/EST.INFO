$(document).on 'click', '.entry', (e)->
  entry = $(this)
  entry_id = entry.attr("id")

  if entry.hasClass("current")
    entry.removeClass("current")
    entry.next('.detail').fadeOut()
  else
    $(".entry").removeClass("current")
    entry.addClass("current")
    if entry.next().hasClass("detail") && !entry.next().is(':visible')
      $(".detail").hide()
      entry.next('.detail').fadeIn()
      return

    $.ajax({
      dataType: "json"
      url: "/entries/#{entry_id}"
      success: (data) ->
        if data.result == true
          $(".detail").hide()
          $(".entry##{entry_id}").after("<div class='detail'>#{data.content}</div>").fadeIn(700)
        else
          console.log("some error")
    })

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
