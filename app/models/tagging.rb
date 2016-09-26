class Tagging < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :tag
end
