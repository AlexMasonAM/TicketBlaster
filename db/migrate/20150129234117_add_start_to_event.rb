class AddStartToEvent < ActiveRecord::Migration
  def change
    add_column :events, :start_time, :datetime, default: Time.now, null: false
    add_column :events, :archived, :boolean, default: false, null: false
  end
end
