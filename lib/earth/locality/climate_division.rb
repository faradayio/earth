class ClimateDivision < ActiveRecord::Base
  set_primary_key :name
  
  has_many :zip_codes, :foreign_key => 'climate_division_name'
  belongs_to :state, :foreign_key => 'state_postal_abbreviation'
  
  RADIUS = 750

  create_table do
    string   'name'
    float    'heating_degree_days'
    float    'cooling_degree_days'
    string   'state_postal_abbreviation'
  end
end
