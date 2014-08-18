class AddNameToOptions < ActiveRecord::Migration
  def change
    add_column :options, :name, :string
  end
end
