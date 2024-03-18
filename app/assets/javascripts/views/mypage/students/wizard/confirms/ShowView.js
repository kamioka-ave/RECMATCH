// @flow
import JQueryView from '../../../../common/JQueryView';
import swal from 'sweetalert';

export default class FormView extends JQueryView {
  constructor(displayConfirmationAlert: boolean) {
    super('.my-students-wizard');

    if (displayConfirmationAlert) {
      swal({
        title:
          'メールアドレスの確認が完了しておりません。画面上部のメッセージを確認してください。',
        confirmButtonColor: '#2196F3',
        animation: false,
      });
    }
  }
}
