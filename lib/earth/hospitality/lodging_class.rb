require 'earth/locality'
class LodgingClass < ActiveRecord::Base
  self.primary_key = :name
  
  col :name
end
