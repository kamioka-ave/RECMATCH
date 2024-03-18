// @flow
import JQueryView, { on } from '../../../common/JQueryView';
import SummernoteClient from '../../../../models/summernotes/SummernoteClient';

declare var $: any;

export default class FormView extends JQueryView {
  image: any;
  presidentImage: any;
  movie: string;
  stamp: any;
  summernoteClient = new SummernoteClient();

  constructor(
    image: string,
    presidentImage: string,
    movie: string,
    stamp: string,
  ) {
    super('.simple_form');

    this.image = image;
    this.presidentImage = presidentImage;
    this.movie = movie;
    this.stamp = stamp;

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

    this.setUpDescription();
    this.render();
    this.setPlaceholder();
  }

  buildPdfButton(id: string, summernote: any) {
    const button = $.summernote.ui.button({
      contents: '<i class="fa fa-file-pdf-o" style="padding-top: 4px"/>',
      tooltip: 'PDFリンクを貼り付け',
      click: () => {
        // $FlowFixMe
      },
    });
    return button.render();
  }

  setUpDescription() {
    const note = $('#event_description').summernote({
      height: 400,
      lang: 'ja-JP',
      callbacks: {
        onImageUpload: files => {
          this.summernoteClient
            .create(files[0])
            .then(response => {
              note.summernote('insertImage', response.data.url);
            })
            .catch(error => {
              alert(error);
            });
        },
      },
    });
  }

  @on('change #event_image')
  onChangeImage(event: any) {
    if (
      event.target instanceof HTMLInputElement &&
      event.target.files.length > 0
    ) {
      const fr = new FileReader();

      fr.onload = () => {
        this.image = fr.result;
        this.render();
      };
      fr.readAsDataURL($(event.target).prop('files')[0]);
    }
  }

  @on('submit')
  onSubmit() {
    if (
      $('#event_description').summernote('codeview.isActivated')) {
      $('#event_description').summernote('codeview.deactivate');
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
