import {identify} from '../helpers/mixpanel';

export default class MainView {
  mount() {
    typeof current_user !== 'undefined' && mixpanel.identify(current_user.data);

    $(".carousel.lazy").on("slide.bs.carousel", function(ev) {
      var lazy;
      lazy = $(ev.relatedTarget).find("img[data-src]");
      lazy.attr("src", lazy.data('src'));
      lazy.removeAttr("data-src");
    });
  }

  unmount() {
  }
}
