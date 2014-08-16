$(document).on 'click', '.entry', (e)->
  entry_id = e.target.parentNode.id
  $.ajax({
    dataType: "json"
    url: "/entries/#{entry_id}"
    success: (data) ->
      if data.result == true
        $("tr.content").remove()
        $("#entries").scrollTop($("#entries").prop("scrollHeight"))
        $(".entry##{entry_id}").after("<tr class='content'><td colspan='6'>#{data.content}</td></tr>")
      else
        console.log("some error")
  })

$(document).on "page:change", ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next a').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').text("Fetching more entries...")
        $.getScript(url)
    $(window).scroll()
