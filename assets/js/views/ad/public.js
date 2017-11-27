import MainView from '../main';
import {track} from '../../helpers/mixpanel';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

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
    const map = L.map('map', {scrollWheelZoom: false}).setView([lat, lng], 13);

    const layers = 'https://korona.geog.uni-heidelberg.de/tiles/roads/x={x}&y={y}&z={z}';
    L.tileLayer(layers, {}).addTo(map);
    map.panTo(new L.LatLng(lat, lng));

    new L.circle([lat, lng], 1000).addTo(map);
  }
}
