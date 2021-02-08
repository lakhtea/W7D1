class User < ApplicationRecord
    attr_reader :password

    validates :session_token, :user_name, presence: true, uniqueness: true
    validates :password, length: { minimum: 6, allow_nil: true, message: "Password must be at least 6 characters"}
    validates :password_digest, presence: { message: "Password can't be blank" }

    after_initialize do |user|
        user.session_token ||= SecureRandom::urlsafe_base64(16)
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        password_object = BCrypt::Password.new(self.password_digest)

        password_object.is_password?(password)
    end

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64(16)
        self.save!
        self.session_token
    end

    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)
        if user && user.is_password?(password)
            return user
        else
            nil
        end
    end

    has_many :cats, foreign_key: :user_id
end
