class Job < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 5000 }
  validates :salary, presence: true, numericality: { only_integer: true, greater_than: 0}
  validates :email, presence: true, length: { maximum: 255 }, format: VALID_EMAIL_REGEX
  validates :phone, presence: true
end
