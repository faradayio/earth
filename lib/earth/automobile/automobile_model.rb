require 'earth/fuel'
class AutomobileModel < ActiveRecord::Base
  self.primary_key = "name"
  
  col :name

  warn_unless_size 1991
end
