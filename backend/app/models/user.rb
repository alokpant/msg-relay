class User < ApplicationRecord
  has_many :messages

  validates :email, uniqueness: { case_sensitive: false }
end
