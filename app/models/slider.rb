class Slider < ApplicationRecord
  belongs_to :project
  belongs_to :event
  belongs_to :headline

  validates :slider_type, presence: true
  validates :project_id, presence: true, if: -> { slider_type == 'Project' }
  validates :event_id, presence: true, if: -> { slider_type == 'Event' }
  validates :bg_image, presence: true
  validates :rank, presence: true, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 0x7fffffff
  }

  mount_uploader :image, ImageUploader
  mount_uploader :bg_image, ImageUploader

  def self.names_with_slider_type
    {
      企業情報: 'Project',
      イベント情報: 'Event',
      NEWS: 'Headline'
    }
  end

  def slidable_id
    case slider_type
    when 'Project'
      project_id
    when 'Event'
      event_id
    when 'Headline'
      headline_id
    end
  end

  def title
    case slider_type
    when 'Project'
      project.name
    when 'Event'
      event.title
    when 'Headline'
      headline.title
    end
  end

  def slidable_image
    case slider_type
    when 'Topimg'
      image
    when 'Project'
      project.image
    when 'Event'
      event.image
    when 'Headline'
      image
    end
  end
end
