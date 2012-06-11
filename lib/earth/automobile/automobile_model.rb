class AutomobileModel < ActiveRecord::Base
  self.primary_key = "name"
  
  col :name

  warn_unless_size 2299
end
