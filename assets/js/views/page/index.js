import MainView from '../main';
import GoogleMapsLoader from 'google-maps';
import {track} from '../../helpers/mixpanel';
import {track as fbqTrack} from '../../helpers/facebook';
import {parseLocation} from '../../helpers/url';

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
    const lazySrcset = $("img[data-srcset]");
    const input = $('[data-action=search-location]');

    lazySrcset.each(function() { this.setAttribute("srcset", this.getAttribute('data-srcset')); });
    lazySrcset.removeAttr("data-srcset");

    lazy.each(function() { this.setAttribute("src", this.getAttribute('data-src')); });
    lazy.removeAttr("data-src");

    GoogleMapsLoader.load((google) => {
      this.google = google;
      this.initMap();
    });

    $('[data-action=find-me-a-land]').click(function() {
      const location = input.val();
      if (!!location) {
        $('#findMeLandModal').modal('show');
        $('[data-role=searched-location-hidden-input]').val(location);
        $('[data-role=searched-location-display]').text(location);
        const params = parseLocation();
        track("OPEN_FIND_LAND", params);
      }
      else {
        input.addClass('shake');
        setTimeout(() => input.removeClass('shake'), 1000);
      }
    });

    $('form[action="/contact"]').submit(function() {
      const params = parseLocation();
      track("SUBMIT_CONTACT", params);
      fbqTrack('CompleteRegistration');
      return true;
    });
  }

  unmount() {
    super.unmount();
  }

  initMap() {
    const input = $('[data-action=search-location]')[0];
    const autocompleteOptions = {componentRestrictions: {country: 'fr'}};
    const autocomplete = new this.google.maps.places.Autocomplete(input, autocompleteOptions);
    /**
      * autocomplete.addListener('place_changed', function() {
      *   const place = autocomplete.getPlace();
      *   console.log(place);
      * })
      */
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
