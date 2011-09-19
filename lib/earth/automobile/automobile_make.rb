class AutomobileMake < ActiveRecord::Base
  set_primary_key :name
  
  has_many :make_years,               :class_name => 'AutomobileMakeYear',             :foreign_key => 'make_name'
  has_many :models,                   :class_name => 'AutomobileMakeModel',            :foreign_key => 'make_name'
  has_many :fleet_years,              :class_name => 'AutomobileMakeFleetYear',        :foreign_key => 'make_name'
  has_many :make_model_year_variants, :class_name => 'AutomobileMakeModelYearVariant', :foreign_key => 'make_name'

  col :name
  col :fuel_efficiency, :type => :float
  col :fuel_efficiency_units
end