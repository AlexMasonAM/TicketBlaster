class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :seat
      t.references :customer, index: true
      t.references :event, index: true

      t.timestamps null: false
    end
    add_foreign_key :tickets, :customers
    add_foreign_key :tickets, :events
  end
end
