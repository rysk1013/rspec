class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :likes

  validates :text, presence: true, length: {maximum: 140}
end
