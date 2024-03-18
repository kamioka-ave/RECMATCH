// @flow
import JQueryView, { on } from '../../common/JQueryView';
import SummernoteClient from '../../../models/summernotes/SummernoteClient';

declare var $: any;

export default class FormView extends JQueryView {
  image: any;
  presidentImage: any;
  movie: string;
  stamp: any;
  summernoteClient = new SummernoteClient();

  constructor(
    image: string,
    presidentImage: string,
    movie: string,
    stamp: string,
  ) {
    super('.simple_form');

    this.image = image;
    this.presidentImage = presidentImage;
    this.movie = movie;
    this.stamp = stamp;

    $('.form_date').datetimepicker({
      locale: 'ja',
      format: 'YYYY/MM/DD',
      sideBySide: true,
    });

    $('.form_datetime').datetimepicker({
      locale: 'ja',
      format: 'YYYY/MM/DD HH:mm',
      sideBySide: true,
    });

    this.setUpSalary();
    this.setUpProcessSelection();
    this.setUpSelectionCondition();
    this.setUpStudentAssumption();
    this.setUpRecruitKind();
    this.setUpDutyStation();
    this.setUpNewSalary();
    this.setUpAllowance();
    this.setUpRaiseSalary();
    this.setUpReward();
    this.setUpHoliday();
    this.setUpInsurance();
    this.setUpWelfareProgram();
    this.setUpCompanyEvent();
    this.setUpTrialPeriod();
    this.setUpOthereWelfare();
    this.setUpTraining();
    this.setUpVacation();
    this.setUpChildcare();
    this.render();
    this.setPlaceholder();
  }

  buildPdfButton(id: string, summernote: any) {
    const button = $.summernote.ui.button({
      contents: '<i class="fa fa-file-pdf-o" style="padding-top: 4px"/>',
      tooltip: 'PDFリンクを貼り付け',
      click: () => {
        // $FlowFixMe
      },
    });
    return button.render();
  }

