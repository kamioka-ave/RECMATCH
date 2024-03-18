// @flow
import JQueryView, { on } from '../../common/JQueryView';
import SummernoteClient from '../../../models/summernotes/SummernoteClient';

declare var $: any;

export default class FormView extends JQueryView {
  summernoteClient = new SummernoteClient();

  constructor() {
    super('.simple_form');

    $('.form_datetime').datetimepicker({
      locale: 'ja',
      format: 'YYYY/MM/DD HH:mm',
      sideBySide: true,
    });

    this.setUpBody();
  }

  setUpBody() {
    const body = $('#headline_body').summernote({
      height: 480,
      lang: 'ja-JP',
      callbacks: {
        onImageUpload: files => {
          this.summernoteClient
            .create(files[0])
            .then(response => body.summernote('insertImage', response.data.url))
            .catch(error => alert(error));
        },
      },
    });
  }

  @on('submit')
  onSubmit() {
    if ($('#headline_body').summernote('codeview.isActivated')) {
      $('#headline_body').summernote('codeview.deactivate');
    }
  }
}
