desc "This task is called by the Heroku scheduler add-on"
# task :update_feed => :environment do
#   puts "Updating feed..."
#   NewsFeed.update
#   puts "done."
# end

task :send_random_bookmark => :environment do
  puts "Looping through users and sending random bookmark"
  User.all.each do |user|
    if user.pinboard_token
      user.send_random_bookmark(user)
    end
  end
  puts "Done"
end
