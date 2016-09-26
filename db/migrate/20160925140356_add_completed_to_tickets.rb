class AddCompletedToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :completed, :boolean, default: false
  end
end
