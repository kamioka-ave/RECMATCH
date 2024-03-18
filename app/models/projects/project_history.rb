class ProjectHistory < ApplicationRecord
  include Draftable
  include Projectable

  default_scope -> { order(revision: :desc) }

  belongs_to :company
  has_one :user, through: :company
  has_one :profile, through: :user
  belongs_to :admin
  belongs_to :authorizer, class_name: 'Admin', foreign_key: :authorizer_id
  has_many :project_history_categories, dependent: :destroy
  has_many :contract_images, class_name: 'Project::ContractImage', as: :projectable, dependent: :destroy
  has_many :company_presidents, class_name: 'Project::CompanyPresident', as: :projectable, dependent: :destroy
  has_many :categories, through: :project_history_categories
  accepts_nested_attributes_for :project_history_categories

  mount_uploader :image, ProjectUploader
  mount_uploader :president_image, ProfileUploader
  mount_uploader :stamp, ImageUploader
end
