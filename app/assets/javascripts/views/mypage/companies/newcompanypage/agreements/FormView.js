// @flow
import JQueryView, { on } from '../../../../common/JQueryView';
import swal from 'sweetalert';

export default class FormView extends JQueryView {
  isClauseOpened: boolean;
  isReviewOpened: boolean;

  constructor(isClauseOpened: boolean, isReviewOpened: boolean) {
    super('.simple_form');
    this.isClauseOpened = isClauseOpened;
    this.isReviewOpened = isReviewOpened;
  }

  @on('click #agree_with_clause')
  onClickClause() {
    this.isClauseOpened = true;
  }

  @on('click #agree_with_pre_judge')
  onClickReview() {
    this.isReviewOpened = true;
  }

  @on('click input[name="commit"]')
  onSubmit() {
    if (!this.isClauseOpened) {
      swal({
        title: '利用規約の内容をご確認ください',
        confirmButtonColor: '#2196F3',
        animation: false,
      });
      return false;
    } else if (!this.isClauseOpened) {
      swal({
        title: '利用規約の内容をご確認ください',
        confirmButtonColor: '#2196F3',
        animation: false,
      });
      return false;
    } else {
      return true;
    }
  }
}
