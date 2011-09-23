class AutomobileMakeYear < ActiveRecord::Base
  set_primary_key :name
  
  belongs_to :make,      :class_name => 'AutomobileMake',          :foreign_key => 'make_name'
  has_many :fleet_years, :class_name => 'AutomobileMakeFleetYear', :foreign_key => 'make_year_name'

  col :name
  col :make_name
  col :year, :type => :integer
  col :fuel_efficiency, :type => :float
  col :fuel_efficiency_units
  col :volume, :type => :integer # This will sometimes be null because not all make_years have CAFE data
  
  # FIXME TODO verify make_name and volume?
  
  # verify "Fuel efficiency should be greater than zero" do
  #   if violator = first(:conditions => ['fuel_efficiency IS NULL OR fuel_efficiency <= 0'])
  #     raise "Invalid fuel efficiency for AutomobileMakeYear #{record.name}: #{record.fuel_efficiency} (should be > 0)"
  #   end
  #   true
  # end
end
