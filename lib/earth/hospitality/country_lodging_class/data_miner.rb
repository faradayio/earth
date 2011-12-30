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
    
    process "Ensure CommercialBuildingEnergyConsumptionSurveyResponse is populated" do
      CommercialBuildingEnergyConsumptionSurveyResponse.run_data_miner!
    end
    
    process "Calculate US lodging class fuel intensities from CommercialBuildingEnergyConsumptionSurveyResponse" do
      where(:country_iso_3166_code => 'US').each do |lodging_class|
        cbecs_responses = CommercialBuildingEnergyConsumptionSurveyResponse.where(:detailed_activity => lodging_class.cbecs_detailed_activity)
        intensities = {}
        
        [:natural_gas, :fuel_oil, :electricity, :district_heat].each do |fuel|
          intensity = cbecs_responses.inject(0) do |sum, response|
            next sum unless response.send("#{fuel}_use").present?
            occupied_room_nights = 365.0 / 7.0 / 12.0 * response.months_used * response.weekly_hours / 24.0 * response.lodging_rooms * 0.59
            sum + (response.weighting * response.send("#{fuel}_use") / occupied_room_nights)
          end
          intensities[fuel] = intensity / cbecs_responses.sum(:weighting)
        end
        
        lodging_class.natural_gas_intensity         = intensities[:natural_gas]
        lodging_class.natural_gas_intensity_units   = 'cubic_metres_per_room_night'
        lodging_class.fuel_oil_intensity            = intensities[:fuel_oil]
        lodging_class.fuel_oil_intensity_units      = 'litres_per_room_night'
        lodging_class.electricity_intensity         = intensities[:electricity]
        lodging_class.electricity_intensity_units   = 'kilowatt_hours_per_room_night'
        lodging_class.district_heat_intensity       = intensities[:district_heat]
        lodging_class.district_heat_intensity_units = 'megajoules_per_room_night'
        lodging_class.weighting                     = (lodging_class.lodging_class_name == 'Motel' or lodging_class.lodging_class_name == 'Inn') ? cbecs_responses.sum(:weighting) / 2.0 : cbecs_responses.sum(:weighting) # hack to ensure that we don't double-weight motels and inns when we calculate US national average lodging fuel intensities
        lodging_class.save!
      end
    end
  end
end
