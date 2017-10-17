import Elm from '../elm-prospect/Main.elm';

const elmDiv = document.querySelector('#elm_target');
var map;

const identify = () => {
  if (typeof mixpanel !== 'undefined' && typeof current_user !== 'undefined') {
    try {
      mixpanel.identify(current_user.data.id);
    } catch(e) {
      console.log("mixpanel identify failed", e);
    }
  }
}

if (elmDiv) {
  var app = Elm.Main.embed(elmDiv, { apiToken: getToken() });

  app.ports.landMap.subscribe(function({lat, lng}) {
    const test = () => document.getElementById('map') !== null;
    tryFunction(test, () => loadMap({lat, lng}));
  });

  app.ports.mixpanel.subscribe(function([event, data]) {
    mixpanel.track(event, data);
  });

  app.ports.removeLandMap.subscribe(removeLandMap);
}

function removeLandMap() {
  if (!!map && !!map.remove) {
    try {
      map.remove();
      map = null;
    } catch (err) {
      console.error(err);
    }
  }
}

function getToken() {
  const token_meta = $('meta[name=token]');
  return token_meta.attr('content');
}

function loadMap({lat, lng}) {
  map = L.map('map').setView([lat, lng], 13)

  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png').addTo(map)
  map.panTo(new L.LatLng(lat, lng))

  new L.circle([lat, lng], 1000).addTo(map)
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
  identify();
}

window.addEventListener('DOMContentLoaded', handleDOMContentLoaded, false);
