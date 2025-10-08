module Users
  class OmniauthService
    def initialize(auth)
      @auth = auth
    end

    def call
      find_or_create_user
    end

    attr_reader :auth

    private

    def find_or_create_user
      authentication = Authentication.find_by(provider: auth.provider, uid: auth.uid)
      return authentication.user if authentication

      user = User.find_by(email: auth.info.email)

      if user
        user.authentications.create(provider: auth.provider, uid: auth.uid)
      else
        user = create_user_from_auth
      end

      user
    end

    def create_user_from_auth
        User.create(
            email: auth.info.email,
            password: Devise.friendly_token[0, 20]
        ).tap do |new_user|
            new_user.authentications.create(
            provider: auth.provider,
            uid: auth.uid
            )
        end
    end
  end
end
