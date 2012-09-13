Airline.class_eval do
  # for errata
  class Airline::Guru
    def method_missing(method_id, *args, &block)
      if method_id.to_s =~ /\A(bts)_([^\?]+)/
        args.first['Code'].downcase == $2 # row['Code'] == 'EV'
      else
        super
      end
    end
  end
  
  data_miner do
    import "the BTS unique carrier code lookup table",
           :url => 'http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_UNIQUE_CARRIERS',
           :errata => { :url => "file://#{Earth::ERRATA_DIR}/airline/bts_carrier_codes_errata.csv", :responder => 'Airline::Guru' } do
      key 'name',             :synthesize => proc { |row| row['Description'].split("|")[0] }
      store 'secondary_name', :synthesize => proc { |row| row['Description'].split("|")[1] }
      store 'bts_code', :field_name => 'Code'
    end
  end
end
