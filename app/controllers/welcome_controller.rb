class WelcomeController < ApplicationController
  def index
    if current_user
      @sent_bookmarks = User.find(current_user.id).bookmarks.where(sent_back: true).order(sent_back_date: :desc)
    end
  end

  def sign_up_flow
    @new_user_email = params[:email]
    redirect_to new_user_registration_path
  end
end
