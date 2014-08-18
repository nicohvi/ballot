class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user
      t.references :option

      t.timestamps
    end

    add_index :votes, ['user_id', 'option_id'], unique: true

  end
end
