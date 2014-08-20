class AddOwnerRefToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :owner_id, :integer, index: true
  end
end
