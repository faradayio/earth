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
      connection.select_values("SELECT DISTINCT cbecs_detailed_activity FROM #{CountryLodgingClass.quoted_table_name}").each do |cbecs_activity|
        [:natural_gas, :fuel_oil, :electricity, :steam].each do |fuel|
          where(:cbecs_detailed_activity => cbecs_activity).update_all(%{
            #{fuel}_intensity = (
              SELECT SUM(
                weighting * #{fuel}_use / (365.0 / 7.0 / 12.0 * months_used * weekly_hours / 24.0 * lodging_rooms * #{occupancy_rate})
              ) / SUM(weighting)
              FROM #{CommercialBuildingEnergyConsumptionSurveyResponse.quoted_table_name}
              WHERE detailed_activity = '#{cbecs_activity}'
            )
          })
        end
        
        where(:cbecs_detailed_activity => cbecs_activity).update_all(%{
          natural_gas_intensity_units = 'cubic_metres_per_room_night',
          fuel_oil_intensity_units    = 'litres_per_room_night',
          electricity_intensity_units = 'kilowatt_hours_per_room_night',
          steam_intensity_units       = 'megajoules_per_room_night',
          weighting = (
            SELECT SUM(weighting)
            FROM #{CommercialBuildingEnergyConsumptionSurveyResponse.quoted_table_name}
            WHERE detailed_activity = '#{cbecs_activity}'
          ) / #{where(:cbecs_detailed_activity => cbecs_activity).count}
        })
      end
    end
  end
end
