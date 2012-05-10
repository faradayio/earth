require 'earth/locality'

class ElectricMarket < ActiveRecord::Base
  self.primary_key = "id" # string
  
  belongs_to :electric_utility, :foreign_key => 'electric_utility_eia_id'
  belongs_to :zip_code, :foreign_key => 'zip_code_name'
  
  col :id
  col :electric_utility_eia_id, :type => :integer
  col :zip_code_name
end
