// @flow
import JQueryView, { on } from '../../common/JQueryView';
import SummernoteClient from '../../../models/summernotes/SummernoteClient';

declare var $: any;

export default class FormView extends JQueryView {
  summernoteClient = new SummernoteClient();

  constructor() {
    super('.simple_form');
    this.setUpAsking();
    this.setUpAnswer();
  }

  setUpAsking() {
    const body = $('#question_draft_asking').summernote({
      height: 240,
      lang: 'ja-JP',
      callbacks: {
        onImageUpload: files => {
          this.summernoteClient
            .create(files[0])
            .then(response => {
              body.summernote('insertImage', response.data.url);
            })
            .catch(error => {
              alert(error);
            });
        },
      },
    });
  }

  setUpAnswer() {
    const body = $('#question_draft_answer').summernote({
      height: 480,
      lang: 'ja-JP',
      callbacks: {
        onImageUpload: files => {
          this.summernoteClient
            .create(files[0])
            .then(response => {
              body.summernote('insertImage', response.data.url);
            })
            .catch(error => {
              alert(error);
            });
        },
      },
    });
  }

  @on('click .remove_fields')
  onClickRemoveFields(event: any) {
    $(event.target)
      .prev('input[type=hidden]')
      .val('1');
    $(event.target)
      .closest('fieldset')
      .hide();
    event.preventDefault();
  }

  @on('click .add_fields')
  onClickAddFields(event: any) {
    const time = new Date().getTime();
    const regexp = new RegExp($(event.target).data('id'), 'g');
    $(event.target).before(
      $(event.target)
        .data('fields')
        .replace(regexp, time),
    );
    event.preventDefault();
  }
}
