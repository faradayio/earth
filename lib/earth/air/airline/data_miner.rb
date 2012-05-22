Airline.class_eval do
  # for errata
  class Airline::Guru
    def not_expressjet?(row)
      not row['Description'] =~ /expressjet/i
    end
  end
  
  data_miner do
    process "Start from scratch" do
      delete_all
    end
    
    import "the BTS unique carrier code lookup table",
           :url => 'http://www.transtats.bts.gov/Download_Lookup.asp?Lookup=L_UNIQUE_CARRIERS',
           :errata => { :url => "file://#{Earth::ERRATA_DIR}/airline/bts_carrier_codes_errata.csv", :responder => 'Airline::Guru' } do
      key 'name',             :synthesize => proc { |row| row['Description'].split("|")[0] }
      store 'secondary_name', :synthesize => proc { |row| row['Description'].split("|")[1] }
      store 'bts_code', :field_name => 'Code'
    end
    
    import "a Brighter Planet-curated list of airlines and codes not included in our proprietary sources",
           :url => 'https://spreadsheets.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdGJoaFpENXRqMEM2NW42am5tNURGU2c&output=csv' do
      key 'name'
      store 'secondary_name', :nullify => true
      store 'iata_code',      :nullify => true
      store 'icao_code',      :nullify => true
    end
  end
end
