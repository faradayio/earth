require 'earth/eia'
require 'earth/industry'
require 'earth/locality/data_miner'

CbecsEnergyIntensity.class_eval do
  const_set(:CENSUS_REGIONS, {
    1 => {
      'New England Division' => {
        :column => 0,
        :census_division => 1,
        :table => {
          :electricity => 'c17',
          :natural_gas => 'c27'
        }
      },
      'Middle Atlantic Division' => {
        :column => 1,
        :census_division => 2,
        :table => {
          :electricity => 'c17',
          :natural_gas => 'c27'
        }
      }
    },
    2 => {
      'East North Central Division' => {
        :column => 2,
        :census_division => 3,
        :table => {
          :electricity => 'c17',
          :natural_gas => 'c27'
        }
      },
      'West North Central Division' => {
        :column => 0,
        :census_division => 4,
        :table => {
          :electricity => 'c18',
          :natural_gas => 'c28'
        }
      }
    },
    3 => {
      'South Atlantic Division' => {
        :column => 1,
        :census_division => 5,
        :table => {
          :electricity => 'c18',
          :natural_gas => 'c28'
        }
      },
      'East South Central Division' => {
        :column => 2,
        :census_division => 6,
        :table => {
          :electricity => 'c18',
          :natural_gas => 'c28'
        }
      },
      'West South Central Division' => {
        :column => 0,
        :census_division => 7,
        :table => {
          :electricity => 'c19',
          :natural_gas => 'c29'
        }
      }
    },
    4 => {
      'Mountain Division' => {
        :column => 1,
        :census_division => 8,
        :table => {
          :electricity => 'c19',
          :natural_gas => 'c29'
        }
      },
      'Pacific Division' => {
        :column => 2,
        :census_division => 9,
        :table => {
          :electricity => 'c19',
          :natural_gas => 'c29'
        }
      }
    }
  })

  const_set(:NAICS_CODE_SYNTHESIZER, lambda { |row|
    case row[0].to_s
    when /Education/
      61
    when /Food Sales/
      445
    when /Food Service/
      722
    when /Health Care/
      62 # FIXME TODO should only be 621 and 622
    when /Inpatient/
      622
    when /Outpatient/
      621
    when /Lodging/
      721 # FIXME TODO should really be 623, 62422, 721, maybe 8131
    when /Retail \(Other Than Mall\)/
      44 # FIXME TODO should really be 44 and 45 excluding 445 and 454
    when /Office/
      55 # Management of Companies and Enterprises FIXME TODO should be all NAICS codes that identify an office
    when /Public Assembly/
      #TODO
    when /Public Order and Safety/
      922
    when /Religious Worship/
      8131
    when /Service/
      81 # other services (except public administration) FIXME TODO exclude 8131 and include all NAICS codes that are services
    when /Warehouse and Storage/
      493
    when /Other/
      #TODO
    when /Vacant/
      #TODO
    end
  })

  data_miner do
    CbecsEnergyIntensity::CENSUS_REGIONS.each do |region, divisions|
      divisions.each do |division, data|
        import "2003 CBECS #{data[:table][:electricity].upcase} - Electricity Consumption and Intensity - #{division}",
          :url => "http://www.eia.gov/emeu/cbecs/cbecs2003/detailed_tables_2003/2003set10/2003excel/#{data[:table][:electricity]}.xls",
          :headers => false,
          :select => Proc.new { |row| CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row) }, # only select rows where we can translate activity to a NAICS code
          :crop => (21..37) do
          key :name, :synthesize => Proc.new { |row|
            "#{Industry.format_naics_code(CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row))}-#{region}-#{data[:census_division]}"
          }
          store :principal_building_activity, :synthesize => Proc.new { |row| row[0].gsub(/[\.\(\)]/,'').trim }
          store :naics_code, :synthesize => CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER
          store :census_region_number, :static => region
          store :census_division_number, :static => data[:census_division]
          store :electricity, :units => :kilowatt_hours, :synthesize => Proc.new { |row|
            Earth::EIA.convert_value(row[data[:column] + 1], :from => :billion_kwh, :to => :kilowatt_hours)
          }
          store :electricity_floorspace, :units => :square_metres, :synthesize => Proc.new { |row|
            Earth::EIA.convert_value(row[data[:column] + 4], :from => :million_square_feet, :to => :square_metres)
          }
          store :electricity_intensity, :units => :kilowatt_hours_per_square_metre, :synthesize => Proc.new { |row|
            Earth::EIA.convert_value(row[data[:column] + 7], :from => :kilowatt_hours_per_square_foot, :to => :kilowatt_hours_per_square_metre)
          }
        end

        import "2003 CBECS #{data[:table][:natural_gas].upcase} - Natural Gas Consumption and Intensity - #{division}",
          :url => "http://www.eia.gov/emeu/cbecs/cbecs2003/detailed_tables_2003/2003set10/2003excel/#{data[:table][:natural_gas]}.xls",
          :headers => false,
          :select => Proc.new { |row| CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row) }, # only select rows where we can translate activity to a NAICS code
          :crop => (21..37) do
          key :name, :synthesize => Proc.new { |row|
            "#{Industry.format_naics_code(CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row))}-#{region}-#{data[:census_division]}"
          }
          store :natural_gas, :units => :cubit_metres, :synthesize => Proc.new { |row|
            Earth::EIA.convert_value(row[data[:column] + 1], :from => :billion_cubic_feet, :to => :cubic_metres)
          }
          store :natural_gas_floorspace, :units => :square_metres, :synthesize => Proc.new { |row|
            Earth::EIA.convert_value(row[data[:column] + 4], :from => :million_square_feet, :to => :square_metres)
          }
          store :natural_gas_intensity, :units => :cubic_meter_per_square_metre, :synthesize => Proc.new { |row|
            Earth::EIA.convert_value(row[data[:column] + 7], :from => :cubic_feet_per_square_foot, :to => :cubic_metre_per_square_metre)
          }
        end
      end

      import "2003 CBECS - Fuel Oil Consumption and Intensity - #{region}",
        :url => "http://www.eia.gov/emeu/cbecs/cbecs2003/detailed_tables_2003/2003set10/2003excel/c35.xls",
        :headers => false,
        :select => Proc.new { |row| CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row) }, # only select rows where we can translate activity to a NAICS code
        :crop => (21..37) do
        key :name, :synthesize => Proc.new { |row|
          "#{Industry.format_naics_code(CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row))}-#{data[:census_division]}"
        }
        store :census_region_number, :static => region
        store :fuel_oil, :units => :cubit_metres, :synthesize => Proc.new { |row|
          Earth::EIA.convert_value(row[data[:column] + 1], :from => :billion_cubic_feet, :to => :cubic_metres)
        }
        store :fuel_oil_floorspace, :units => :square_metres, :synthesize => Proc.new { |row|
          Earth::EIA.convert_value(row[data[:column] + 4], :from => :million_square_feet, :to => :square_metres)
        }
        store :fuel_oil_intensity, :units => :cubic_meter_per_square_metre, :synthesize => Proc.new { |row|
          Earth::EIA.convert_value(row[data[:column] + 7], :from => :cubic_feet_per_square_foot, :to => :cubic_metre_per_square_metre)
        }
      end
    end

    import "2003 CBECS - District Heat Consumption and Intensity - US Total",
      :url => "http://www.eia.gov/emeu/cbecs/cbecs2003/detailed_tables_2003/2003set10/2003excel/c38.xls",
      :headers => false,
      :select => Proc.new { |row| CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row) }, # only select rows where we can translate activity to a NAICS code
      :crop => (21..37) do
      key :name, :synthesize => Proc.new { |row|
        "#{Industry.format_naics_code(CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row))}"
      }
      store :district_heat, :units => :cubit_metres, :synthesize => Proc.new { |row|
        Earth::EIA.convert_value(row[data[:column] + 1], :from => :billion_cubic_feet, :to => :cubic_metres)
      }
      store :district_heat_floorspace, :units => :square_metres, :synthesize => Proc.new { |row|
        Earth::EIA.convert_value(row[data[:column] + 4], :from => :million_square_feet, :to => :square_metres)
      }
      store :district_heat_intensity, :units => :cubic_meter_per_square_metre, :synthesize => Proc.new { |row|
        Earth::EIA.convert_value(row[data[:column] + 7], :from => :cubic_feet_per_square_foot, :to => :cubic_metre_per_square_metre)
      }
    end
  end
end
