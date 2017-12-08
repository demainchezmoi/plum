import MainView from '../main';
import GoogleMapsLoader from 'google-maps';

GoogleMapsLoader.KEY = 'AIzaSyDKvX-CXe8vAoyx69fEk91EmGIyiYydoC0';
GoogleMapsLoader.LIBRARIES = ['places'];

module.exports = class View extends MainView {

  constructor() {
    super();
    this.google = null;
    this.initMap = this.initMap.bind(this);
  }

  mount() {
    super.mount();
    this.place = null;

    const lazy = $("img[data-src]");

    lazy.each(function() { this.setAttribute("src", this.getAttribute('data-src')); });
    lazy.removeAttr("data-src");

    GoogleMapsLoader.load((google) => {
      this.google = google;
      this.initMap();
    });

    $('[data-action=find-me-a-land]').click(function() {
      const input = $('[data-action=search-location]').val();
      $('#contactModal').modal('show');
      $('#contact_remark').val(`Je souhaite habiter à ${input}`);
    });
  }

  unmount() {
    super.unmount();
  }

  initMap() {
    const input = $('[data-action=search-location]')[0];
    const autocompleteOptions = {componentRestrictions: {country: 'fr'}};
    const autocomplete = new this.google.maps.places.Autocomplete(input, autocompleteOptions);
  }
}


var h = document.getElementById("ad_stripe");
var stuck = false;
var stickPoint = getDistance();

function getDistance() {
  var topDist = h.offsetTop;
  return topDist;
}

window.onscroll = function(e) {
  var distance = getDistance() - window.pageYOffset;
  var offset = window.pageYOffset;
  if ( (distance <= 0) && !stuck) {
    h.style.position = 'fixed';
    h.style.top = '0px';
    h.style.right = '0px';
    h.style.left = '0px';
    h.style['z-index'] = '1000';
    stuck = true;
  } else if (stuck && (offset <= stickPoint)){
    h.style.position = 'static';
    stuck = false;
  }
}
