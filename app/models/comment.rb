class Comment < ApplicationRecord

  validates :message, presence: true

  belongs_to :gram
  belongs_to :user

end
