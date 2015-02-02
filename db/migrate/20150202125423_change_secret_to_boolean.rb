class ChangeSecretToBoolean < ActiveRecord::Migration
  def up
    change_column :polls, :secret, 'boolean USING CAST(secret AS boolean)', default: false
  end

  def down
    change_column :polls, :secret, :string
  end
end
