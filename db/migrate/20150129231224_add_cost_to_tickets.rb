class AddCostToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :cost, :float
    add_column :tickets, :section, :string
  end
end
