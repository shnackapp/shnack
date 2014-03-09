# == Schema Information
#
# Table name: hours
#
#  id           :integer          not null, primary key
#  opening_time :time
#  closing_time :time
#  day          :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Hour < ActiveRecord::Base
  attr_accessible :closing_time, :opening_time, :day
end
