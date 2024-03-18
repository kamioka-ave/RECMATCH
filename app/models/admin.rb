class Admin < ApplicationRecord
  rolify role_cname: 'AdminRole'
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  has_one :students_display, class_name: 'Admin::StudentsDisplay'
  has_many :admin_companies, dependent: :destroy
  has_many :companies, through: :admin_companies

  validates :name, presence: true
  validates :email, presence: true
  validates :roles, presence: true
end
