class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bookmarks
  validates :pinboard_token, format: { with: /[a-z0-9]+\:[A-Z0-9]{20}/, message: "Needs to follow Pinboard token format" }

  def get_all_bookmarks(user)
    get_all_pinboard(user)
  end

  def get_all_pinboard(user)
    if user.pinboard_token != nil
      PinboardApi.auth_token = user.pinboard_token
      pins = PinboardApi::Post.all
      bookmark_id = 0
      pins.each do |pin|
        bookmark = Bookmark.new
        bookmark.source = "pinboard"
        bookmark.user_bookmark_id = bookmark_id
        bookmark.url = pin.url.to_s
        bookmark.title = pin.description.to_s
        bookmark.description = pin.extended.to_s
        bookmark.user_id = user.id
        bookmark_id += 1
        bookmark.save
      end
    end
  end

  def delete_all_bookmarks(user)
    delete_all_pinboard(user)
  end

  def delete_all_pinboard(user)
    user.bookmarks.where(:source => "pinboard", :sent_back => false).delete_all
    user.update_attribute(:pinboard_token, nil)
  end

  def get_random_bookmark(user)
    begin random_bookmark = user.bookmarks[rand(user.bookmarks.length)]
    end until random_bookmark.sent_back == false
    random_bookmark.update_attributes(:sent_back => true, :sent_back_date => DateTime.now)
    random_bookmark
  end

  def self.send_random_bookmarks
    User.find_each do |user|
      m = Mandrill::API.new
      random_bookmark = user.get_random_bookmark(user)
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
