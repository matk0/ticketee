class AddCompleteToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :complete, :boolean, default: false
  end
end
