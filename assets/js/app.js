require('bootstrap/dist/js/bootstrap')

import 'phoenix_html';
import '../css/app.scss';


// import 'waves/dist/waves.js'
import 'mdbootstrap/js/mdb.js'

jQuery.fn.extend({
  scrollToMe: function () {
    var x = jQuery(this).offset().top - 100;
    jQuery('html,body').animate({scrollTop: x}, 400);
  }
});
