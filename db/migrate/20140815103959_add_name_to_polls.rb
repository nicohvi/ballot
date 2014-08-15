class AddNameToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :name, :string
  end
end
