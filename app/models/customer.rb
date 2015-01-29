class Customer < ActiveRecord::Base
  has_many :tickets
  has_many :customers, through: :tickets
end
