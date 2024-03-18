// @flow
import JQueryView, { on } from '../../../common/JQueryView';

declare var $: any;

export default class FormView extends JQueryView {
  image: any;

  constructor(image: string) {
    super('#form_view');

    $('.form_date').datetimepicker({
      locale: 'ja',
      format: 'YYYY/MM/DD',
      sideBySide: true,
    });

    $('#company_zip_code').jpostal({
      postcode: ['#company_zip_code'],
      address: {
        '#company_prefecture_id': '%3',
        '#company_city': '%4',
      },
    });

    this.image = image;
    this.render();
  }

  @on('change #company_image')
  onChangeImage(event: any) {
    if (event.target.files.length > 0) {
      const fr = new FileReader();

      fr.onload = () => {
        this.image = fr.result;
        this.render();
      };
      fr.readAsDataURL($(event.target).prop('files')[0]);
    }
  }

  render() {
    if (this.image !== '') {
      $('#preview_image')
        .css('background-image', `url(${this.image})`)
        .show();
    }
  }
}
