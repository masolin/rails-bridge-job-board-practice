class Tag < ActiveRecord::Base
  has_many :job_tags, dependent: :destroy
  has_many :jobs, through: :job_tags

  validates :name, presence: true
end
