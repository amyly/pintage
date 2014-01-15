class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bookmarks

  def get_all_pins(current_user)
    if current_user.pinboard_token != nil
      bookmark_id = 0
      PinboardApi.auth_token = current_user.pinboard_token
      pins = PinboardApi::Post.all
      pins.each do |pin|
        bookmark = Bookmark.new
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
end
