import {identify} from '../helpers/mixpanel';

export default class MainView {
  mount() {
    typeof current_user !== 'undefined' && mixpanel.identify(current_user.data);
  }

  unmount() {
  }
}
