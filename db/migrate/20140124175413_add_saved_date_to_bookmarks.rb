class AddSavedDateToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :saved_date, :datetime
  end
end
