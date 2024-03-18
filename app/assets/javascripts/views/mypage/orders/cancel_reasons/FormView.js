// @flow
import JQueryView, { on } from '../../../common/JQueryView';

export default class FormView extends JQueryView {
  others: boolean;

  constructor(others: boolean) {
    super('.simple_form');
    this.others = others;
    this.render();
  }

  @on('change #cancel_reason_cancel_reason_question_ids_6')
  onChangeOthers6() {
    this.others = $('#cancel_reason_cancel_reason_question_ids_6').prop(
      'checked',
    );
    this.render();
  }

  render() {
    if (this.others) {
      $('#cancel_reason_note').show();
    } else {
      $('#cancel_reason_note').hide();
    }
  }
}
