class AddGuestToken < ActiveRecord::Migration
  def change
    add_column :polls, :guest_token, :string
    add_column :votes, :guest_token, :string
  end
end
