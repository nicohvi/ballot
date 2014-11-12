class CreatePolls < ActiveRecord::Migration
  def up
    create_table :polls do |t|

      t.timestamps
    end
  end

  def down
    drop_table :polls
  end
end
