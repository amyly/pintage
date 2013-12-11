class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :user_id
      t.string :url
      t.string :title
      t.string :description
      t.datetime :save_date

      t.timestamps
    end
  end
end
