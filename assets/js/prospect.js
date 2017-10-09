import Elm from '../elm-prospect/Main.elm';
import GoogleMapsLoader from 'google-maps';

GoogleMapsLoader.KEY = 'AIzaSyBA_MaRLk3bPbnD5PSldfqW6pW42DORpJU';
GoogleMapsLoader.LIBRARIES = ['places', 'drawing'];

const elmDiv = document.querySelector('#elm_target');

if (elmDiv) {
  var app = Elm.Main.embed(elmDiv, { apiToken: getToken() });

  app.ports.gmap.subscribe(function(coordinates) {
    initMap(coordinates)
  });
}

loadGoogleMaps();

function getToken() {
  const token_meta = $('meta[name=token]');
  return token_meta.attr('content');
}

function initMap(latLng) {
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 4,
    center: latLng
  });
  var marker = new google.maps.Marker({
    position: latLng,
    map: map
  });
}

function loadGoogleMaps(){
  var script_tag = document.createElement('script');
  script_tag.setAttribute("type","text/javascript");
  script_tag.setAttribute("src","http://maps.google.com/maps/api/js?sensor=false");
  (document.getElementsByTagName("head")[0] || document.documentElement).appendChild(script_tag);
}
