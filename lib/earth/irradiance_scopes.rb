module Earth
  module IrradianceScopes
    def self.included(target)
      target.scope :at_lat_lon, lambda { |lat, lon|
        target.where('nw_lat > ? AND nw_lon > ? AND se_lat < ? AND se_lon < ?', lat, lon, lat, lon)
      }
      target.scope :at_zip, lambda { |zip| target.at_lat_lon(zip.latitude, zip.longitude) }
    end
  end
end
