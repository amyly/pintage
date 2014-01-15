class AddSentBackToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :sent_back, :boolean, default: false
  end
end
