class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :sponsored_post
end
