import {identify, track} from '../helpers/mixpanel';
import {parseLocation} from '../helpers/url';

export default class MainView {
  mount() {
    typeof current_user !== 'undefined' && mixpanel.identify(current_user.data);

    $(".carousel.lazy").on("slide.bs.carousel", function(ev) {
      var lazy;
      lazy = $(ev.relatedTarget).find("img[data-src]");

      lazy.attr("srcset", lazy.data('srcset'));
      lazy.removeAttr("data-srcset");

      lazy.attr("src", lazy.data('src'));
      lazy.removeAttr("data-src");
    });

    $('[data-target="#contactModal"]').click(function() {
      const params = parseLocation();
      track("OPEN_CONTACT_MODAL", params);
    });
  }

  unmount() {
  }
}
