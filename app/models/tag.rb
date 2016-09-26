class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :tickets, through: :taggings
end
