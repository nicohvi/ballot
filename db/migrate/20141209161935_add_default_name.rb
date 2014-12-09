class AddDefaultName < ActiveRecord::Migration
  def change
    change_column :users, :name, :string, default: 'User'
  end
end
