class Customer < ApplicationRecord
  has_secure_password

  has_many :orders
  has_many :sessions, as: :account, dependent: :destroy

  before_validation :normalize_email

  validates :last_name,
            :first_name,
            :last_name_kana,
            :first_name_kana,
            :postal_code,
            :address,
            :telephone_number,
            presence: true

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,
            length: { minimum: 6 },
            allow_nil: true

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
