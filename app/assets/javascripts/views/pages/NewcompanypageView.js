// @flow
import JQueryView, { on } from '../common/JQueryView';
import swal from 'sweetalert';

export default class NewcompanypageView extends JQueryView {
  constructor() {
    super('#funding_view');
  }

  @on('click .submit')
  onClickSubmit() {
    swal({
      title: '企業登録が完了しないとお申込みできません',
      confirmButtonColor: '#2196F3',
      animation: false,
    });
  }
}
