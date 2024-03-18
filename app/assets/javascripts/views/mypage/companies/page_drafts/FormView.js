// @flow
import JQueryView, { on } from '../../common/JQueryView';
import SummernoteClient from '../../../models/summernotes/SummernoteClient';

declare var $: any;
declare var CodeMirror: any;

export default class FormView extends JQueryView {
  summernoteClient = new SummernoteClient();
  pageType: number;

  constructor(pageType: number) {
    super('.simple_form');
    this.pageType = pageType;

    CodeMirror.fromTextArea(document.getElementById('page_draft_head'), {
      mode: 'htmlmixed',
      lineNumbers: true,
      indentUnit: 2,
    });

    this.setUpBody();
    this.render();
  }

  setUpBody() {
    const body = $('#page_draft_body').summernote({
      height: 600,
      lang: 'ja-JP',
      codemirror: {
        theme: 'default',
      },
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

  deactivateCodeview() {
    if ($('#page_draft_body').summernote('codeview.isActivated')) {
      $('#page_draft_body').summernote('codeview.deactivate');
    }
  }

  @on('submit')
  onSubmit() {
    this.deactivateCodeview();
  }

  @on('click #preview')
  onClickPreview(event: any) {
    event.preventDefault();
    this.deactivateCodeview();

    const $target = $(event.target);
    const $form = $target.closest('form');

    $form.find('textarea').each((index, node) => {
      const $node = $(node);
      return $node.text($node.val());
    });

    let $previewForm = $form
      .clone()
      .hide()
      .attr({
        action: $target.attr('href'),
        target: '_blank',
      });

    $previewForm.find('[name=_method]').val('post');
    $previewForm.find('input[name="submit"]').remove();
    $('body').append($previewForm);
    $('head').append($previewForm);
    $previewForm.submit();
    $previewForm.remove();
    $previewForm = null;
  }

  @on('change input[name="page_draft[page_type]"]:radio')
  onChangePageType() {
    this.render();
  }

  render() {
    this.pageType = parseInt(
      $('input[name="page_draft[page_type]"]')
        .filter(':checked')
        .val(),
    );

    if (this.pageType === 0) {
      $('.page_draft_title').show();
      $('.page_draft_description').show();
      $('.page_draft_keywords').show();
      $('.page_draft_body').show();
      $('.page_draft_head').hide();
    } else {
      $('.page_draft_title').hide();
      $('.page_draft_description').hide();
      $('.page_draft_keywords').hide();
      $('.page_draft_body').hide();
      $('.page_draft_head').show();
    }
  }
}
