
class AccountsController < ApplicationController
  def add_pocket
    current_user.add_pocket_token(env["omniauth.auth"])
    if current_user.pocket_token
        current_user.get_all_pocket
    end
    redirect_to edit_user_registration_path, notice: "Your Pocket account has been added."
  end
  # def get_request_token
  #   uri = URI.parse("https://getpocket.com")
  #   http = Net::HTTP.new(uri.host, uri.port)
  #   http.use_ssl = true
  #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  #   request = Net::HTTP::Post.new("/v3/oauth/request")
  #   request.add_field('Content-Type', 'application/json')
  #   request.body = {'consumer_key' => '23418-8df24647622fb124d6f83319', 'redirect_uri' => 'http://localhost:3000'}.to_json
  #   response = http.request(request)
  #   @pocket_request_token = response.body.match( /^code=(.*)$/ )[1].to_s
  #   redirect_to 'https://getpocket.com/auth/authorize?request_token=' + @pocket_request_token + '&redirect_uri=http://localhost:3000/auth/pocket/callback'
  # end

  # def get_access_token
  #   uri = URI.parse("https://getpocket.com")
  #   http = Net::HTTP.new(uri.host, uri.port)
  #   http.use_ssl = true
  #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  #   request = Net::HTTP::Post.new("/v3/oauth/authorize")
  #   request.add_field('Content-Type', 'application/json')
  #   request.body = {'consumer_key' => '23418-8df24647622fb124d6f83319', 'code' => @pocket_request_token}.to_json
  #   response = http.request(request)
  #   @test = JSON.parse(response.body)
  #   # redirect_to root_url
  # end

end
