require 'earth/model'

require 'earth/rail/national_transit_database_mode'
require 'earth/rail/national_transit_database_record'

class NationalTransitDatabaseCompany < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE ntd_companies
  (
     id            CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     name          CHARACTER VARYING(255),
     acronym       CHARACTER VARYING(255),
     zip_code_name CHARACTER VARYING(255),
     duns_number   CHARACTER VARYING(255)
  );

EOS

  self.primary_key = "id"
  self.table_name = :ntd_companies
  
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
      (sum = rail_records.sum(method.to_s.split('rail_')[1].to_sym)) > 0 ? sum : nil
    end
  end
  
  # Methods to look up units from from rail_records
  # TODO this looks inefficient
  [:rail_passenger_distance_units, :rail_vehicle_distance_units, :rail_vehicle_time_units, :rail_electricity_units, :rail_diesel_units].each do |method|
    define_method method do
      attribute = method.to_s.split('rail_')[1].to_sym
      units = rail_records.map(&attribute).uniq.compact
      (units.length == 1 and units[0].present?) ? units[0] : raise("Error: units missing or multiple units in #{name}'s NTD records")
    end
  end
  
  warn_if_nulls_except(
    :acronym,
    :duns_number
  )

  warn_unless_size 710
end
