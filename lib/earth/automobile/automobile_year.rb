require 'earth/fuel'
class AutomobileYear < ActiveRecord::Base
  self.primary_key = :year
  
  col :year, :type => :integer
end
