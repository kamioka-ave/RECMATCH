class Users::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.find_or_initialize_with_errors([:email], resource_params, :not_found)

    if resource.has_role?(:student) &&
        resource.student.present? &&
        resource.student.status == Student::S_REJECTED &&
        !resource.student.enable_reapply
      resource.errors.add(:email, t('errors.messages.not_found'))
      respond_with(resource)
    else
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      yield resource if block_given?

      if successfully_sent?(resource)
        respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
      else
        respond_with(resource)
      end
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)

      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end

      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      set_minimum_password_length
      respond_with resource
    end
  end
end