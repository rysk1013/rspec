class Comment < ApplicationRecord
  belogns_to :post
  belongs_to :user
end
