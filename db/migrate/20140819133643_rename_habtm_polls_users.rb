class RenameHabtmPollsUsers < ActiveRecord::Migration
  def change
    rename_table :users_polls, :polls_users
  end
end
