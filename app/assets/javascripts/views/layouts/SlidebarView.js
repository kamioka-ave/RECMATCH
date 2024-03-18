// @flow
import JQueryView, { on } from '../common/JQueryView';

export default class SlidebarView extends JQueryView {
  $site: any;
  $left: any;
  $controls: any;
  $slide: any;
  animation: string;
  active = false;
  init = false;
  windowWidth: number;

  siteClose = true; // true or false - Enable closing of Slidebars by clicking on #sb-site.
  scrollLock = false; // true or false - Prevent scrolling of site when a Slidebar is open.
  disableOver = false; // integer or false - Hide Slidebars over a specific width.
  hideControlClasses = false; // true or false - Hide controls at same width as disableOver.

  constructor() {
    super('#sb-site');

    const test = document.createElement('div').style; // Create element to test on.
    let supportTransition = false; // Variable for testing transitions.
    let supportTransform = false; // variable for testing transforms.

    // Test for CSS Transitions
    if (
      test.MozTransition === '' ||
      test.WebkitTransition === '' ||
      test.OTransition === '' ||
      test.transition === ''
    ) {
      supportTransition = true;
    }

    // Test for CSS Transforms
    if (
      test.MozTransform === '' ||
      test.WebkitTransform === '' ||
      test.OTransform === '' ||
      test.transform === ''
    ) {
      supportTransform = true;
    }

    const ua = navigator.userAgent; // Get user agent string.
    let android = false; // Variable for storing android version.
    let iOS = false; // Variable for storing iOS version.

    if (/Android/.test(ua)) {
      // Detect Android in user agent string.
      android = ua.substr(ua.indexOf('Android') + 8, 3); // Set version of Android.
    } else if (/(iPhone|iPod|iPad)/.test(ua)) {
      // Detect iOS in user agent string.
      iOS = ua.substr(ua.indexOf('OS ') + 3, 3).replace('_', '.'); // Set version of iOS.
    }

    // Add helper class for older versions of Android & iOS.
    if ((android && android < 3) || (iOS && iOS < 5)) {
      $('html').addClass('sb-static');
    }

    // Site container
    this.$site = $('#sb-site, .sb-site-container'); // Cache the selector.
    this.$left = $('.sb-left');

    this.windowWidth = $(window).width(); // Get width of window.
    this.$controls = $(
      '.sb-toggle-left, .sb-open-left, .sb-close',
    ); // Cache the control classes.
    this.$slide = $('.sb-slide'); // Cache users elements to animate.

    // Initailise Slidebars
    this.initialize();

    // Resize Functions
    $(window).resize(() => {
      const resizedWindowWidth = $(window).width(); // Get resized window width.
      if (this.windowWidth !== resizedWindowWidth) {
        // Slidebars is running and window was actually resized.
        this.windowWidth = resizedWindowWidth; // Set the new window width.
        this.initialize(); // Call initalise to see if Slidebars should still be running.

        // If left Slidebar is open, calling open will ensure it is the correct size.
        if (this.active) {
          open();
        }
      }
    });

    // Set animation type.
    if (supportTransition && supportTransform) {
      // Browser supports css transitions and transforms.
      this.animation = 'translate'; // Translate for browsers that support it.
      // Android supports both, but can't translate any fixed positions, so use left instead.
      if (android && android < 4.4) {
        this.animation = 'side';
      }
    } else {
      this.animation = 'jQuery'; // Browsers that don't support css transitions and transitions.
    }
  }

  initialize() {
    if (
      !this.disableOver ||
      (typeof this.disableOver === 'number' &&
        this.disableOver >= this.windowWidth)
    ) {
      // False or larger than window size.
      this.init = true; // true enabled Slidebars to open.
      $('html').addClass('sb-init'); // Add helper class.
      // Remove class just incase Slidebars was originally disabled.
      if (this.hideControlClasses) {
        this.removeClass('sb-hide');
      }
      this.css(); // Set required inline styles.
    } else if (
      typeof this.disableOver === 'number' &&
      this.disableOver < this.windowWidth
    ) {
      // Less than window size.
      this.init = false; // false stop Slidebars from opening.
      $('html').removeClass('sb-init'); // Remove helper class.

      // Hide controls
      if (this.hideControlClasses) {
        this.$controls.addClass('sb-hide');
      }
      this.$site.css('minHeight', ''); // Remove minimum height.

      // Close Slidebars if open.
      if (this.active) {
        this.close();
      }
    }
  }

  // Inline CSS
  css() {
    // Site container height.
    this.$site.css('minHeight', '');
    const siteHeight = parseInt(this.$site.css('height'), 10);
    const htmlHeight = parseInt($('html').css('height'), 10);

    if (siteHeight < htmlHeight) {
      this.$site.css('minHeight', $('html').css('height')); // Test height for vh support..
    }

    // Custom Slidebar widths.
    if (this.$left && this.$left.hasClass('sb-width-custom')) {
      this.$left.css('width', this.$left.attr('data-sb-width')); // Set user custom width.
    }

    // Set off-canvas margins for Slidebars with push and overlay animations.
    if (
      this.$left &&
      (this.$left.hasClass('sb-style-push') ||
        this.$left.hasClass('sb-style-overlay'))
    ) {
      this.$left.css('marginLeft', '-' + this.$left.css('width'));
    }

    // Site scroll locking.
    if (this.scrollLock) {
      $('html').addClass('sb-scroll-lock');
    }
  }

