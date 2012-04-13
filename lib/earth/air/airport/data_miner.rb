require 'earth/locality/data_miner'

Airport.class_eval do
  class Airport::Guru
    def method_missing(method_id, *args, &block)
      if method_id.to_s =~ /\A(id|iata)_is_([a-z]{3}|\d{1,4})\?$/
        regexp = Regexp.new($2, Regexp::IGNORECASE)
        if $1 == "iata"
          args.first['iata_code'] =~ regexp # row['iata_code'] =~ /meh/i
        else
          args.first[$1] =~ regexp # row['id'] =~ /1234/i
        end
      else
        super
      end
    end
  end
  
  def self.countries_dictionary
    @countries_dictionary ||= ::FuzzyMatch.new Country.all, :read => :name
  end
  
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    process "Ensure Country is populated" do
      Country.run_data_miner!
    end
    
    import "the OpenFlights.org airports database",
           :url => 'https://openflights.svn.sourceforge.net/svnroot/openflights/openflights/data/airports.dat',
           :headers => %w{ id name city country_name iata_code icao_code latitude longitude altitude timezone daylight_savings },
           :select => lambda { |record| record['iata_code'].present? },
           :errata => { :url => "file://#{Earth.errata_dir}/airport/openflights_errata.csv",
                        :responder => Airport::Guru.new } do
      key 'iata_code'
      store 'name'
      store 'city'
      store 'country_name', :synthesize => proc { |row| Airport.countries_dictionary.find(row['country_name'], :must_match_at_least_one_word => true).try(:name) }
      store 'latitude'
      store 'longitude'
    end
    
    import "airports missing from the OpenFlights.org database",
           :url => 'https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHpyR3NudEl5V21ZcEdXQXFDNU8zTWc&output=csv' do
      key 'iata_code'
      store 'name'
      store 'city'
      store 'country_name'
      store 'latitude'
      store 'longitude'
    end
    
    process "Fill in blank country codes" do
      Country.find_each do |country|
        next unless country.name.present? and country.iso_3166_code.present?
        where(:country_name => country.name).update_all :country_iso_3166_code => country.iso_3166_code
      end
    end
  end
end
