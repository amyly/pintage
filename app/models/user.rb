class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bookmarks
  # validates :pinboard_token, format: { with: /[a-z0-9]+\:[A-Z0-9]{20}/, message: "Needs to follow Pinboard token format" }

  def get_all_bookmarks
    get_all_pinboard
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

  def delete_all_bookmarks
    delete_all_pinboard
  end

  def delete_all_pinboard
    bookmarks.where(:source => "pinboard", :sent_back => false).delete_all
    update_attribute(:pinboard_token, nil)
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
