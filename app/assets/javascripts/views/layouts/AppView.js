// @flow
import JQueryView, { on } from '../common/JQueryView';

export default class AppView extends JQueryView {
  constructor() {
    super('#sb-site');
    this.setupToTopButton();

    if (window.devicePixelRatio != null) {
      // window.matchMedia('(-webkit-device-pixel-ratio:1)').addListener(this.updateImages);
      this.updateImages();
    }

    $('.hover-fade').hover(
      function() {
        $(this)
          .stop()
          .fadeTo(200, 0.6);
      },
      function() {
        $(this)
          .stop()
          .fadeTo('fast', 1.0);
      },
    );

    //Submenu
    $('body').on('click', '.sub-menu > a', function(e) {
      e.preventDefault();
      $(this)
        .next()
        .slideToggle(200);
      $(this)
        .parent()
        .toggleClass('toggled');
    });
  }

  setupToTopButton() {
    const $topBtn = $('#pageTop');
    $topBtn.hide();

    //◇ボタンの表示設定
    $(window).scroll(event => {
      if ($(event.currentTarget).scrollTop() > 80) {
        //---- 画面を80pxスクロールしたら、ボタンを表示する
        $topBtn.fadeIn();
      } else {
        //---- 画面が80pxより上なら、ボタンを表示しない
        $topBtn.fadeOut();
      }
    });

    // ◇ボタンをクリックしたら、スクロールして上に戻る
    $topBtn.click(() => {
      $('body,html').animate({ scrollTop: 0 }, 500);
      return false;
    });
  }

  updateImages() {
    const images = document.getElementsByTagName('img');

    for (let counter = 0; counter < images.length; counter++) {
      if (!images[counter].getAttribute('data-lazy-load')) {
        this.refreshImage(images[counter]);
      }
    }
  }

  refreshImage(image: any) {
    const lazyLoad = image.getAttribute('data-lazy-load');
    const imageSrc = image.src;
    const hiDpiSrc = image.getAttribute('data-hidpi-src');
    const lowDpiSrc = image.getAttribute('data-lowdpi-src');

    if (!hiDpiSrc) {
      return;
    }

    if (lazyLoad) {
      image.removeAttribute('data-lazy-load');
    }

    if (window.devicePixelRatio > 1 && imageSrc != hiDpiSrc) {
      if (!lowDpiSrc) {
        image.setAttribute('data-lowdpi-src', imageSrc);
      }
      image.src = hiDpiSrc;
    } else if (
      (!window.devicePixelRatio || window.devicePixelRatio <= 1) &&
      (imageSrc == hiDpiSrc || (lowDpiSrc && imageSrc != lowDpiSrc))
    ) {
      image.src = lowDpiSrc;
    }
  }

  @on('click .totop')
  onClickToTop() {
    $('body, html').animate({ scrollTop: 0 }, 500);
  }
}
