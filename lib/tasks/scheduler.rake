require 'mandrill'

desc "This task is called by the Heroku scheduler add-on"
# task :update_feed => :environment do
#   puts "Updating feed..."
#   NewsFeed.update
#   puts "done."
# end

task :send_random_bookmarks => :environment do
  puts "Sending random bookmark to each user"
  User.send_all_random_bookmarks
  puts "Done"
end
