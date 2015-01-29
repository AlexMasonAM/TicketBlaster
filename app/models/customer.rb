# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  address    :string
#

class Customer < ActiveRecord::Base
  has_many :tickets
  has_many :events, through: :tickets
end
