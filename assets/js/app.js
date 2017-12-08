require('bootstrap/dist/js/bootstrap')

import 'phoenix_html';
import loadView from './views/loader';
import '../css/app.scss';

jQuery.fn.extend({
  scrollToMe: function () {
    var x = jQuery(this).offset().top - 100;
    jQuery('html,body').animate({scrollTop: x}, 400);
  }
});

function handleDOMContentLoaded() {
  const viewName = document.getElementsByTagName('body')[0].getAttribute('data-js-view-path');

  const view = loadView(viewName);
  view.mount();

  window.currentView = view;
}

function handleDocumentUnload() {
  window.currentView.unmount();
}

window.addEventListener('DOMContentLoaded', handleDOMContentLoaded, false);
window.addEventListener('unload', handleDocumentUnload, false);
