class RenameStatusToActive < ActiveRecord::Migration
  def change
    rename_column :polls, :status, :active
  end
end
