import Elm from '../elm-prospect/Main.elm';

const elmDiv = document.querySelector('#elm_target');
var map;

// Effects

if (elmDiv) {
  const app = Elm.Main.embed(elmDiv, { apiToken: getToken() });

  app.ports.landMap.subscribe(landMap);
  app.ports.mixpanel.subscribe(track);
  app.ports.removeLandMap.subscribe(removeLandMap);
}

window.addEventListener('DOMContentLoaded', handleDOMContentLoaded, false);


// Functions

function landMap({lat, lng}) {
  const test = () => document.getElementById('map') !== null;
  tryFunction(test, () => loadMap({lat, lng}));
}

function track([event, data]) {
  mixpanel.track(event, data);
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

function identify() {
  if (typeof mixpanel !== 'undefined' && typeof current_user !== 'undefined') {
    try {
      const user = current_user.data;

      mixpanel.identify(user.id);

      mixpanel.people.set({
        $email: user.email,
        $first_name: user.first_name,
        $last_name: user.last_name
      });

    } catch(e) {
      console.log("mixpanel identify failed", e);
    }
  }
}

function handleDOMContentLoaded() {
  identify();
}
