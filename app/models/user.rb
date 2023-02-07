class User < ApplicationRecord
  before_save :downcase_email, :downcase_username

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  has_secure_password

  validates :name, presence: true
  validates :email,
            format: {
              with: /\S+@\S+/
            },
            uniqueness: {
              case_sensitive: false
            }
  validates :username,
            presence: true,
            format: {
              with: /\A[A-Z0-9]+\z/i
            },
            uniqueness: {
              case_sensitive: false
            }
  validates :password, length: { minimum: 10, allow_blank: true }

  scope :by_name, -> { order(:name) }
  scope :not_admins, -> { by_name.where(admin: false) }

  def gravatar_id
    Digest::MD5.hexdigest(email.downcase)
  end

  def to_param
    username
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def downcase_username
    self.username = username.downcase if username.present?
  end
end
