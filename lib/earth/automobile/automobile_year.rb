require 'earth/fuel'
class AutomobileYear < ActiveRecord::Base
  set_primary_key :year
  
  col :year, :type => :integer
end
