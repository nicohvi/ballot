class AddHabtmUserPolls < ActiveRecord::Migration
  def change
    create_table :users_polls do |t|
      t.references :user
      t.references :poll

      t.timestamps
    end

    add_index :users_polls, ['user_id', 'poll_id'], unique: true

  end
end
