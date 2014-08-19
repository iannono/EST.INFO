$(document).ready ->
  $(".modal-show").on 'click', ->
    modal_id = $(this).data("for")
    $("##{modal_id}").prop("checked", true)

  $(".modal-close").on 'click', ->
    modal_id = $(this).data("for")
    $("##{modal_id}").prop("checked", false)
