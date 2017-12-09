import MainView from '../main';
import GoogleMapsLoader from 'google-maps';
import {track} from '../../helpers/mixpanel';

GoogleMapsLoader.KEY = 'AIzaSyDKvX-CXe8vAoyx69fEk91EmGIyiYydoC0';
GoogleMapsLoader.LIBRARIES = ['places'];

module.exports = class View extends MainView {

  constructor() {
    super();
    this.google = null;
    this.stuck = false;
    this.initMap = this.initMap.bind(this);
    this.setupSticky = this.setupSticky.bind(this);
    this.getDistance = this.getDistance.bind(this);
  }

  mount() {
    super.mount();
    this.h = document.getElementById("ad_stripe");
    this.setupSticky();

    if ((typeof window.ad) !== "undefined") {
      track('VISIT_AD', {ad: window.ad});
    } else {
      track('VISIT_INDEX');
    }

    const lazy = $("img[data-src]");
    const input = $('[data-action=search-location]');

    lazy.each(function() { this.setAttribute("src", this.getAttribute('data-src')); });
    lazy.removeAttr("data-src");

    GoogleMapsLoader.load((google) => {
      this.google = google;
      this.initMap();
    });

    $('[data-action=find-me-a-land]').click(function() {
      $('#contactModal').modal('show');
      $('#contact_remark').val(`Je souhaite trouver un terrain à ${input.val()}`);
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

  getDistance() {
    const topDist = this.h.offsetTop;
    return topDist;
  }

  setupSticky() {
    if (!!this.h) {
      const stickPoint = this.getDistance();
      window.onscroll = (e) => {
        const distance = this.getDistance() - window.pageYOffset;
        const offset = window.pageYOffset;
        if ((distance <= 0) && !this.stuck) {
          this.h.style.position = 'fixed';
          this.h.style.top = '0px';
          this.h.style.right = '0px';
          this.h.style.left = '0px';
          this.h.style['z-index'] = '10';
          this.stuck = true;
        } else if (this.stuck && (offset <= stickPoint)){
          this.h.style.position = 'absolute';
          this.stuck = false;
          this.h.style = '';
        }
      }
    }
  }
}
