require 'earth/locality/data_miner'
CommercialBuildingEnergyConsumptionSurveyResponse.class_eval do
  data_miner do
    import 'building characteristics from the 2003 EIA CBECS - part 1',
           :url => 'http://www.eia.gov/emeu/cbecs/cbecs2003/public_use_2003/data/FILE01.csv',
           :skip => 1,
           :headers => ["PUBID8", "REGION8", "CENDIV8", "SQFT8", "SQFTC8", "YRCONC8", "PBA8", "ELUSED8", "NGUSED8", "FKUSED8", "PRUSED8", "STUSED8", "HWUSED8", "CLIMATE8", "FREESTN8", "WLCNS8", "RFCNS8", "GLSSPC8", "EQGLSS8", "SUNGLS8", "BLDSHP8", "NFLOOR8", "ELEVTR8", "NELVTR8", "ESCLTR8", "NESLTR8", "YRCON8", "MONCON8", "RENOV8", "RENADD8", "RENRDC8", "RENCOS8", "RENEXT8", "RENINT8", "RENHVC8", "RENLGT8", "RENWIN8", "RENPLB8", "RENINS8", "RENOTH8", "GOVOWN8", "GOVTYP8", "OWNER8", "OWNOCC8", "NOCC8", "NOCCAT8", "MONUSE8", "PORVAC8", "OPEN248", "OPNMF8", "OPNWE8", "WKHRS8", "WKHRSC8", "NWKER8", "NWKERC8", "HT18", "HT28", "COOL8", "WATR8", "COOK8", "MANU8", "GENR8", "ADJWT8", "STRATUM8", "PAIR8"] do
      key 'id', :field_name => 'PUBID8'
      store 'census_region_number',   :field_name => 'REGION8'
      store 'census_division_number', :field_name => 'CENDIV8'
      store 'climate_zone_number',    :synthesize => Proc.new { |row| row['CLIMATE8'].to_i == 7 ? nil : row['CLIMATE8'].to_i }
      store 'area',                   :field_name => 'SQFT8',   :from_units => :square_feet, :to_units => :square_metres
      store 'principal_activity',     :field_name => 'PBA8',    :dictionary => { :input => 'principal_activity_code', :output => 'principal_activity', :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdHRGVHczYXRoU2dFLV90aDdET0dQLUE&single=true&gid=2&output=csv' }
      store 'floors',                 :field_name => 'NFLOOR8', :dictionary => { :input => 'floors_code', :output => 'floors', :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdHRGVHczYXRoU2dFLV90aDdET0dQLUE&single=true&gid=0&output=csv' }
      store 'construction_year',      :field_name => 'YRCON8'
      store 'months_used',            :field_name => 'MONUSE8'
      store 'weekly_hours',           :field_name => 'WKHRS8'
      store 'stratum',                :field_name => 'STRATUM8'
      store 'pair',                   :field_name => 'PAIR8'
      store 'weighting',              :field_name => 'ADJWT8'
    end
    
    import 'building characteristics from the 2003 EIA CBECS - part 2',
           :url => 'http://www.eia.gov/emeu/cbecs/cbecs2003/public_use_2003/data/FILE02.csv',
           :skip => 1,
           :headers => ["PUBID8","REGION8","CENDIV8","SQFT8","SQFTC8","YRCONC8","PBA8","ELUSED8","NGUSED8","FKUSED8","PRUSED8","STUSED8","HWUSED8","ONEACT8","ACT18","ACT28","ACT38","ACT1PCT8","ACT2PCT8","ACT3PCT8","PBAPLUS8","VACANT8","RWSEAT8","PBSEAT8","EDSEAT8","FDSEAT8","HCBED8","NRSBED8","LODGRM8","FACIL8","FEDFAC8","FACACT8","MANIND8","PLANT8","FACDST8","FACDHW8","FACDCW8","FACELC8","BLDPLT8","ADJWT8","STRATUM8","PAIR8"] do
      key 'id', :field_name => 'PUBID8'
      store 'detailed_activity',     :field_name => 'PBAPLUS8', :dictionary => { :input => 'detailed_activity_code', :output => 'detailed_activity', :url => 'https://docs.google.com/spreadsheet/pub?&key=0AoQJbWqPrREqdHRGVHczYXRoU2dFLV90aDdET0dQLUE&single=true&gid=3&output=csv' }
      store 'first_activity',        :field_name => 'ACT18',    :dictionary => { :input => 'activity_code', :output => 'activity', :url => 'https://docs.google.com/spreadsheet/pub?&key=0AoQJbWqPrREqdHRGVHczYXRoU2dFLV90aDdET0dQLUE&single=true&gid=4&output=csv' }
      store 'second_activity',       :field_name => 'ACT28',    :dictionary => { :input => 'activity_code', :output => 'activity', :url => 'https://docs.google.com/spreadsheet/pub?&key=0AoQJbWqPrREqdHRGVHczYXRoU2dFLV90aDdET0dQLUE&single=true&gid=4&output=csv' }
      store 'third_activity',        :field_name => 'ACT38',    :dictionary => { :input => 'activity_code', :output => 'activity', :url => 'https://docs.google.com/spreadsheet/pub?&key=0AoQJbWqPrREqdHRGVHczYXRoU2dFLV90aDdET0dQLUE&single=true&gid=4&output=csv' }
      store 'first_activity_share',  :synthesize => Proc.new { |row| row['ACT1PCT8'].blank? ? nil : row['ACT1PCT8'].to_f / 100.0 }
      store 'second_activity_share', :synthesize => Proc.new { |row| row['ACT2PCT8'].blank? ? nil : row['ACT2PCT8'].to_f / 100.0 }
      store 'third_activity_share',  :synthesize => Proc.new { |row| row['ACT3PCT8'].blank? ? nil : row['ACT3PCT8'].to_f / 100.0 }
      store 'lodging_rooms',         :field_name => 'LODGRM8'
    end
    
    import 'building characteristics from the 2003 EIA CBECS - part 3',
           :url => 'http://www.eia.gov/emeu/cbecs/cbecs2003/public_use_2003/data/FILE03.csv',
           :skip => 1,
           :headers => ["PUBID8","REGION8","CENDIV8","SQFT8","SQFTC8","YRCONC8","PBA8","ELUSED8","NGUSED8","FKUSED8","PRUSED8","STUSED8","HWUSED8","HEATP8","HTLS508","FURNAC8","BOILER8","PKGHT8","SLFCON8","HTPMPH8","STHW8","OTHTEQ8","FURNP8","BOILP8","PKGHP8","SLFCNP8","HTPHP8","STHWP8","OTHTP8","MAINHT8","PKGHPS8","SPLHPS8","RMHPS8","AIRHPT8","GRDHPT8","WTRHPT8","NWMNHT8","RDHTNF8","HWRDHT8","COOLP8","PKGCL8","RCAC8","ACWNWL8","HTPMPC8","CHWT8","CHILLR8","EVAPCL8","OTCLEQ8","PKGCP8","RCACP8","ACWNWP8","HTPCP8","CHWTP8","CHILP8","EVAPP8","OTCLP8","MAINCL8","PKGCPS8","SPLCPS8","RMCPS8","AIRCPT8","GRDCPT8","WTRCPT8","NWMNCL8","RDCLNF8","HWRDCL8","VAV8","ECN8","MAINT8","EMCS8","ADJWT8","STRATUM8","PAIR8"] do
      key 'id', :field_name => 'PUBID8'
      store 'percent_cooled', :synthesize => Proc.new { |row| row['COOLP8'].to_f / 100.0 }
    end
    
    import 'electricity use from the 2003 EIA CBECS',
           :url => 'http://www.eia.gov/emeu/cbecs/cbecs2003/public_use_2003/data/FILE15.csv',
           :skip => 1,
           :headers => ["PUBID8", "REGION8", "CENDIV8", "SQFT8", "SQFTC8", "YRCONC8", "PBA8", "ELUSED8", "NGUSED8", "FKUSED8", "PRUSED8", "STUSED8", "HWUSED8", "ADJWT8", "STRATUM8", "PAIR8", "HDD658", "CDD658", "MFUSED8", "MFBTU8", "MFEXP8", "ELCNS8", "ELBTU8", "ELEXP8", "ZELCNS8", "ZELEXP8"] do
      key 'id', :field_name => 'PUBID8'
      store 'heating_degree_days', :field_name => 'HDD658', :from_units => :degrees_fahrenheit, :to_units => :degrees_celsius
      store 'cooling_degree_days', :field_name => 'CDD658', :from_units => :degrees_fahrenheit, :to_units => :degrees_celsius
      store 'electricity_use',     :synthesize => Proc.new { |row| row['ELCNS8'].to_i }, :units => :kilowatt_hours
      store 'electricity_energy',  :field_name => 'ELBTU8', :from_units => :kbtus, :to_units => :megajoules
    end
    
    import 'fuel use characteristics from the 2003 EIA CBECS',
           :url => 'http://www.eia.gov/emeu/cbecs/cbecs2003/public_use_2003/data/FILE16.csv',
           :skip => 1,
           :headers => ["PUBID8", "REGION8", "CENDIV8", "SQFT8", "SQFTC8", "YRCONC8", "PBA8", "ELUSED8", "NGUSED8", "FKUSED8", "PRUSED8", "STUSED8", "HWUSED8", "ADJWT8", "STRATUM8", "PAIR8", "NGCNS8", "NGBTU8", "NGEXP8", "ZNGCNS8", "ZNGEXP8", "FKCNS8", "FKBTU8", "FKEXP8", "ZFKCNS8", "ZFKEXP8", "DHUSED8", "DHHT18", "DHHT28", "DHCOOL8", "DHWATR8", "DHCOOK8", "DHMANU8", "DHOTH8", "DHCNS8", "DHBTU8", "DHEXP8", "ZDHCNS8", "ZDHEXP8"] do
      key 'id', :field_name => 'PUBID8'
      store 'natural_gas_use',      :field_name => 'NGCNS8', :from_units => :hundred_cubic_feet, :to_units => :cubic_metres
      store 'natural_gas_energy',   :field_name => 'NGBTU8', :from_units => :kbtus,              :to_units => :megajoules
      store 'fuel_oil_use',         :field_name => 'FKCNS8', :from_units => :gallons,            :to_units => :litres
      store 'fuel_oil_energy',      :field_name => 'FKBTU8', :from_units => :kbtus,              :to_units => :megajoules
      store 'district_heat_use',    :field_name => 'DHBTU8', :from_units => :kbtus,              :to_units => :megajoules
    end
    
    process "Derive fuel intensities per room night for lodging buildings" do
      # days/year * weeks/day * years/month = weeks/month
      # weeks/month * months used in a year = weeks used in a year
      # weeks used in a year * hours/week = hours used in a year
      # hours used in a year * days/hour = days used in a year
      [:natural_gas, :fuel_oil, :electricity, :district_heat].each do |fuel|
        lodging_records.update_all %{
          #{fuel}_per_room_night = #{fuel}_use / (365.0 / 7.0 / 12.0 * months_used * weekly_hours / 24.0 * lodging_rooms),
          #{fuel}_per_room_night_units = #{fuel}_use_units || '_per_room_night'
        }
      end
    end
    
    process "Derive fuel intensities per unit area" do
      [:natural_gas, :fuel_oil, :electricity].each do |fuel|
        update_all %{
          #{fuel}_energy_intensity = #{fuel}_energy / area,
          #{fuel}_energy_intensity_units = 'megajoules_per_square_metre'
        }
        update_all %{
          district_heat_energy_intensity = district_heat_use / area,
          district_heat_energy_intensity_units = 'megajoules_per_square_metre'
        }
      end
    end
  end
end
