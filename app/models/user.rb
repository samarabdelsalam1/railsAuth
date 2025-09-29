class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :authentications, dependent: :destroy
  
  def password_required?
    authentications.empty? && super
  end

  def self.from_omniauth(auth) 
    authentication = Authentication.where(provider: auth.provider, uid: auth.uid).first
    if authentication
      return authentication.user
    else
      user = User.where(email: auth.info.email).first
      if user.nil?
        user = User.create(
          name: auth.info.name,
          email: auth.info.email,
          password: Devise.friendly_token[0, 20]
        )
      end
      user.authentications.create(provider: auth.provider, uid: auth.uid)
      return user
    end
  end
end
