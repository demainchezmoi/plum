// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".

import 'phoenix_html'

// import 'mdbootstrap/js/jquery-3.2.1.min.js'
// import 'waves/dist/waves.js'
// import 'mdbootstrap/js/popper.min.js'
// import 'mdbootstrap/js/bootstrap.js'
// import 'mdbootstrap/js/mdb.js'

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

jQuery.fn.extend({
  scrollToMe: function () {
    var x = jQuery(this).offset().top - 100;
    jQuery('html,body').animate({scrollTop: x}, 400);
  }
});

$("#interested-button").click(function() {
  $("#contact-form").scrollToMe();
});
