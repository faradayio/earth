require 'earth/eia'
require 'earth/industry'
require 'earth/locality/data_miner'

CbecsEnergyIntensity.class_eval do
  const_set :FUELS, {
    :electricity => { 
      :consumption => :billion_kilowatt_hours,
      :intensity => :kilowatt_hours_per_square_foot,
      :set => 10
    },
    :natural_gas => { 
      :consumption => :billion_cubic_feet_of_natural_gas,
      :intensity => :cubic_feet_of_natural_gas_per_square_foot,
      :set => 11
    },
    :fuel_oil => { 
      :consumption => :million_gallons_of_fuel_oil,
      :intensity => :gallons_of_fuel_oil_per_square_foot,
      :set => 12
    },
    :district_heat => { 
      :consumption => :trillion_btu,
      :intensity => :trillion_btu_per_million_square_feet,
      :set => 13
    }
  }

  const_set(:CBECS, {
    :region_tables => {
      :electricity => 'c15',
      :natural_gas => 'c25',
      :fuel_oil => 'c35'
    },
    :regions => {
      'North-east' => {
        :census_region => 1,
        :column => 1,

        :divisions => {
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
        }
      },
      'Mid-west' => {
        :census_region => 2,
        :column => 2,
        :table => {
          :electricity => 'c16',
          :natural_gas => 'c26',
          :fuel_oil => 'c36'
        },

        :divisions => {
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
        }
      },
      'South' => {
        :census_region => 3,
        :column => 3,
        :table => {
          :electricity => 'c16',
          :natural_gas => 'c26',
          :fuel_oil => 'c36'
        },

        :divisions => {
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
        }
      },
      'West' => {
        :census_region => 4,
        :column => 4,
        :table => {
          :electricity => 'c16',
          :natural_gas => 'c26',
          :fuel_oil => 'c36'
        },

        :divisions => {
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
    CbecsEnergyIntensity::CBECS[:regions].each do |region_name, region_data|
      region_number = region_data[:census_region]
      
      # By Census Division
      #
      region_data[:divisions].each do |division, division_data|
        division_data[:table].each do |energy_source, table|
          import "2003 CBECS #{table.upcase} - Electricity Consumption and Intensity - #{division}",
            :url => "http://www.eia.gov/emeu/cbecs/cbecs2003/detailed_tables_2003/2003set#{CbecsEnergyIntensity::FUELS[energy_source][:set]}/2003excel/#{table}.xls",
            :headers => false,
            :select => Proc.new { |row| CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row) }, # only select rows where we can translate activity to a NAICS code
            :crop => (21..37) do
            key :name, :synthesize => Proc.new { |row|
              "#{Industry.format_naics_code(CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row))}-#{region_number}-#{division_data[:census_division]}"
            }

            store :principal_building_activity, :synthesize => Proc.new { |row| row[0].gsub(/[\.\(\)]/,'').strip }
            store :naics_code, :synthesize => CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER
            store :census_region_number, :static => region_number
            store :census_division_number, :static => division_data[:census_division]

            fuel_data = CbecsEnergyIntensity::FUELS[energy_source]
            store energy_source, :units => :megajoules, :synthesize => Proc.new { |row|
              Earth::EIA.convert_value(row[division_data[:column] + 1], :from => fuel_data[:consumption], :to => :megajoules)
            }
            store "#{energy_source}_floorspace", :units => :square_metres, :synthesize => Proc.new { |row|
              Earth::EIA.convert_value(row[division_data[:column] + 4], :from => :million_square_feet, :to => :square_metres)
            }
            store "#{energy_source}_intensity", :units => :megajoules_per_square_metre, :synthesize => Proc.new { |row|
              Earth::EIA.convert_value(row[division_data[:column] + 7], :from => fuel_data[:intensity], :to => :megajoules_per_square_metre)
            }
          end
        end
      end
    end

    ## By Census Region
    ##
    CbecsEnergyIntensity::CBECS[:region_tables].each do |energy_source, table|
      CbecsEnergyIntensity::CBECS[:regions].each do |region, region_data|
        import "2003 CBECS #{table.upcase} - #{energy_source.to_s.titleize} Consumption and Intensity - #{region.capitalize} Region",
          :url => "http://www.eia.gov/emeu/cbecs/cbecs2003/detailed_tables_2003/2003set#{CbecsEnergyIntensity::FUELS[energy_source][:set]}/2003excel/#{table}.xls",
          :select => Proc.new { |row| CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row) }, # only select rows where we can translate activity to a NAICS code
          :headers => false,
          :crop => (energy_source == :fuel_oil ? (16..19) : (21..37)) do
          
          key :name, :synthesize => Proc.new { |row|
            "#{Industry.format_naics_code(CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row))}-#{region_data[:census_region]}"
          }

          store :census_region_number, :static => region_data[:census_region]
          store :principal_building_activity, :synthesize => Proc.new { |row| row[0].gsub(/[\.\(\)]/,'').strip }
          store :naics_code, :synthesize => CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER

          store energy_source, :units => :megajoules, :synthesize => Proc.new { |row|
            Earth::EIA.convert_value(row[region_data[:column]], :from => CbecsEnergyIntensity::FUELS[energy_source][:consumption],
                                                                :to => :megajoules)
          }
          store "#{energy_source}_floorspace", :units => :square_metres, :synthesize => Proc.new { |row|
            Earth::EIA.convert_value(row[region_data[:column] + 4], :from => :million_square_feet, :to => :square_metres)
          }
          store "#{energy_source}_intensity", :units => :megajoules_per_square_metre, :synthesize => Proc.new { |row|
            Earth::EIA.convert_value(row[region_data[:column] + 8], :from => CbecsEnergyIntensity::FUELS[energy_source][:intensity],
                                                                :to => :megajoules_per_square_metre)
          }
        end
      end
    end

    # National
    import "2003 CBECS C1 - District Heat Consumption and Intensity - US Total",
      :url => "http://www.eia.gov/emeu/cbecs/cbecs2003/detailed_tables_2003/2003set9/2003excel/c1.xls",
      :headers => false,
      :select => Proc.new { |row| CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row) }, # only select rows where we can translate activity to a NAICS code
      :crop => (21..37) do
      key :name, :synthesize => Proc.new { |row|
        Industry.format_naics_code(CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER.call(row))
      }
      store :principal_building_activity, :synthesize => Proc.new { |row| row[0].gsub(/[\.\(\)]/,'').strip }
      store :naics_code, :synthesize => CbecsEnergyIntensity::NAICS_CODE_SYNTHESIZER

      {:electricity => [4,5], :natural_gas => [6], :fuel_oil => [7], :district_heat => [8]}.each do |energy_source, columns|
        store energy_source, :units => :megajoules, :synthesize => Proc.new { |row|
          total_energy = nil
          columns.each do |column|
            value = Earth::EIA.convert_value(row[column], :from => :trillion_btus, :to => :megajoules)
            if value
              total_energy ||= 0
              total_energy += value
            end
          end
          total_energy
        }
        store "#{energy_source}_floorspace", :units => :square_metres, :synthesize => Proc.new { |row|
          Earth::EIA.convert_value(row[2], :from => :million_square_feet, :to => :square_metres)
        }
        store "#{energy_source}_intensity", :units => :megajoules_per_square_metre, :synthesize => Proc.new { |row|
          total_energy = nil
          columns.each do |column|
            value = Earth::EIA.convert_value(row[column])
            if value
              total_energy ||= 0
              total_energy += value
            end
          end
          if total_energy
            intensity = total_energy / row[2].to_f
            Earth::EIA.convert_value(intensity, :from => :trillion_btus_per_million_square_feet,
                                                  :to => :megajoules_per_square_metre)
          end
        }
      end
    end
  end
end
