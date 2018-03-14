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
    // this.setupSticky = this.setupSticky.bind(this);
    this.getDistance = this.getDistance.bind(this);
    this.setupSmoothScroll();
  }

  mount() {
    super.mount();
    this.h = document.getElementById("ad_stripe");
    // this.setupSticky();

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

  findPostalCode(components) {
    const data = components.filter(c => c.types.indexOf('postal_code') > -1)[0];
    return !!data ? data.short_name : null;
  }

  findCity(components) {
    const data = components.filter(c => c.types.indexOf('locality') > -1)[0];
    return !!data ? data.short_name : null;
  }

  initMap() {
    const inputs = $('[data-action=search-location]');
    const cityInput = $('[data-role=searched-city-hidden-input]');
    const postalCodeInput = $('[data-role=searched-postal-code-hidden-input]');
    const autocompleteOptions = {componentRestrictions: {country: 'fr'}, types: ['(cities)']};
    inputs.each((i, input) => {
      const autocomplete = new this.google.maps.places.Autocomplete(input, autocompleteOptions);
      autocomplete.addListener('place_changed', () => {
        const place = autocomplete.getPlace();
        const postalCode = this.findPostalCode(place.address_components);
        const city = this.findCity(place.address_components);
        inputs.val(place.formatted_address);
        // cityInput.val(city);
        // postalCodeInput.val(postalCode);
      });
    })
  }

  getDistance() {
    const topDist = this.h.offsetTop;
    return topDist;
  }

  setupSmoothScroll() {
    $('a[href*="#"]')
    // Remove links that don't actually link to anything
      .not('[href="#"]')
      .not('[href="#0"]')
      .click(function(event) {
        // On-page links
        if (
          location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') 
          && 
          location.hostname == this.hostname
        ) {
          // Figure out element to scroll to
          var target = $(this.hash);
          target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
          // Does a scroll target exist?
          if (target.length) {
            // Only prevent default if animation is actually gonna happen
            event.preventDefault();
            $('html, body').animate({
              scrollTop: target.offset().top
            }, 400, function() {
              // Callback after animation
              // Must change focus!
              var $target = $(target);
              $target.focus();
              if ($target.is(":focus")) { // Checking if the target was focused
                return false;
              } else {
                $target.attr('tabindex','-1'); // Adding tabindex for elements not focusable
                $target.focus(); // Set focus again
              };
            });
          }
        }
      });
  }

  // setupSticky() {
  // const image = $('#leo_contour');
  // const house = $('#house');
	// const top = image.offset().top;
	// const width = image.width();
	// const height = image.height();
	// const bottom = house.offset().top + house.height();
	// const windowHeight = $(window).height();
	// const offset = (windowHeight - height) / 2;

	// const setImage = () => {
	// const y =  $(window).scrollTop() + offset;
	// if (y > top && y + height < bottom) {
	// image
	// .removeClass('absolute')
	// .css('bottom', '')
	// .addClass('fixed')
	// .css('top', offset)
	// .width(width)
	// .height(height);
	// }
	// else if (y + height >= bottom) {
  // image
  // .addClass('absolute')
  // .removeClass('fixed')
  // .css('top', '')
  // .css('bottom', 0)
  // .width(width)
  // .height(height);
  // }
	// else {
	// image
	// .removeClass('fixed')
	// .removeClass('absolute')
	// .css('top', '')
	// .css('bottom', '')
	// .width('')
	// .height('');
	// }
	// }

	// $(document).on('scroll', setImage);
	// setImage();
  // }
}
