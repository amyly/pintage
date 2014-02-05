class AddPocketUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pocket_username, :string
    add_column :users, :pocket_token, :string
  end
end
