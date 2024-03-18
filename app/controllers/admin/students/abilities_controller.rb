class Admin::Students::AbilitiesController < Admin::AdminController
  before_action :set_student
  before_action :set_ability, only: [:edit, :update]

  def new
    @ability = StudentAbility.new
  end

  def create
    @ability = StudentAbility.new(student_ability_params)
    @ability.student_id = @student.id
    @ability.admin_id = current_admin.id

    if @ability.save
      render :create
    else
      render :new
    end
  end

  def edit
    render :new
  end

  def update
    @ability.attributes = student_ability_params
    @ability.admin_id = current_admin.id
    if @ability.save
      render :create
    else
      render :new
    end
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end

  def set_ability
    @ability = StudentAbility.find_by(student_id: @student.id)
  end

  def student_ability_params
    params.require(:student_ability).permit(
      :ability_1, :ability_2, :ability_3, :ability_4, :ability_5, :ability_6
    )
  end
end
