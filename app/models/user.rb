class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bookmarks
  require 'pocket'
  # validates :pinboard_token, format: { with: /[a-z0-9]+\:[A-Z0-9]{20}/, message: "Needs to follow Pinboard token format" }

  def add_pocket_token(auth)
    if self.pocket_token.nil?
      self.pocket_username = auth["uid"]
      self.pocket_token = auth["credentials"]["token"]
      self.save
    end
  end

  def get_all_pocket
    if pocket_token != nil
      client = Pocket.client(:access_token => pocket_token, :consumer_key => ENV['POCKET_CONSUMER_KEY'])
      bookmarks = client.retrieve(:detailType => :complete, :state => :simple)
      bookmarks['list'].each do |key, value|
        bookmark = Bookmark.new
        bookmark.source = "pocket"
        bookmark.url = value["given_url"]
        bookmark.title = value["given_title"]
        bookmark.description = value["excerpt"]
        bookmark.saved_date = Time.at(value["time_added"].to_i).to_datetime
        bookmark.user_id = self.id
        bookmark.save
      end
    end
  end

  def get_all_pinboard
    if pinboard_token != nil
      PinboardApi.auth_token = pinboard_token
      pins = PinboardApi::Post.all
      pins.each do |pin|
        if self.bookmarks.find_by(url: pin.url).nil?
          bookmark = Bookmark.new
          bookmark.source = "pinboard"
          bookmark.url = pin.url.to_s
          bookmark.tags = pin.tags.to_s
          bookmark.title = pin.description.to_s
          bookmark.description = pin.extended.to_s
          bookmark.saved_date = pin.time
          bookmark.user_id = self.id
          bookmark.save
        end
      end
    end
  end

  def delete_all_pinboard
    bookmarks.where(:source => "pinboard", :sent_back => false).delete_all
    update_attribute(:pinboard_token, nil)
  end

  def delete_all_pocket
    bookmarks.where(:source => "pocket", :sent_back => false).delete_all
    update_attributes(:pocket_token => nil, :pocket_username => nil)
  end

  def get_random_bookmark
    begin random_bookmark = bookmarks[rand(bookmarks.length)]
    end until random_bookmark.sent_back == false
    random_bookmark.update_attributes(:sent_back => true, :sent_back_date => DateTime.now)
    random_bookmark
  end

  def self.send_random_bookmarks
    User.find_each do |user|
      m = Mandrill::API.new
      random_bookmark = user.get_random_bookmark
      message = {
        :subject=> "Your Random Bookmark",
        :from_name=> "Pintage",
        :text=>"Your random pin is #{random_bookmark.url}",
        :to=>[
          {
            :email=> user.email
            # :name=> ""
          }
        ],
        :html=>"<html><h1>Hi! Your random pin is #{random_bookmark.url} #{random_bookmark.id}</h1></html>",
        :from_email=>"a@amys.ly"
      }
      sending = m.messages.send message
      puts sending
    end
  end
end
