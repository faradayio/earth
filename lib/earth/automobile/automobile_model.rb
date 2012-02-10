require 'earth/fuel'
class AutomobileModel < ActiveRecord::Base
  self.primary_key = "name"
  
  col :name
end
