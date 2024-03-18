// @flow
import JQueryView, { on } from '../../common/JQueryView';
import fitty from 'fitty';

export default class AssetsStatView extends JQueryView {
  constructor() {
    super('#assets_stat');
    fitty.observeWindow = false;
    fitty('.money span', {
      maxSize: 43,
    });
  }

  @on('fit .money span')
  onFitMoneySpan() {
    let minFontSize = $('.money span').get(0).style['font-size'];

    $('.money span')
      .each((_, e) => {
        if (e.style['font-size'] < minFontSize) {
          minFontSize = e.style['font-size'];
        }
      })
      .css('font-size', minFontSize);
  }
}
