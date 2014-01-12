class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bookmarks

  # def get_pinboard_token(user)
  #   uri = URI.parse('https://api.pinboard.in/v1/user/api_token/')
  #   req = Net::HTTP::Get.new uri
  #   res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') { |http| http.request req}
  #   if res = Net::HTTPUnauthorized
  #     "boo"
  #   else
  #     pinboard_token = Nokogiri::Slop(res.body)
  #     user.pinboard_token = pinboard_token.result.content
  #   end
  # end
end
