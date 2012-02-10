require 'earth/locality'
# Copyright 2011 Brighter Planet, Inc.
class LodgingProperty < ActiveRecord::Base
  self.primary_key = "northstar_id"
  
  # So Lodging can look up LodgingClass from LodgingProperty
  belongs_to :lodging_class, :foreign_key => 'lodging_class_name'
  
  col :northstar_id
  col :name
  col :city
  col :locality # state / province / etc.
  col :postcode # zip code / postal code / etc.
  col :country_iso_3166_alpha_3_code
  col :chain_name
  col :lodging_rooms,     :type => :integer
  col :floors,            :type => :integer
  col :construction_year, :type => :integer
  col :renovation_year,   :type => :integer
  col :lodging_class_name
  col :restaurants,       :type => :integer
  col :ac_coverage,       :type => :float
  col :mini_bar_coverage, :type => :float
  col :fridge_coverage,   :type => :float
  col :hot_tubs,          :type => :float # float b/c fallback needs to be a float
  col :pools_indoor,      :type => :float # float b/c fallback needs to be a float
  col :pools_outdoor,     :type => :float # float b/c fallback needs to be a float
  col :update_date
end
