namespace :db do
  desc "Reset Pinboard token"
  task :reset_pinboard_token => :environment do
    puts "Resetting Pinboard token"
    user = User.first
    user.pinboard_token = nil
    user.save
    puts "Finished."
  end
end
