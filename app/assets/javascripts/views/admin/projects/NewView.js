// @flow
import JQueryView, { on } from '../../common/JQueryView';
import ProjectClient from '../../../models/projects/ProjectClient';

export default class NewView extends JQueryView {
  projectClient = new ProjectClient();
  projects: any;

  constructor() {
    super('.simple_form');
    this.fetchStagingProjects();
    this.render();
  }

  fetchStagingProjects() {
    this.projectClient
      .fetchStagingProjects()
      .then(response => {
        this.projects = response.data;
        this.projects.forEach(project => {
          $('#project_draft_staging_project_id').append(
            $('<option>', {
              value: project.id,
              text: project.name,
            }),
          );
        });
      })
      .catch(error => {
        console.warn(error);
      });
  }

  @on('change #project_draft_clone_from_staging')
  onChangeCloneFromStaging() {
    this.render();
  }

  @on('click input[name="commit"]')
  onSubmit() {
    const cloneFromStaging = $(
      'input[name="project_draft[clone_from_staging]"]',
    )
      .filter(':checked')
      .val();

    if (cloneFromStaging != null) {
      const stagingProjectId = $('#project_draft_staging_project_id').val();
      const project = this.projects.find(
        project => project.id == stagingProjectId,
      );

      $('#project_draft_solicit').val(project.solicit);
      $('#project_draft_solicit_limit').val(project.solicit_limit);
      $('#project_draft_stock_price').val(project.stock_price);
      $('#project_draft_start_at').val(project.start_at);
      $('#project_draft_finish_at').val(project.finish_at);
      $('#project_draft_start_on').val(project.start_on);
      $('#project_draft_shareholder_meeting_on').val(
        project.shareholder_meeting_on,
      );
      $('#project_draft_is_temporarily_shareholder_meeting').val(
        project.is_temporarily_shareholder_meeting,
      );
      $('#project_draft_board_meeting_on').val(project.board_meeting_on);
      $('#project_draft_agreement_on').val(project.agreement_on);
      $('#project_draft_deliv_start_on').val(project.deliv_start_on);
      $('#project_draft_deliv_end_on').val(project.deliv_end_on);
      $('#project_draft_deliv_start_changed_on').val(
        project.deliv_start_changed_on,
      );
      $('#project_draft_deliv_end_changed_on').val(
        project.deliv_end_changed_on,
      );
      $('#project_draft_contract_before_type').val(
        project.contract_before_type === 'PDF' ? 0 : 1,
      );
      $('#project_draft_remote_contract_before_url').val(
        project.contract_before_url,
      );
      $('#project_draft_remote_law_notification_url').val(
        project.law_notification,
      );
      $('#project_draft_remote_image_url').val(project.image_url);
      $('#project_draft_remote_president_image_url').val(
        project.president_image_url,
      );
      $('#project_draft_remote_stamp_url').val(project.stamp_url);
      $('#project_draft_president_name').val(project.president_name);
      $('#project_draft_president_description').val(
        project.president_description,
      );
      $('#project_draft_interview_movie').val(project.interview_movie);
      $('#project_draft_angel_type').val(project.angel_type);
      $('#project_draft_angel_download_start_on').val(
        project.angel_download_start_on,
      );
      $('#project_draft_angel_download_end_on').val(
        project.angel_download_end_on,
      );
      $('#project_draft_angel_arrival_deadline_on').val(
        project.angel_arrival_deadline_on,
      );
      $('#project_draft_shareholder_benefit').val(project.shareholder_benefit);
      $('#project_draft_stockholder_management').val(
        project.stockholder_management,
      );
      $('#project_draft_capital').val(project.capital);
      $('#project_draft_capital_submitted_on').val(
        project.capital_submitted_on,
      );
      $('#project_draft_issued_stock').val(project.issued_stock);
      $('#project_draft_transcript_submitted_on').val(
        project.transcript_submitted_on,
      );
      $('#project_draft_issuable_stocks').val(project.issuable_stocks);
      $('#project_draft_stock_price_for_reserve').val(
        project.stock_price_for_reserve,
      );
      $('#project_draft_support_phone').val(project.support_phone);
      $('#project_draft_support_email').val(project.support_email);
      $('#project_draft_risk_summery').val(project.risk_summery);
      $('#project_draft_how_to_use').val(project.how_to_use);
      $('#project_draft_transfer_restriction').val(
        project.transfer_restriction,
      );
      $('#project_draft_company_summery').val(project.company_summery);
      $('#project_draft_business_plan').val(project.business_plan);
      $('#project_draft_finance_condition').val(project.finance_condition);
      $('#project_draft_business_plan_validity').val(
        project.business_plan_validity,
      );
      $('#project_draft_company_eligibility').val(project.company_eligibility);
      $('#project_draft_stake').val(project.stake);
      $('#project_draft_governance_system').val(project.governance_system);
      $('#project_draft_description').val(project.description);
      $('#project_draft_company_info').val(project.company_info);
      $('#project_draft_solicit_info').val(project.solicit_info);
      $('#project_draft_risk_info').val(project.risk_info);
      $('#project_draft_financial_info').val(project.financial_info);
      $('#project_draft_review_result').val(project.review_result);
      $('#project_draft_remote_contract_attachment_url').val(
        project.contract_attachment_url,
      );

      project.contract_images.forEach((image, i) => {
        $('form').append(
          `<input type="hidden" value="${
            image.image.url
          }" name="project_draft[contract_images_attributes][${i}][remote_image_url]" id="project_draft_contract_images_attributes_${i}_remote_image_url" />`,
        );
      });

      project.company_presidents.forEach((president, i) => {
        $('form').append(
          `<input type="hidden" value="${
            president.position
          }" name="project_draft[company_presidents_attributes][${i}][position]" id="project_draft_company_presidents_attributes_${i}_position" />`,
        );
        $('form').append(
          `<input type="hidden" value="${
            president.first_name
          }" name="project_draft[company_presidents_attributes][${i}][first_name]" id="project_draft_company_presidents_attributes_${i}_first_name" />`,
        );
        $('form').append(
          `<input type="hidden" value="${
            president.first_name_kana
          }" name="project_draft[company_presidents_attributes][${i}][first_name_kana]" id="project_draft_company_presidents_attributes_${i}_first_name_kana" />`,
        );
        $('form').append(
          `<input type="hidden" value="${
            president.last_name
          }" name="project_draft[company_presidents_attributes][${i}][last_name]" id="project_draft_company_presidents_attributes_${i}_last_name" />`,
        );
        $('form').append(
          `<input type="hidden" value="${
            president.last_name_kana
          }" name="project_draft[company_presidents_attributes][${i}][last_name_kana]" id="project_draft_company_presidents_attributes_${i}_last_name_kana" />`,
        );
      });
    }

    return true;
  }

  render() {
    const cloneFromStaging = $(
      'input[name="project_draft[clone_from_staging]"]',
    )
      .filter(':checked')
      .val();
    $('.project_draft_staging_project_id').toggle(cloneFromStaging != null);
  }
}
