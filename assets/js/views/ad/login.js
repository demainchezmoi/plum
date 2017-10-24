import MainView from '../main';
import {track} from '../../helpers/mixpanel';

module.exports = class View extends MainView {
  mount() {
    super.mount();
    this.trackPage();
  }

  unmount() {
    super.unmount();
  }

  trackPage() {
    const path_elements = window.location.pathname.split('/');
    const ad = path_elements[path_elements.length - 2];
    track("VISIT_LOGIN", {ad: ad})
  }
}

