import Elm from '../elm-prospect/Main.elm';
import {track, identify} from './helpers/mixpanel';

const elmDiv = document.querySelector('#elm_target');
var map;

// Effects

if (elmDiv) {
  const app = Elm.Main.embed(elmDiv, { apiToken: getToken() });

  app.ports.landMap.subscribe(landMapPort);
  app.ports.mixpanel.subscribe(trackPort);
  app.ports.removeLandMap.subscribe(removeLandMapPort);
}

window.addEventListener('DOMContentLoaded', handleDOMContentLoaded, false);


// Functions

function landMapPort({lat, lng}) {
  const test = () => document.getElementById('map') !== null;
  tryFunction(test, () => loadMap({lat, lng}));
}

function trackPort([event, data]) {
  track(event, data);
}

function removeLandMapPort() {
  if (!!map && !!map.remove) {
    try {
      map.remove();
      map = null;
    } catch (err) {
      console.error(err);
    }
  }
}

function loadMap({lat, lng}) {
  map = L.map('map').setView([lat, lng], 12)

  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png').addTo(map)
  map.panTo(new L.LatLng(lat, lng))

  new L.circle([lat, lng], 2000).addTo(map)
}


function getToken() {
  const token_meta = $('meta[name=token]');
  return token_meta.attr('content');
}

function tryFunction(test, fun, count = 0) {
  if (count > 50) {
    return;
  } else if (!!test()) {
    fun();
  } else {
    setTimeout(() => tryFunction(test, fun, count + 1), 20);
  }
}

function handleDOMContentLoaded() {
  typeof current_user !== 'undefined' && identify(current_user.data);
}
