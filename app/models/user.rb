class User < ApplicationRecord
  attr_accessor :remember_token
  has_secure_password # uses bcrypt to hash password
  before_create :remember, only: [:new, :create]
  has_many :posts

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true



  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(string)
    Digest::SHA1.hexdigest(string)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    Digest::SHA1.hexdigest(remember_digest).is_password?(remember_token)
  end

  # Forgets user
  def forget
    update_attribute(:remember_digest, nil)
  end


end
