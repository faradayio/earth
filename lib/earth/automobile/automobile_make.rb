class AutomobileMake < ActiveRecord::Base
  set_primary_key :name
  
  has_many :make_years,   :class_name => 'AutomobileMakeYear',      :foreign_key => 'make_name'
  has_many :models,       :class_name => 'AutomobileModel',         :foreign_key => 'make_name'
  has_many :fleet_years,  :class_name => 'AutomobileMakeFleetYear', :foreign_key => 'make_name'
  has_many :variants,     :class_name => 'AutomobileVariant',       :foreign_key => 'make_name'
  
  scope :major, :conditions => { :major => true }, :order => :name

  data_miner do
    tap "Brighter Planet's make year data", Earth.taps_server
  end
end
