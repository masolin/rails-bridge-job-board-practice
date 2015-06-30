class Job < ActiveRecord::Base
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 5000 }
end
