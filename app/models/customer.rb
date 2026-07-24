class Customer < ApplicationRecord
  has_secure_password

  has_many :sessions, as: :account, dependent: :destroy

  has_many :cart_items, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :orders

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
  
  validates :last_name,
          :first_name,
          format: {
            with: /\A[^0-9０-９]+\z/,
            message: "には数字を入力できません"
          }
          
  validates :last_name_kana, :first_name_kana,
            format: {
            with: /\A[ァ-ヶー]+\z/,
            message: "は全角カタカナで入力してください"
            }

  validates :postal_code,
            format: {
            with: /\A\d{7}\z/,
            message: "は7桁の数字で入力してください"
            }

  validates :telephone_number,
            format: {
            with: /\A\d+\z/,
            message: "は数字のみ入力してください"
            }

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
