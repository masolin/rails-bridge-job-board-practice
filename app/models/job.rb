class Job < ActiveRecord::Base
  has_many :job_tags, dependent: :destroy
  has_many :tags, through: :job_tags

  VALID_ALL_TAGS_REGEX = /\A(\s*|\s*\w[\w\s]*(,\s*\w[\w\s]*)*)\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 5000 }
  validates :salary, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :email, presence: true, length: { maximum: 255 }, format: VALID_EMAIL_REGEX
  validates :phone, presence: true
  validates :all_tags, format: VALID_ALL_TAGS_REGEX

  def self.tagged_with(name)
    Tag.find_by(name: name).jobs
  end

  def all_tags=(names)
    tmp_tags = names.split(',').map do |name|
      Tag.find_or_initialize_by(name: name.strip) unless name.strip.empty?
    end.compact
    self.tags = tmp_tags unless tmp_tags.empty?
  end

  def all_tags
    tags.map(&:name).join(', ')
  end
end
