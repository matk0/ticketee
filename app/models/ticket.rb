class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :author, class_name: 'User'
  belongs_to :state
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :attachments, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  validates :name, presence: true
  validates :description, presence: true

  def toggle_completed!
    self.toggle(:completed)
    self.save
  end

  def all_tags=(names)
    self.tags = names.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def all_tags
    self.tags.map(&:name).join(", ")
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).tickets
  end
end
