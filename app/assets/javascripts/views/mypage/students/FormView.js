// @flow
import JQueryView, { on } from '../../common/JQueryView';

declare var $: any;

export default class FormView extends JQueryView {
  constructor() {
    super('#mypage_student_form_view');

    $('#student_zip_code').jpostal({
      postcode: ['#student_zip_code'],
      address: {
        '#student_prefecture_id': '%3',
        '#student_city': '%4',
      },
    });

    $('#student_birth_on_1i').after('<span class="ml-5 mr-10">年</span>');
    $('#student_birth_on_2i').after('<span class="ml-5 mr-10">月</span>');
    $('#student_birth_on_3i').after('<span class="ml-5 mr-10">日</span>');

    this.render();
  }

  @on('change #student_job')
  onChangeJob() {
    this.render();
  }

  @on('change #student_business')
  onChangeBusiness() {
    this.render();
  }

  @on('keyup #student_first_name_kana')
  onKeyupFirstNameKana() {
    $('#student_bank_account_name').val(
      $('#student_last_name_kana').val() +
        $('#student_first_name_kana').val(),
    );
  }

  @on('keyup #student_last_name_kana')
  onKeyupLastNameKana() {
    $('#student_bank_account_name').val(
      $('#student_last_name_kana').val() +
        $('#student_first_name_kana').val(),
    );
  }

  render() {
    if ($('#student_job').val() === '17') {
      $('.student_job_details').show();
    } else {
      $('.student_job_details').hide();
    }

    if ($('#student_job').val() === '22' || $('#student_job').val() === '23' || $('#student_job').val() === '24') {//主婦・学生・退職者の値
      $('.student_business').hide();
    } else {
      $('.student_business').show();
    }

    if ($('#student_business').val() === '9') {//事業がその他の場合
      $('.student_business_details').show();
    } else {
      $('.student_business_details').hide();
    }
  }
}
