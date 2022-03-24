$(document).ready(function() {
  $(".header_btn, .not_menu").on("click", function () {
    $(".hidden_screen").fadeToggle(0);
    $("body").toggleClass("noscroll");
  });
  $(".header_menu_item a[href]").on("click", function (event) {
    $(".header_btn").trigger("click");
  });
});