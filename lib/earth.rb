require 'active_record'
require 'data_miner'
require 'falls_back_on'
require 'falls_back_on/active_record_ext'

module Earth
  extend self

  def taps_server
    if defined?(@taps_server)
      @taps_server
    else
      @taps_server = nil
    end
  end
  def taps_server=(val)
    @taps_server = val
  end

  def classes
    [
      AirConditionerUse,
      Aircraft,
      AircraftClass,
      AircraftManufacturer,
      Airline,
      Airport,
      AutomobileFuelType,
      AutomobileMake,
      AutomobileMakeFleetYear,
      AutomobileMakeYear,
      AutomobileModel,
      AutomobileModelYear,
      AutomobileSizeClass,
      AutomobileVariant,
      Breed,
      BreedGender,
      BusClass,
      CensusDivision,
      CensusRegion,
      ClimateDivision,
      ClothesMachineUse,
      Country,
      DietClass,
      DishwasherUse,
      EgridRegion,
      EgridSubregion,
      FlightConfiguration,
      FlightDistanceClass,
      FlightDomesticity,
      FlightFuelType,
      FlightPropulsion,
      FlightSeatClass,
      FlightSegment,
      FlightService,
      FoodGroup,
      Gender,
      PetroleumAdministrationForDefenseDistrict,
      RailClass,
      ResidenceAppliance,
      ResidenceClass,
      ResidenceFuelPrice,
      ResidenceFuelType,
      ResidentialEnergyConsumptionSurveyResponse,
      Species,
      State,
      Urbanity,
      ZipCode
    ]
  end
end
