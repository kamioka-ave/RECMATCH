class CompanyContract
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :confirmed, :about_cancel, :promise_antisocialists, :type

  validates :confirmed, presence: true, acceptance: true
  validates :about_cancel, presence: true, acceptance: true
  validates :promise_antisocialists, presence: true, acceptance: true
  validates :type, presence: true

  def initialize(params = nil)
    if params != nil
      @confirmed = params[:confirmed] if params.key?(:confirmed)
      @about_cancel = params[:about_cancel] if params.key?(:about_cancel)
      @promise_antisocialists = params[:promise_antisocialists] if params.key?(:promise_antisocialists)
      @type = params[:type] if params.key?(:type)
    end
  end

  def persisted?
    false
  end

  def id
    nil
  end
end