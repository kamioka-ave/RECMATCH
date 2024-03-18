// @flow
import JQueryView, { on } from '../../common/JQueryView';

export default class FormView extends JQueryView {
  constructor() {
    super('.simple_form');
  }

  @on('change #display_password')
  onChangeDisplayPassword() {
    const displayPassword = $('#display_password')
      .filter(':checked')
      .val();
    $('#user_password').attr({
      type: displayPassword != null ? 'text' : 'password',
    });
  }
}
