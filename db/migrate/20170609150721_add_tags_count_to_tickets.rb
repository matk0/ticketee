class AddTagsCountToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :tags_count, :integer
  end
end