  // Animate mixin.
  animate(object: any, amount: any, side: any) {
    // Choose selectors depending on animation style.
    let selector;

    if (object.hasClass('sb-style-push')) {
      selector = this.$site.add(object).add(this.$slide); // Push - Animate site, Slidebar and user elements.
    } else if (object.hasClass('sb-style-overlay')) {
      selector = object; // Overlay - Animate Slidebar only.
    } else {
      selector = this.$site.add(this.$slide); // Reveal - Animate site and user elements.
    }

    // Apply animation
    if (this.animation === 'translate') {
      if (amount === '0px') {
        selector.removeAttr('style');
        this.css();
      } else {
        selector.css('transform', 'translate( ' + amount + ' )'); // Apply the animation.
      }
    } else if (this.animation === 'side') {
      if (amount === '0px') {
        selector.removeAttr('style');
        this.css();
      } else {
        // Remove the '-' from the passed amount for side animations.
        if (amount[0] === '-') {
          amount = amount.substr(1);
        }
        selector.css(side, '0px'); // Add a 0 value so css transition works.
        setTimeout(() => {
          // Set a timeout to allow the 0 value to be applied above.
          selector.css(side, amount); // Apply the animation.
        }, 1);
      }
    } else if (this.animation === 'jQuery') {
      // Remove the '-' from the passed amount for jQuery animations.
      if (amount[0] === '-') {
        amount = amount.substr(1);
      }
      let properties = {};
      properties[side] = amount;
      selector.stop().animate(properties, 400); // Stop any current jQuery animation before starting another.
    }
  }

  // Toggle either Slidebar
  toggle() {
    if (this.$left) {
      // If left Slidebar is called and in use.
      if (!this.active) {
        this.open(); // Slidebar is closed, open it.
      } else {
        this.close(); // Slidebar is open, close it.
      }
    }
  }

  // Open a Slidebar
  open() {
    // Check to see if opposite Slidebar is open.
    if (this.$left && this.active) {
      // It's open, close it, then continue.
      this.close();
      setTimeout(this.proceed(), 400);
    } else {
      // Its not open, continue.
      this.proceed();
    }
  }

  // Open
  proceed() {
    if (this.init && this.$left) {
      // Slidebars is initiated, left is in use and called to open.
      $('html').addClass('sb-active sb-active-left'); // Add active classes.
      this.$left.addClass('sb-active');
      this.animate(this.$left, this.$left.css('width'), 'left'); // Animation
      setTimeout(() => {
        this.active = true;
      }, 400); // Set active variables.
    }
  }

  // Close either Slidebar
  close(url: string, target: any) {
    if (this.active) {
      this.animate(this.$left, '0px', 'left'); // Animation
      this.active = false;

      setTimeout(() => {
        // Wait for closing animation to finish.
        $('html').removeClass('sb-active sb-active-left sb-active-right'); // Remove active classes.
        if (this.$left) {
          this.$left.removeClass('sb-active');
        }
        if (url != null) {
          // If a link has been passed to the function, go to it.
          if (target != null) {
            target = '_self';
          }
          window.open(url, target); // Open the url.
        }
      }, 400);
    }
  }

  eventHandler(event: any, selector: any) {
    event.stopPropagation(); // Stop event bubbling.
    event.preventDefault(); //

    // If event type was touch, turn off clicks to prevent phantom clicks.
    if (event.type === 'touchend') {
      selector.off('click');
    }
  }

  @on('click .sb-toggle-left')
  onClickSbToggleLeft(event: any) {
    this.eventHandler(event, $(event.currentTarget));
    this.toggle();
  }

  @on('touchend .sb-toggle-left')
  onTouchendSbToggleLeft(event: any) {
    this.eventHandler(event, $(event.currentTarget));
    this.toggle();
  }

  @on('click .sb-open-left')
  onClickSbOpenLeft(event: any) {
    this.eventHandler(event, $(event.currentTarget));
    this.open();
  }

  @on('touchend .sb-open-left')
  onTouchendSbOpenLeft(event: any) {
    this.eventHandler(event, $(event.currentTarget));
    this.open();
  }

  @on('click .sb-close')
  onClickSbClose(event: any) {
    if (
      $(event.currentTarget).is('a') ||
      $(event.currentTarget)
        .children()
        .is('a')
    ) {
      // Make sure the user wanted to follow the link.
      event.stopPropagation(); // Stop events propagating
      event.preventDefault(); // Stop default behaviour

      const link = $(event.currentTarget).is('a')
        ? $(event.currentTarget)
        : $(event.currentTarget).find('a'); // Get the link selector.
      const url = link.attr('href'); // Get the link url.
      const target = link.attr('target') ? link.attr('target') : '_self'; // Set target, default to _self if not provided

      // Close Slidebar and pass link target.
      this.close(url, target);
    } else {
      // Just a normal control class.
      this.eventHandler(event, $(event.currentTarget)); // Handle the event.
      this.close();
    }
  }

  @on('touchend .sb-close')
  onTouchendSbClose(event: any) {
    if (
      !$(event.currentTarget).is('a') &&
      !$(event.currentTarget)
        .children()
        .is('a')
    ) {
      // Just a normal control class.
      this.eventHandler(event, $(event.currentTarget)); // Handle the event.
      this.close();
    }
  }
}
