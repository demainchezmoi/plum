import 'phoenix_html';
import '../css/app.scss';

jQuery.fn.extend({
  scrollToMe: function () {
    var x = jQuery(this).offset().top - 100;
    jQuery('html,body').animate({scrollTop: x}, 400);
  }
});

$("#interested-button").click(function() {
  $("#contact-form").scrollToMe();
});

