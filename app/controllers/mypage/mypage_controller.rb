class Mypage::MypageController < ApplicationController
  before_action :authenticate_user!, :check_application

  private

  def authenticate_user!
    UserToken.find_by(device_token: cookies.signed[:device_token])&.destroy unless warden.authenticated?(:user)
    super
  end

  def check_application
    if current_user.has_role? :student
      if !request.fullpath.include?('/mypage/company')
        if current_user.student.blank? || current_user.student.status == Student::S_NEW
          if current_user.student_agreement.blank? && !request.fullpath.include?('/mypage/student/wizard')
            redirect_to mypage_student_wizard_page_path
          elsif current_user.student.blank? && !request.fullpath.include?('/mypage/student/wizard')
              redirect_to mypage_student_wizard_student_path
          elsif !request.fullpath.include?('/mypage/student/wizard')
            redirect_to mypage_student_wizard_confirm_path
          end
        elsif current_user.student.status == Student::S_REJECTED
          if !current_user.student.enable_reapply
            redirect_to destroy_user_session_path
          elsif !current_user.student_agreement.reapplied && !request.fullpath.include?('/mypage/student/wizard')
            redirect_to mypage_student_wizard_agreement_path
          elsif !current_user.student_interview.reapplied && !request.fullpath.include?('/mypage/student/wizard')
            redirect_to mypage_student_wizard_interview_path
          elsif !current_user.student.reapplied && !request.fullpath.include?('/mypage/student/wizard')
            if current_user.student_interview.not_suitable?
              redirect_to nonconform_mypage_student_wizard_interview_path
            else
              redirect_to mypage_student_wizard_student_path
            end
          #elsif !current_user.student.reapplied && current_user.student.pep.blank? && !request.fullpath.include?('/mypage/student/wizard')
            #redirect_to mypage_student_wizard_pep_path
          #elsif !current_user.identification.reapplied && !request.fullpath.include?('/mypage/student/wizard')
            #redirect_to mypage_student_wizard_identification_path
          elsif !request.fullpath.include?('/mypage/student/wizard')
            redirect_to mypage_student_wizard_confirm_path
          end
        elsif need_reconfirm?
          redirect_to details_mypage_student_path
        #elsif current_user.student.status == Student::S_ACTIVATED && !current_user.student.need_reconfirm? && current_user.student.pep.blank? && !request.fullpath.include?('/mypage/student/pep')
          #redirect_to new_mypage_student_pep_path
        elsif current_user.student.status != Student::S_ACTIVATED && (request.fullpath != '/mypage' && request.fullpath != '/mypage/student/wizard/thanks')
          redirect_to mypage_root_path
        end
      else
        render_404
      end
    elsif current_user.has_role? :company
      if !request.fullpath.include?('/mypage/student')
        status = current_user.company.present? ? current_user.company.status : Company::S_BASICS

        if status == Company::S_TEMP_ACTIVE
          if !request.fullpath.include?('/mypage/company/agreement')
            redirect_to mypage_company_agreement_path
          end
        else
          if !request.fullpath.include?('/mypage/company/wizard') && status != Company::S_ACTIVE
            if current_user.company_agreement.blank?
              #redirect_to mypage_company_wizard_agreement_path
              redirect_to mypage_company_wizard_page_path
            else
              if current_user.company.blank?
                redirect_to mypage_company_wizard_basic_path
              elsif current_user.company.present? && status == Company::S_BASICS
                redirect_to mypage_company_wizard_detail_path
              elsif current_user.company.present? && status == Company::S_DETAILS
                redirect_to mypage_company_wizard_confirm_path
              elsif current_user.company.present? && status == Company::S_APPLIED && request.fullpath != '/mypage'
                redirect_to mypage_root_path
              end
            end
          end
        end
      else
        render_404
      end
    end
  end

  def need_reconfirm?
    current_user.student.need_reconfirm? &&
        request.fullpath != '/mypage/student/details' &&
        request.fullpath != '/mypage/student/reconfirm' &&
        request.fullpath != '/mypage/student/reconfirm/interview' &&
        request.fullpath != '/mypage/student/reconfirm/student' &&
        request.fullpath != '/mypage/student/reconfirm/pep' &&
        request.fullpath != '/mypage/student/reconfirm/confirm'
  end
end
