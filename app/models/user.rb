class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :authentications, dependent: :destroy
  
    def password_required?
      authentications.empty? && super
    end

def self.from_omniauth(auth)
    authentication = Authentication.find_by(provider: auth.provider, uid: auth.uid)

    if authentication
      authentication.user
    else
      user = User.find_or_create_by(email: auth.info.email) do |u|
        u.password = Devise.friendly_token[0, 20]
        u.name = auth.info.name
      end

      user.authentications.create(
        provider: auth.provider,
        uid: auth.uid
      )

      user
    end
  end

end
