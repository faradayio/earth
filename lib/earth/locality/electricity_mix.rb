class ElectricityMix < ActiveRecord::Base
  self.primary_key = :name
  
  falls_back_on :name => 'fallback',
                :co2_emission_factor => 0.623537, # from ecometrica paper FIXME TODO calculate this
                :co2_emission_factor_units => 'kilograms_per_kilowatt_hour',
                :ch4_emission_factor => 0.000208, # from ecometrica paper FIXME TODO calculate this
                :ch4_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour',
                :n2o_emission_factor => 0.002344, # from ecometrica paper FIXME TODO calculate this
                :n2o_emission_factor_units => 'kilograms_co2e_per_kilowatt_hour',
                :loss_factor => 0.096 # from ecometrica paper FIXME TODO calculate this
  
  col :name
  col :egrid_subregion_abbreviation
  col :state_postal_abbreviation
  col :country_iso_3166_code
  col :co2_emission_factor, :type => :float
  col :co2_emission_factor_units
  col :co2_biogenic_emission_factor, :type => :float
  col :co2_biogenic_emission_factor_units
  col :ch4_emission_factor, :type => :float
  col :ch4_emission_factor_units
  col :n2o_emission_factor, :type => :float
  col :n2o_emission_factor_units
  col :loss_factor, :type => :float
  
  warn_unless_size 187
  warn_if_any_nulls
end
