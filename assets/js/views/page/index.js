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
    track("VISIT_INDEX")
  }
}

