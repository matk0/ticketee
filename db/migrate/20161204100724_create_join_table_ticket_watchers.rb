class CreateJoinTableTicketWatchers < ActiveRecord::Migration
  def change
    create_join_table :tickets, :users, table_name: :ticket_watchers
  end
end
