class AddSourceToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :source, :string
    add_column :bookmarks, :sent_back_date, :datetime
  end
end
