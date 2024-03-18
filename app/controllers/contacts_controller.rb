class ContactsController < ApplicationController
  def show
    @contact = Contact.new

    if user_signed_in?
      @contact.email = current_user.email

      if current_user.student.present?
        @contact.name = current_user.student.full_name
      elsif current_user.company.present?
        @contact.name = "#{current_user.company.name} #{current_user.company.president_name}"
      end
    end
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.user_id = current_user.id if user_signed_in?

    if @contact.save
      redirect_to root_path, notice: 'お問い合わせを行いました。内容を確認の上、返信いたします。'
    else
      render :show
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :name, :message, :file)
  end
end
