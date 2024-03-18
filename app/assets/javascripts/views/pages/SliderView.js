// @flow
import JQueryView from '../common/JQueryView';

export default class SliderView extends JQueryView {
  slidesWrapper: any;
  primaryNav: any;
  sliderNav: any;
  navigationMarker: any;
  slidesNumber: number;
  autoPlayDelay: number;
  autoPlayId: any;
  autoPlayDelay = 5000;
  visibleSlidePosition = 0;

  constructor() {
    super('.cd-hero');
    this.slidesWrapper = $('.cd-hero-slider');
    this.primaryNav = $('.cd-primary-nav');
    this.sliderNav = $('.cd-slider-nav');
    this.navigationMarker = $('.cd-marker');
    this.slidesNumber = this.slidesWrapper.children('li').length;

    $.fn.removeClassPrefix = function(prefix) {
      //remove all classes starting with 'prefix'
      this.each(function(i, el) {
        var classes = el.className.split(' ').filter(function(c) {
          return c.lastIndexOf(prefix, 0) !== 0;
        });
        el.className = $.trim(classes.join(' '));
      });
      return this;
    };

    this.render();
  }

  nextSlide(n: number) {
    const visibleSlide = this.slidesWrapper.find('.selected');

    visibleSlide
      .removeClass('selected from-left from-right')
      .addClass('is-moving')
      .one(
        'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend',
        () => {
          visibleSlide.removeClass('is-moving');
        },
      );

    this.slidesWrapper
      .children('li')
      .eq(n)
      .addClass('selected from-right')
      .prevAll()
      .addClass('move-left');
  }

  prevSlide(n: number) {
    const visibleSlide = this.slidesWrapper.find('.selected');

    visibleSlide
      .removeClass('selected from-left from-right')
      .addClass('is-moving')
      .one(
        'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend',
        () => {
          visibleSlide.removeClass('is-moving');
        },
      );

    this.slidesWrapper
      .children('li')
      .eq(n)
      .addClass('selected from-left')
      .removeClass('move-left')
      .nextAll()
      .removeClass('move-left');
  }

  updateSliderNavigation(n: number) {
    const navigationDot = this.sliderNav.find('.selected');
    navigationDot.removeClass('selected');
    this.sliderNav
      .find('li')
      .eq(n)
      .addClass('selected');
  }

  setAutoplay() {
    if (this.slidesWrapper.hasClass('autoplay')) {
      clearInterval(this.autoPlayId);
      this.autoPlayId = window.setInterval(() => {
        this.autoplaySlider(this.slidesNumber);
      }, this.autoPlayDelay);
    }
  }

  autoplaySlider(length: number) {
    if (this.visibleSlidePosition < length - 1) {
      this.nextSlide(this.visibleSlidePosition + 1);
      this.visibleSlidePosition += 1;
    } else {
      this.prevSlide(0);
      this.visibleSlidePosition = 0;
    }
    this.updateNavigationMarker(this.visibleSlidePosition + 1);
    this.updateSliderNavigation(this.visibleSlidePosition);
  }

  updateNavigationMarker(n: number) {
    this.navigationMarker.removeClassPrefix('item').addClass('item-' + n);
  }

  render() {
    //autoplay slider
    this.setAutoplay();

    //on mobile - open/close primary navigation clicking/tapping the menu icon
    this.primaryNav.on('click', event => {
      if ($(event.target).is('.cd-primary-nav')) {
        $(event.target)
          .children('ul')
          .toggleClass('is-visible');
      }
    });

    //change visible slide
    this.sliderNav.on('click', 'li', event => {
      event.preventDefault();
      const selectedItem = $(event.currentTarget);
      if (!selectedItem.hasClass('selected')) {
        // if it's not already selected
        const selectedPosition = selectedItem.index();
        const activePosition = this.slidesWrapper.find('li.selected').index();

        if (activePosition < selectedPosition) {
          this.nextSlide(selectedPosition);
        } else {
          this.prevSlide(selectedPosition);
        }

        //this is used for the autoplay
        this.visibleSlidePosition = selectedPosition;

        this.updateSliderNavigation(selectedPosition);
        this.updateNavigationMarker(selectedPosition + 1);
        //reset autoplay
        this.setAutoplay();
      }
    });
    $(document).ready(function() {

    	  var curPage = 1;
    	  var numOfPages = $(".skw-page").length;
    	  var animTime = 1000;
    	  var scrolling = false;
    	  var pgPrefix = ".skw-page-";

    	  function pagination() {
    	    scrolling = true;

    	    $(pgPrefix + curPage).removeClass("inactive").addClass("active");
    	    $(pgPrefix + (curPage - 1)).addClass("inactive");
    	    $(pgPrefix + (curPage + 1)).removeClass("active");

    	    setTimeout(function() {
    	      scrolling = false;
    	    }, animTime);
    	  };
    	  function paginationBack() {
    	    scrolling = true;

    	    for(var i =1; i < numOfPages; i++){
    	      $(pgPrefix + i).removeClass("active");
    	      $(pgPrefix + i).removeClass("inactive");
    	    }
    	    $(pgPrefix + numOfPages).removeClass("active");
    	    $(pgPrefix + curPage).addClass("active");
    	  };

    	  var countCheck = function countCheck() {
    	    if (curPage === numOfPages){
    	      curPage = 1;
    	      paginationBack();
    	      return;
    	    }
    	    navigateDown()
    	  }
    	  function navigateUp() {
    	    if (curPage === 1) return;
    	    curPage--;
    	    pagination();
    	  };

    	  function navigateDown() {
    	    if (curPage === numOfPages) return;
    	    curPage++;
    	    pagination();
    	  };

    	  setInterval(countCheck, 4000);

    	});
  }
}
