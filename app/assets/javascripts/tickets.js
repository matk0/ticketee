$(function() {

  $('.edit_ticket input[type=checkbox]').click(function() {
    $(this).parent().parent('form').submit();
  });

  $("#add_file").on("ajax:success", function(event, data) {
    $("#attachments").append(data);
    return $(this).data("params", { index: $("attachments div.file").length });
  });

});
