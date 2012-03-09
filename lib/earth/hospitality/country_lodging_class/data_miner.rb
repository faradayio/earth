require 'earth/locality/data_miner'
CountryLodgingClass.class_eval do
  data_miner do
    import "a curated list of country lodging classes",
           :url => 'https://docs.google.com/spreadsheet/pub?key=0AoQJbWqPrREqdENYYWdiRm9LSjVZQ0tJRWplT1JNNVE&output=csv' do
      key 'name'
      store 'country_iso_3166_code'
      store 'lodging_class_name'
      store 'cbecs_detailed_activity'
    end
    
    process "Ensure CommercialBuildingEnergyConsumptionSurveyResponse and Country are populated" do
      CommercialBuildingEnergyConsumptionSurveyResponse.run_data_miner!
      Country.run_data_miner!
    end
    
    process "Calculate US lodging class fuel intensities from CommercialBuildingEnergyConsumptionSurveyResponse" do
      occupancy_rate = Country.united_states.lodging_occupancy_rate
      lodging_records = CommercialBuildingEnergyConsumptionSurveyResponse.lodging_records
      
      Country.united_states.lodging_classes.map(&:cbecs_detailed_activity).uniq.each do |cbecs_activity|
        %w{natural_gas fuel_oil electricity district_heat}.each do |fuel|
          cbecs_column = (fuel + '_use').to_sym
          
          where(:cbecs_detailed_activity => cbecs_activity).update_all %{
            #{fuel}_intensity = (#{
              lodging_records.where(:detailed_activity => cbecs_activity).
                weighted_average_relation(cbecs_column, :disaggregate_by => :room_nights, :weighted_by => :weighting).to_sql
            }) / #{occupancy_rate},
            #{fuel}_intensity_units = '#{lodging_records.first.send("#{fuel}_use_units")}_per_occupied_room_night',
            weighting = (#{
              lodging_records.where(:detailed_activity => cbecs_activity).sum(:weighting) /
              where(:cbecs_detailed_activity => cbecs_activity).count
            })
          }
        end
      end
    end
  end
end
