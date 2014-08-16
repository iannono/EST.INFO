$(document).on 'click', '.entry', (e)->
  entry_id = e.target.parentNode.id
  $.ajax({
    dataType: "json"
    url: "/entries/#{entry_id}"
    success: (data) ->
      if data.result == true
        $("tr.content").hide()
        $(".entry##{entry_id}").after("<tr class='content'><td colspan='6'>#{data.content}</td></tr>")
      else
        console.log("some error")
  })
