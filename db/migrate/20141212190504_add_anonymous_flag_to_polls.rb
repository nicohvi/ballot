class AddAnonymousFlagToPolls < ActiveRecord::Migration

  def up
    add_column :polls, :allow_anonymous, :boolean, default: true
  end

  def down
    remove_column :polls, :allow_anonymous, :boolean, default: true
  end

end
