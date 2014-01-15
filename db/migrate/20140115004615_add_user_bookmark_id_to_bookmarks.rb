class AddUserBookmarkIdToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :user_bookmark_id, :integer
  end
end
