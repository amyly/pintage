class AccountsController < ApplicationController
  def add_pocket
    current_user.add_pocket_token(env["omniauth.auth"])
    if current_user.pocket_token
        current_user.get_all_pocket
    end
    redirect_to edit_user_registration_path, notice: "Your Pocket account has been added."
  end
end