  setUpSalary() {
    const note = $('#project_draft_salary').summernote({
      height: 200,
      lang: 'ja-JP',
      placeholder: '例',
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

  setUpProcessSelection() {
    const note = $('#project_draft_process_selection').summernote({
      height: 280,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['insert', ['link', 'picture', 'video', 'pdf']],
        ['view', ['fullscreen', 'codeview', 'help']],
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

  setUpSelectionCondition() {
    const note = $('#project_draft_selection_condition').summernote({
      height: 200,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['insert', ['link', 'picture', 'video', 'pdf']],
        ['view', ['fullscreen', 'codeview', 'help']],
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

  setUpStudentAssumption() {
    const note = $('#project_draft_student_assumption').summernote({
      height: 480,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['insert', ['link', 'picture', 'video', 'pdf']],
        ['view', ['fullscreen', 'codeview', 'help']],
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

  setUpRecruitKind() {
    const note = $('#project_draft_recruit_kind').summernote({
      height: 200,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['insert', ['link', 'picture', 'video', 'pdf']],
        ['view', ['fullscreen', 'codeview', 'help']],
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

  setUpDutyStation() {
    const note = $('#project_draft_duty_station').summernote({
      height: 200,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['insert', ['link', 'picture', 'video', 'pdf']],
        ['view', ['fullscreen', 'codeview', 'help']],
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

  setUpNewSalary() {
    const note = $('#project_draft_new_salary').summernote({
      height: 200,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['insert', ['link', 'picture', 'video', 'pdf']],
        ['view', ['fullscreen', 'codeview', 'help']],
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

  setUpAllowance() {
    $('#project_draft_allowance').summernote({
      height: 200,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['view', ['fullscreen', 'codeview', 'help']],
      ],
    });
  }

  setUpRaiseSalary() {
    $('#project_draft_raise_salary').summernote({
      height: 200,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['view', ['fullscreen', 'codeview', 'help']],
      ],
    });
  }

  setUpReward() {
    $('#project_draft_reward').summernote({
      height: 240,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['view', ['fullscreen', 'codeview', 'help']],
      ],
    });
  }

  setUpHoliday() {
    $('#project_draft_holiday').summernote({
      height: 240,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['view', ['fullscreen', 'codeview', 'help']],
      ],
    });
  }

  setUpInsurance() {
    $('#project_draft_insurance').summernote({
      height: 240,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['view', ['fullscreen', 'codeview', 'help']],
      ],
    });
  }

  setUpWelfareProgram() {
    $('#project_draft_welfare_program').summernote({
      height: 240,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['view', ['fullscreen', 'codeview', 'help']],
      ],
    });
  }

  setUpCompanyEvent() {
    $('#project_draft_company_event').summernote({
      height: 240,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['view', ['fullscreen', 'codeview', 'help']],
      ],
    });
  }

  setUpTrialPeriod() {
    $('#project_draft_trial_period').summernote({
      height: 240,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['view', ['fullscreen', 'codeview', 'help']],
      ],
    });
  }

  setUpOthereWelfare() {
    $('#project_draft_other_welfare').summernote({
      height: 240,
      lang: 'ja-JP',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['view', ['fullscreen', 'codeview', 'help']],
      ],
    });
  }

  setUpTraining() {
    $('#project_draft_training').summernote({
      height: 200,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['view', ['fullscreen', 'codeview', 'help']],
      ],
    });
  }

  setUpVacation() {
    $('#project_draft_vacation').summernote({
      height: 200,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['view', ['fullscreen', 'codeview', 'help']],
      ],
    });
  }

  setUpChildcare() {
    $('#project_draft_childcare').summernote({
      height: 200,
      lang: 'ja-JP',
      placeholder: '例',
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['view', ['fullscreen', 'codeview', 'help']],
      ],
    });
  }

  @on('change #project_draft_image')
  onChangeImage(event: any) {
    if (
      event.target instanceof HTMLInputElement &&
      event.target.files.length > 0
    ) {
      const fr = new FileReader();

      fr.onload = () => {
        this.image = fr.result;
        this.render();
      };
      fr.readAsDataURL($(event.target).prop('files')[0]);
    }
  }

  @on('change #project_draft_president_image')
  onChangePresidentImage(event: any) {
    if (
      event.target instanceof HTMLInputElement &&
      event.target.files.length > 0
    ) {
      const fr = new FileReader();

      fr.onload = () => {
        this.presidentImage = fr.result;
        this.render();
      };
      fr.readAsDataURL($(event.target).prop('files')[0]);
    }
  }

  @on('change #project_draft_stamp')
  onChangeStamp(event: any) {
    if (
      event.target instanceof HTMLInputElement &&
      event.target.files.length > 0
    ) {
      const fr = new FileReader();

      fr.onload = () => {
        this.stamp = fr.result;
        this.render();
      };
      fr.readAsDataURL($(event.target).prop('files')[0]);
    }
  }

  @on('keyup #project_draft_interview_movie')
  onChangeInterviewMovie() {
    this.movie = $('#project_draft_interview_movie').val();
    this.render();
  }

  @on('change input[name="project_draft[angel_type]"]:radio')
  onChangeAngelType() {
    this.render();
  }

  @on('change input[name="project_draft[contract_before_type]"]:radio')
  onChangeContractBeforeType() {
    this.render();
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

  @on('submit')
  onSubmit() {
    if (
      $('#project_draft_salary').summernote('codeview.isActivated')) {
      $('#project_draft_salary').summernote('codeview.deactivate');
    }

    if ($('#project_draft_process_selection').summernote('codeview.isActivated')) {
      $('#project_draft_process_selection').summernote('codeview.deactivate');
    }

    if ($('#project_draft_selection_condition').summernote('codeview.isActivated')) {
      $('#project_draft_selection_condition').summernote('codeview.deactivate');
    }

    if ($('#project_draft_student_assumption').summernote('codeview.isActivated')) {
      $('#project_draft_student_assumption').summernote('codeview.deactivate');
    }

    if ($('#project_draft_recruit_kind').summernote('codeview.isActivated')) {
      $('#project_draft_recruit_kind').summernote('codeview.deactivate');
    }

    if ($('#project_draft_duty_station').summernote('codeview.isActivated')) {
      $('#project_draft_duty_station').summernote('codeview.deactivate');
    }

    if ($('#project_draft_new_salary').summernote('codeview.isActivated')) {
      $('#project_draft_new_salary').summernote('codeview.deactivate');
    }

    if ($('#project_draft_allowance').summernote('codeview.isActivated')) {
      $('#project_draft_allowance').summernote('codeview.deactivate');
    }

    if ($('#project_draft_raise_salary').summernote('codeview.isActivated')) {
      $('#project_draft_raise_salary').summernote('codeview.deactivate');
    }

    if ($('#project_draft_reward').summernote('codeview.isActivated')) {
      $('#project_draft_reward').summernote('codeview.deactivate');
    }

    if ($('#project_draft_holiday').summernote('codeview.isActivated')) {
      $('#project_draft_holiday').summernote('codeview.deactivate');
    }

    if ($('#project_draft_insurance').summernote('codeview.isActivated')) {
      $('#project_draft_insurance').summernote('codeview.deactivate');
    }

    if ($('#project_draft_welfare_program').summernote('codeview.isActivated')) {
      $('#project_draft_welfare_program').summernote('codeview.deactivate');
    }

    if ($('#project_draft_company_event').summernote('codeview.isActivated')) {
      $('#project_draft_company_event').summernote('codeview.deactivate');
    }

    if ($('#project_draft_trial_period').summernote('codeview.isActivated')) {
      $('#project_draft_trial_period').summernote('codeview.deactivate');
    }

    if ($('#project_draft_other_welfare').summernote('codeview.isActivated')) {
      $('#project_draft_other_welfare').summernote('codeview.deactivate');
    }

    if ($('#project_draft_training').summernote('codeview.isActivated')) {
      $('#project_draft_training').summernote('codeview.deactivate');
    }

    if ($('#project_draft_vacation').summernote('codeview.isActivated')) {
      $('#project_draft_vacation').summernote('codeview.deactivate');
    }

    if ($('#project_draft_childcare').summernote('codeview.isActivated')) {
      $('#project_draft_childcare').summernote('codeview.deactivate');
    }
  }

  render() {
    const url = 'https://www.googleapis.com/youtube/v3/videos';
    const videoId = 'id=' + this.movie;
    const apiKey = 'key=AIzaSyDryFcx597-RtHbDCL8XIazSJEdbnly4r8'; // TODO
    const part = 'part=snippet';
    const angelType = parseInt(
      $('input[name="project_draft[angel_type]"]')
        .filter(':checked')
        .val(),
    );
    const contractBeforeType = parseInt(
      $('input[name="project_draft[contract_before_type]"]')
        .filter(':checked')
        .val(),
    );

    if (this.image !== '') {
      $('#preview_image')
        .css('background-image', `url(${this.image})`)
        .show();
    }

    if (this.presidentImage !== '') {
      $('#preview_president_image')
        .css('background-image', `url(${this.presidentImage})`)
        .show();
    }

    if (this.stamp !== '') {
      $('#preview_stamp')
        .css('background-image', `url(${this.stamp})`)
        .show();
    }

    $.get(`${url}?${apiKey}&${videoId}&${part}`, response => {
      if (response.pageInfo.totalResults == 0) {
        $('#youtube').hide();
      } else {
        $('#youtube').show();
      }
    });

    $('#youtube').attr('src', '//www.youtube.com/embed/' + this.movie);

    if (angelType === 0) {
      $('#angel_properties').hide();
    } else {
      $('#angel_properties').show();
    }

    if (contractBeforeType === 0) {
      $('.project_draft_contract_before').show();
      $('#contract_info').hide();
      $('.project_draft_company_info').show();
      $('.project_draft_solicit_info').show();
      $('.project_draft_review_result').show();
    } else {
      $('.project_draft_contract_before').hide();
      $('#contract_info').show();
      $('.project_draft_company_info').hide();
      $('.project_draft_solicit_info').hide();
      $('.project_draft_review_result').hide();
    }
  }
  setPlaceholder(){
    $('div.project_draft_salary div.note-placeholder').html('例)【2017年度】<br>月19万円程度（月給制）<br><br>【2018年度】<br>月20万円程度（月給制）');
    $('div.project_draft_process_selection div.note-placeholder').html('例)WEBプレエントリー締切(5/1)<br><br>エントリーシート提出締切(6/1)<br><br>[一次選考]グループディスカッション<br><br>[二次選考]集団面接<br><br>[三次選考]部長面接<br><br>[最終選考]取締役面接<br>');
    $('div.project_draft_selection_condition div.note-placeholder').html('例)4年生大学、大学院を2019年3月卒業見込みの者');
    $('div.project_draft_student_assumption div.note-placeholder').html('例)【当社が求める人物像】<br><br>組織目標を達成するために<br>何をやるべきかを自ら考え<br>実行できる積極性のある学生を求めます。');
    $('div.project_draft_recruit_kind div.note-placeholder').html('例)2019年度は以下の部署で新卒の皆様を募集します。<br>・経理部<br>・商品開発部<br>・企画部');
    $('div.project_draft_duty_station div.note-placeholder').html('例)各部署の勤務地は以下の通りです。<br>[経理部/企画部]<br>東京支社　東京都〇〇区<br><br>[商品開発部]<br>横浜支社　神奈川県横浜市〇〇区');
    $('div.project_draft_new_salary div.note-placeholder').html('例)【大学院卒】<br>月給24万5800円<br>【大学卒】<br>月給22万6800円<br>【短大・専門・高専卒】<br>月給20万3900円<br><br>※既卒者も同様');
    $('div.project_draft_allowance div.note-placeholder').html('例)役職手当<br>家族手当<br>住宅手当（月5万円／当社規定による）<br>時間外手当<br>通勤手当');
    $('div.project_draft_raise_salary div.note-placeholder').html('例)年1回');
    $('div.project_draft_reward div.note-placeholder').html('例)年2回');
    $('div.project_draft_holiday div.note-placeholder').html('例)週休2日制　※年間休日◯日<br>特別休暇（入社6ヶ月迄 1日／2ヶ月）<br>有給休暇<br>慶弔休暇<br>育児休暇');
    $('div.project_draft_insurance div.note-placeholder').html('例)社会保険完備（健康保険・厚生年金保険・雇用保険・労働災害保険） ');
    $('div.project_draft_welfare_program div.note-placeholder').html('例)定期健康診断<br>永年勤続表彰<br>慶弔見舞金<br>退職金制度<br>社員親睦会 ');
    $('div.project_draft_company_event div.note-placeholder').html('例)社内親睦会（年2・3回）');
    $('div.project_draft_trial_period div.note-placeholder').html('例)あり：入社後3ヶ月間<br>※試用期間中と本採用後で労働条件の相違なし');
    $('div.project_draft_training div.note-placeholder').html('例)あり：<br>内定者研修<br>新入社員研修 ');
    $('div.project_draft_vacation div.note-placeholder').html('例)11.3日（2018年度実績）');
    $('div.project_draft_childcare div.note-placeholder').html('例)15名（うち女性10名）');
  }
}
