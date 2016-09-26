$(document).on('turbolinks:load', function(){
  $('.edit_ticket input[type=checkbox]').click(function() {
    $(this).parent().parent('form').submit();
  });
});
