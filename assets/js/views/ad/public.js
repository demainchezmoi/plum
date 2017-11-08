import MainView from '../main';
import {track} from '../../helpers/mixpanel';

module.exports = class View extends MainView {
  mount() {
    super.mount();
    this.trackPage();
    this.loadMap(window.land_location);
  }

  unmount() {
    super.unmount();
  }

  trackPage() {
    const path_elements = window.location.pathname.split('/');
    const ad = path_elements[path_elements.length - 1];
    track("VISIT_AD", {ad: ad})
  }

  loadMap({lat, lng}) {
    const map = L.map('map').setView([lat, lng], 13);

    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png').addTo(map);
    map.panTo(new L.LatLng(lat, lng));

    new L.circle([lat, lng], 1000).addTo(map);
  }
}
