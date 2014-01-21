class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bookmarks

  def get_all_bookmarks(current_user)
    get_all_pinboard(current_user)
  end

  def get_all_pinboard(current_user)
    if current_user.pinboard_token != nil
      PinboardApi.auth_token = current_user.pinboard_token
      pins = PinboardApi::Post.all
      bookmark_id = 0
      pins.each do |pin|
        bookmark = Bookmark.new
        bookmark.source = "pinboard"
        bookmark.user_bookmark_id = bookmark_id
        bookmark.url = pin.url.to_s
        bookmark.title = pin.description.to_s
        bookmark.description = pin.extended.to_s
        bookmark.user_id = current_user.id
        bookmark_id += 1
        bookmark.save
      end
    end
  end

  def delete_all_bookmarks(current_user)
    delete_all_pinboard(current_user)
  end

  def delete_all_pinboard(current_user)
    current_user.bookmarks.where(:source => "pinboard").delete_all
    current_user.update_attribute(:pinboard_token, nil)
  end

  def get_random_bookmark(current_user)
    begin random_bookmark = current_user.bookmarks[rand(current_user.bookmarks.length)]
    end until random_bookmark.sent_back == false
    random_bookmark.update_attributes(:sent_back => true, :sent_back_date => DateTime.now)
    random_bookmark
  end

  def send_random_bookmark(current_user)
    m = Mandrill::API.new
    random_bookmark = current_user.get_random_bookmark(current_user)
    message = {
      :subject=> "Your Random Bookmark",
      :from_name=> "Pintage",
      :text=>"Your random pin is #{random_bookmark.url}",
      :to=>[
        {
          :email=> current_user.email
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
