class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def require_sign_in
    unless current_user
      flash[:alert] = "You must be logged in to do that"

      redirect_to new_session_path
    end
  end


  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48"
  end

end
