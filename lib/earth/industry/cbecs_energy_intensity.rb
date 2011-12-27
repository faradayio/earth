require 'earth/locality'
class CbecsEnergyIntensity < ActiveRecord::Base
  col :naics_code, :type => :string
  col :census_division_number, :type => :integer
  col :total_electricity_consumption, :type => :float
  col :total_floorspace, :type => :float
  col :electricity_intensity, :type => :float

  CENSUS_DIVISIONS = {
    'New England Division' => {
      :column => 0,
      :code => 1,
      :table => 'c17'
    },
    'Middle Atlantic Division' => {
      :column => 1,
      :code => 2,
      :table => 'c17'
    },
    'East North Central Division' => {
      :column => 2,
      :code => 3,
      :table => 'c17'
    },
    'West North Central Division' => {
      :column => 0,
      :code => 4,
      :table => 'c18'
    },
    'South Atlantic Division' => {
      :column => 1,
      :code => 5,
      :table => 'c18'
    },
    'East South Central Division' => {
      :column => 2,
      :code => 6,
      :table => 'c18'
    },
    'West South Central Division' => {
      :column => 0,
      :code => 7,
      :table => 'c19'
    },
    'Mountain Division' => {
      :column => 1,
      :code => 8,
      :table => 'c19'
    },
    'Pacific Division' => {
      :column => 2,
      :code => 9,
      :table => 'c19'
    }
  }
end
