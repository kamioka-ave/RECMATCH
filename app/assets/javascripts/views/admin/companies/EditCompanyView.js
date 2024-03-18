// @flow
import JQueryView, { on } from '../../common/JQueryView';
import SummernoteClient from '../../../models/summernotes/SummernoteClient';

declare var $: any;

export default class EditCompanyView extends JQueryView {
  image: any;
  summernoteClient = new SummernoteClient();

  constructor(image: ?string) {
    super('.simple_form');
    this.image = image;

    $('.form_date').datetimepicker({
      locale: 'ja',
      format: 'YYYY/MM/DD',
      sideBySide: true,
    });

    $('.form_datetime').datetimepicker({
      locale: 'ja',
      format: 'YYYY/MM/DD HH:mm',
      sideBySide: true,
    });

    this.setUpSummernote('#company_business_summary');
    this.setUpSummernote('#company_hope');
    this.setUpSummernote('#company_business_shebang');
    this.setUpSummernote('#company_competitive_strength');
    this.setUpSummernote('#company_ceo_hopes');
    this.render();
  }

  @on('change #company_image')
  onChangeCompanyImage(event: any) {
    if (!event.target.files.length) {
      return;
    }

    const file = $(event.target).prop('files')[0];
    const fr = new FileReader();
    fr.onload = () => {
      this.image = fr.result;
      this.render();
    };
    fr.readAsDataURL(file);
  }

  setUpSummernote(field: string) {
    const note = $(field).summernote({
      height: 300,
      lang: 'ja-JP',
      callbacks: {
        onImageUpload: files => {
          this.summernoteClient
            .create(files[0])
            .then(response => note.summernote('insertImage', response.data.url))
            .catch(error => alert(error));
        },
      },
    });
  }

  render() {
    if (this.image != null && this.image !== '') {
      $('#preview_image')
        .css('background-image', `url(${this.image})`)
        .show();
    }
  }
}
