# == Schema Information
#
# Table name: tickets
#
#  id          :integer          not null, primary key
#  seat        :string
#  customer_id :integer
#  event_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cost        :float
#  section     :string
#

class Ticket < ActiveRecord::Base
  belongs_to :customer
  belongs_to :event
end
