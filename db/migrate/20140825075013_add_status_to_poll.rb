class AddStatusToPoll < ActiveRecord::Migration

  def change
    add_column :polls, :status, :boolean, default: true
  end

end
