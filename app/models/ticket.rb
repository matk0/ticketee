class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :author, class_name: 'User'
  belongs_to :state
  has_many :attachments, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags, uniq: true
  has_and_belongs_to_many :watchers, join_table: 'ticket_watchers', class_name: 'User', uniq: true
  after_create :author_watches_me, :set_tags_count
  after_destroy :set_tags_count

  attr_accessor :tag_names

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  validates :name, presence: true
  validates :description, presence: true

  before_create :assign_default_state

  def set_tags_count
    self.tags_count = self.tags.count
    self.save
  end

  def toggle_completed!
    self.toggle(:completed)
    self.save
  end

  def tag_names
    @tag_names
  end

  def tag_names= names
    @tag_names = remove_whitespace(names)
    @tag_names.split(",").each do |name|
      self.tags << Tag.find_or_initialize_by(name: name)
    end
  end

  def self.search_by_tags search_terms
    ticket_ids = ActiveRecord::Base.connection.execute("SELECT t.id FROM tickets t
                                                        JOIN tags_tickets tt ON t.id = tt.ticket_id
                                                        JOIN tags ta ON tt.tag_id = ta.id
                                                        WHERE #{sqlize_search_terms search_terms}
                                                        GROUP BY t.id
                                                        HAVING array_length(array_agg(ta.name), 1) = #{search_terms.count};")
    Ticket.find(ticket_ids.values.flatten)
  end

  def self.search_by_tags_exactly search_terms
    ticket_ids = ActiveRecord::Base.connection.execute("SELECT t.id FROM tickets t
                                                        JOIN tags_tickets tt ON t.id = tt.ticket_id
                                                        JOIN tags ta ON tt.tag_id = ta.id
                                                        WHERE #{sqlize_search_terms search_terms}
                                                        AND #{search_terms.count} = t.tags_count 
                                                        GROUP BY t.id
                                                        HAVING array_length(array_agg(ta.name), 1) = #{search_terms.count};")
    Ticket.find(ticket_ids.values.flatten)
  end

  def self.search_with_at_least_one_matching_tag search_terms
    ticket_ids = ActiveRecord::Base.connection.execute("SELECT t.id FROM tickets t
                                                        JOIN tags_tickets tt ON t.id = tt.ticket_id
                                                        JOIN tags ta ON tt.tag_id = ta.id
                                                        WHERE #{sqlize_search_terms search_terms}
                                                        GROUP BY t.id;")
    Ticket.find(ticket_ids.values.flatten)
  end

  private

    def self.sqlize_search_terms terms
      terms.inject("") do |sql, term|
        sql += "LOWER(ta.name) LIKE LOWER('#{term}') #{'OR' unless term == terms.last} "
      end
    end

    def remove_whitespace string
      string.gsub(/\s+/, '')
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
