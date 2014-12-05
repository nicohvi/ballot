class AddSecretToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :secret, :string
  end
end
