namespace :db do
  desc "Clear Bookmarks table"
  task :reset_bookmarks => :environment do
    puts "Clearing Bookmarks table"
    Bookmark.destroy_all
    puts "Finished."
  end
end
