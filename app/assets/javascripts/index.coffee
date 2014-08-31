$(document).ready ->
  $(".modal-show").on 'click', ->
    modal_id = $(this).data("for")
    console.log(modal_id)
    $("##{modal_id}").prop("checked", true)
    console.log(modal_id)

  $(".modal-close").on 'click', ->
    modal_id = $(this).data("for")
    $("##{modal_id}").prop("checked", false)
