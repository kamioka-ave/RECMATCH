// @flow
import JQueryView, { on } from '../../common/JQueryView';

export default class FormView extends JQueryView {
  others: boolean;

  constructor(others: boolean) {
    super('.simple_form');
    this.others = others;
    this.render();
  }

  @on('change #quit_quit_reason_ids_4')
  onChangeOthers4() {
    this.others = $('#quit_quit_reason_ids_4').prop('checked');
    this.render();
  }

  @on('change #quit_quit_reason_ids_9')
  onChangeOthers9() {
    this.others = $('#quit_quit_reason_ids_9').prop('checked');
    this.render();
  }

  render() {
    if (this.others) {
      $('#quit_note').show();
    } else {
      $('#quit_note').hide();
    }
  }
}
