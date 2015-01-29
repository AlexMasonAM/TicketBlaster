class Customer < ActiveRecord::Base
  has_many :tickets
  has_many :events, through: :tickets
end
