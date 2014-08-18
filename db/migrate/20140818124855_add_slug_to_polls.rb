class AddSlugToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :slug, :string, index: true
  end
end
