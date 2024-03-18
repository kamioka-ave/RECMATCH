// @flow
import SummernoteClient from '../../models/summernotes/SummernoteClient';
import JQueryView, { on } from '../common/JQueryView';

declare var $: any;

export default class PdfDialog extends JQueryView {
  summernote: any;
  link: string;
  file: any;
  summernoteClient = new SummernoteClient();

  constructor() {
    super('#pdf_dialog');
    this.render();
  }

  showDialog(id: string) {
    this.summernote = $(id);

    const range = this.summernote.summernote('createRange');
    this.summernote.summernote('saveRange');
    $('#pdf_link').val(range.toString());
    this.link = $('#pdf_link').val();

    $('#pdf_dialog').modal('show');
  }

  @on('keyup #pdf_link')
  onChangePdfLink() {
    this.link = $('#pdf_link').val();
    this.render();
  }

  @on('change #pdf_file')
  onChangeFile() {
    this.file = $('#pdf_file')[0].files[0];
    this.render();
  }

  @on('click #pdf_submit')
  onSubmit(event: any) {
    event.preventDefault();
    this.summernoteClient
      .create(this.file)
      .then(response => {
        $('#pdf_dialog').modal('hide');
        this.summernote.summernote('restoreRange');
        this.summernote.summernote('createLink', {
          text: this.link,
          url: response.data.url,
          isNewWindow: $('#new_window').prop('checked'),
        });
      })
      .catch(error => {
        alert(error);
      });
  }

  render() {
    $('#pdf_submit').prop(
      'disabled',
      !(this.link != null && this.link !== '' && this.file != null),
    );
  }
}
