class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :author, class_name: 'User'
  belongs_to :state
  has_many :attachments, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags, uniq: true
  has_and_belongs_to_many :watchers, join_table: 'ticket_watchers', class_name: 'User', uniq: true
  after_create :author_watches_me

  attr_accessor :tag_names

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  validates :name, presence: true
  validates :description, presence: true

  before_create :assign_default_state

  def toggle_completed!
    self.toggle(:completed)
    self.save
  end

  def tag_names
    @tag_names
  end

  def tag_names= names
    @tag_names = remove_whitespace(names)
    names.split(",").each do |name|
      self.tags << Tag.find_or_initialize_by(name: name)
    end
  end

  private

  def remove_whitespace string
    string.gsub!(/\s+/, '')
  end

  def assign_default_state
    self.state ||= State.default
  end

  def author_watches_me
    if author.present? && !self.watchers.include?(author)
      self.watchers << author
    end
  end
end
