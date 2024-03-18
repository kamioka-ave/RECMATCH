class StudentCardHistory
  attr_accessor :updated_at, :changes

  def initialize(updated_at, changes)
    @updated_at = updated_at
    @changes = changes
  end
end