// @flow
import JQueryView, { on } from '../../../common/JQueryView';
import SummernoteClient from '../../../../models/summernotes/SummernoteClient';

declare var $: any;

export default class FormView extends JQueryView {
  summernoteClient = new SummernoteClient();

  constructor() {
    super('#form_view');
    this.setUpSummernote('#company_business_summary');
    this.setUpSummernote('#company_business_philosophy');
    this.setUpSummernote('#company_hope');
    this.setUpSummernote('#company_business_shebang');
    this.setUpSummernote('#company_competitive_strength');
    this.setUpSummernote('#company_competitive_difference');
    this.setUpSummernote('#company_target');
    this.setUpSummernote('#company_ceo_hopes');
    this.render();
  }

  setUpSummernote(field: string) {
    const note = $(field).summernote({
      height: 300,
      lang: 'ja-JP',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['insert', ['link', 'picture', 'video']],
        ['view', ['fullscreen', 'help']],
      ],
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
    let time = new Date().getTime();
    let regexp = new RegExp($(event.target).data('id'), 'g');
    $(event.target).before(
      $(event.target)
        .data('fields')
        .replace(regexp, time),
    );
    event.preventDefault();
  }

  @on('change input[name="company[how_to_exit]"]:radio')
  onChangeHowToExit() {
    this.render();
  }

  @on('change input[name="company[capital_ties]"]:radio')
  onChangeCapitalTies() {
    this.render();
  }

  render() {
    if (
      $('input[name="company[how_to_exit]"]')
        .filter(':checked')
        .val() === '2'
    ) {
      $('.company_how_to_exit_others').show();
    } else {
      $('.company_how_to_exit_others').hide();
    }

    if (
      $('input[name="company[capital_ties]"]')
        .filter(':checked')
        .val() === '1'
    ) {
      $('.company_capital_ties_note').show();
    } else {
      $('.company_capital_ties_note').hide();
    }
  }
}
