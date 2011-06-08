class Airport < ActiveRecord::Base
  set_primary_key :iata_code
  
  belongs_to :country, :foreign_key => 'country_iso_3166_code', :primary_key => 'iso_3166_code'
  
  acts_as_mappable :default_units => :nms,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  create_table do
    string   'iata_code'
    string   'name'
    string   'city'
    string   'country_name'
    string   'country_iso_3166_code'
    float    'latitude'
    float    'longitude'
  end
end
