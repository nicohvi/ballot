class RenameActiveToClosed < ActiveRecord::Migration
  def change
    rename_column :polls, :active, :closed
    change_column :polls, :closed, :boolean, default: false
  end
end
