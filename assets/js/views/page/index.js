import MainView from '../main';
import {track} from '../../helpers/mixpanel';

module.exports = class View extends MainView {

  constructor() {
    super();
    this.techHandToggled = false;
    this.techImg = null;
    this.techImgTimeout = null;
    this.techImgs = ['elec1', 'elec3', 'elec4'];
    this.switchTechImg = this.switchTechImg.bind(this);
    this.selectTechImg = this.selectTechImg.bind(this);
    this.stopTechImgAutoSwitch = this.stopTechImgAutoSwitch.bind(this);
  }

  mount() {
    super.mount();
    this.trackPage();
    this.switchTechImg();
    $('[data-action=change-tech-image]').click(this.selectTechImg);
    $('[data-role=tech-img]').click(this.stopTechImgAutoSwitch);
    setTimeout(this.loadLazyImages);
  }

  unmount() {
    super.unmount();
  }

  trackPage() {
    track("VISIT_INDEX")
  }

  loadLazyImages() {
    $("img[data-src]").each(function() {
      const t = $(this);
      t.attr("src", t.data('src'));
      t.removeAttr("data-src");
    });
  }

  switchTechImg() {
    const currentIndex = this.techImgs.indexOf(this.techImg);
    const nextIndex = (currentIndex + 1) % 3
    const next = this.techImgs[nextIndex]
    this.setTechImg(next);
    if (this.techHandToggled == false) {
      this.techImgTimeout = setTimeout(this.switchTechImg, 3000);
    }
  }

  selectTechImg(e) {
    const target = e.target;
    const targetAttr = target.getAttribute('data-target');
    this.techHandToggled = true;
    this.stopTechImgAutoSwitch();
    this.setTechImg(targetAttr);
  }

  setTechImg(techImg) {
    const button = $("[data-target='" + techImg + "']");
    const images = $("[data-role=tech-img]");
    const image = $("[data-value='" + techImg + "']");

    this.techImg = techImg;
    $(button).siblings().removeClass('active');
    $(button).addClass('active');
    images.hide();
    image.show();
  }

  stopTechImgAutoSwitch() {
    !!this.techImgTimeout && clearTimeout(this.techImgTimeout);
  }
}
