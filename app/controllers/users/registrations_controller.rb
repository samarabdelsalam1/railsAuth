# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    welcome_path
  end

  private

  # If you have extra params to permit, append them to the sanitizer.
  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name)
  end
end
