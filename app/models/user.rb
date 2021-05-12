class User < ApplicationRecord
  has_many :posts

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # パスワード→半角英数字混合
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  validates_format_of :password, {with: PASSWORD_REGEX}

  validates :nickname, presence: true, uniqueness: true

  # ユーザーの名前→全角（漢字・ひらがな・カタカナ）
  with_options presence: true, format: {with: /\A[ぁ-んァ-ヶ一-龥々]+\z/} do
    validates :last_name
    validates :first_name
  end

  # ユーザーの名前のふりがな→全角（カタカナ）
  with_options presence: true, format: {with: /\A[ァ-ヶ一]+\z/} do
    validates :last_name_kana
    validates :first_name_kana
  end

  with_options presence: true do
    validates :birthday
    validates :accepted, acceptance: true
  end
end
