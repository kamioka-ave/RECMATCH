// @flow
import JQueryView, { on } from '../common/JQueryView';

declare var $: any;

export default class ShowView extends JQueryView {
  tocItems = [];

  constructor(isMobile: boolean) {
    super('#show');

    if (!isMobile) {
      this.renderToc();
      this.handleToc();
      this.handleAnchor();
    }

    this.loadFacebookSdk();
  }

  @on('click ul.dropdown-menu a[data-remote=true]')
  onClickDropdownMenu(event: any) {
    $(event.target)
      .closest('ul')
      .prev('a')
      .dropdown('toggle');
  }

  @on('click .modal-social__btn.share')
  onClickPopup(event: any) {
    event.preventDefault();
    const intWidth = '500';
    const intHeight = '400';
    const strTitle =
        typeof event.currentTarget.title !== 'undefined'
          ? event.currentTarget.title
          : 'Social Share',
      strParam = `width= ${intWidth} ,height= ${intHeight}`;
    window.open(event.currentTarget.href, strTitle, strParam).focus();
  }

  @on('click .risk_info_link')
  onClickRiskInfo() {
    $('.nav-tabs a[href="#risk_info"]').tab('show');
  }

  @on('show.bs.collapse .collapse')
  onShowCollapse(event: any) {
    // 折り畳み開く処理
    $(event.currentTarget)
      .closest('.tab-content')
      .find('section')
      .removeClass('active');
    $(event.currentTarget)
      .closest('section')
      .addClass('active');
  }

  @on('hide.bs.collapse .collapse')
  onHideCollapse(event: any) {
    // 折り畳み閉じる処理
    $(event.currentTarget)
      .closest('section')
      .removeClass('active');
  }

  @on('shown.bs.collapse .collapse')
  onShownCollapse(event: any) {
    // 折り畳み開いた後
    const position = $(event.currentTarget)
      .closest('section')
      .offset().top;
    $('html,body').animate({ scrollTop: position }, 500);
  }

  @on('click .readmore')
  onClickReadmore(event: any) {
    $(event.currentTarget)
      .hide()
      .parent('.main')
      .removeClass('onhidden');
  }

  @on('click .close_description')
  onClickCloseDescription(event: any) {
    $(event.currentTarget)
      .parent('.main')
      .addClass('onhidden');
    $('.readmore').show();
    const targetTop = $('#description').offset().top;
    $('html,body').animate(
      {
        scrollTop: targetTop - 60,
      },
      500,
    );
  }

  handleAnchor() {
    const url = document.location.toString();
    if (url.match('#')) {
      $('.tab-nav a[href="#' + url.split('#')[1] + '"]').tab('show');
    }
  }

  handleToc() {
    const top = $('.toc-card').offset().top;
    const bottom =
      $('.footer').outerHeight() + $('.disclaimers').outerHeight() + 143;

    $('.toc-card').affix({
      offset: {
        top: top,
        bottom: bottom,
      },
    });

    $('body').scrollspy({
      target: '.toc',
    });

    $(window).on('load', () => {
      $('body').scrollspy('refresh');
    });

    $('a[data-toggle="tab"]').on('shown.bs.tab', (event: any) => {
      if (
        this.tocItems.length > 0 &&
        $(event.target).html() === 'プロジェクト詳細'
      ) {
        $('.toc-card').show();
      } else {
        $('.toc-card').hide();
      }
    });
  }

  renderToc() {
    const selector = '.mokuji';

    $('#description')
      .find(selector)
      .each((i, item) => {
        const trimed = item.dataset.tocTitle
          ? item.dataset.tocTitle.trim()
          : item.textContent.trim();
        const text = trimed.replace('■ ', '').replace('■', '');

        if (text !== '') {
          const index = item.id || `toc-${i}`;
          const sanitizedClassName = selector
            .replace(/((:+[\w-\d]*)|[^A-z0-9-\s])/g, ' ')
            .replace(/\s{2,}/g, ' ')
            .trim();
          const className = `toc-${sanitizedClassName}`;

          if (item.id !== index) {
            item.id = index;
          }

          this.tocItems.push({ index, text, className });
        }
      });

    if (this.tocItems.length > 0) {
      let html =
        '<ul class="nav nav-pills nav-stacked" data-turbolinks="false">';
      const triggerOptions = [];

      this.tocItems.forEach((item, j) => {
        const options = {
          el: `.toc-li-${j}`,
          fixed: 'true',
          start: `#${item.index}`,
          position: 'top',
          positionEnd: 'top',
          className: 'toc-visible',
        };
        html += `\n<li class="toc-li-${j} ${item.className}"><a href="#${
          item.index
        }"><span>${item.text}</span></a></li>`;
        triggerOptions.push(options);
      });

      html += '</ul>';

      $('.toc').html(html);
    } else {
      $('.toc-card').hide();
    }
  }

  loadFacebookSdk() {
    (function(d, s, id) {
      if (d.getElementById(id)) {
        return;
      }

      const fjs: any = d.getElementsByTagName(s)[0];
      let js = d.createElement(s);
      js.id = id;
      js.src = 'https://connect.facebook.net/ja_JP/sdk.js#xfbml=1&version=v3.1';
      fjs.parentNode.insertBefore(js, fjs);
    })(document, 'footer', 'facebook-jssdk');
  }
}
