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
  attr_accessible :closing_time, :opening_time, :day, :hours

  def opening_hour
    self.opening_time[0..1].to_i
  end

  def opening_min
    self.opening_time[2..3].to_i
  end

  def closing_hour
    self.closing_time[0..1].to_i
  end

  def closing_min
    self.closing_time[2..3].to_i
  end

  def self.monday
  	1
  end

  def self.tuesday
  	2
  end

  def self.wednesday
  	3
  end

  def self.thursday
  	4
  end

  def self.friday
  	5
  end

  def self.saturday
  	6
  end

  def self.sunday
  	0
  end

end
