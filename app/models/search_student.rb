class SearchStudent
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :bunri, :graduate, :communication, :chalenge, :commit, :teamwork, :leader, :logical, :toeic, :univ, :business_type

  def initialize(attributes = {})
    @start_at = Date.new(attributes['start_at(1i)'].to_i, attributes['start_at(2i)'].to_i, attributes['start_at(3i)'].to_i) if attributes.key?('start_at(1i)')
    @end_at = Date.new(attributes['end_at(1i)'].to_i, attributes['end_at(2i)'].to_i, attributes['end_at(3i)'].to_i) if attributes.key?('end_at(1i)')
    @start_at = attributes[:start_at] if attributes.key?(:start_at)
    @end_at = attributes[:end_at] if attributes.key?(:end_at)

  end

  def persisted?
    false
  end

  def id
    nil
  end
end