class NationalTransitDatabaseCompany < ActiveRecord::Base
  set_primary_key :id
  set_table_name :ntd_companies
  
  has_many :ntd_records, :foreign_key => 'company_id', :primary_key => 'id', :class_name => 'NationalTransitDatabaseRecord'
  
  def self.rail_companies
    NationalTransitDatabaseRecord.rail_records.map(&:ntd_company).uniq
  end
  
  def rail_records
    ntd_records.where(:mode_code => NationalTransitDatabaseMode.rail_modes)
  end
  
  # Methods to calculate summary statistics from rail_records
  [:rail_passengers, :rail_passenger_distance, :rail_vehicle_distance, :rail_vehicle_time, :rail_electricity, :rail_diesel].each do |method|
    define_method method do
      attribute = method.to_s.split('rail_')[1].to_sym
      rail_records.sum(attribute) > 0 ? rail_records.sum(attribute) : nil 
    end
  end
  
  # Methods to look up units from from rail_records
  [:rail_passenger_distance_units, :rail_vehicle_distance_units, :rail_vehicle_time_units, :rail_electricity_units, :rail_diesel_units].each do |method|
    define_method method do
      attribute = method.to_s.split('rail_')[1].to_sym
      units = rail_records.map(&attribute).uniq
      (units.count == 1 and units[0].present?) ? units[0] : raise("Error: units missing or multiple units in #{name}'s NTD records")
    end
  end
  
  col :id
  col :name
  col :acronym
  col :zip_code_name
  col :duns_number
end
