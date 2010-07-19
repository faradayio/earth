require 'active_record'
require 'cohort_scope'
require 'earth/conversions_ext'
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

  def root 
    File.join(File.dirname(__FILE__), '..')
  end

  def domains
    %w{air automobile bus diet locality pet rail residence}
  end

  def init(*args)
    load_plugins

    domains = []
    options = {}
    args.each do |arg|
      if arg.is_a?(Hash)
        options = arg
      else
        domains << arg
      end
    end
    domains << :all if domains.empty?
    domains.select { |domain| domain != :none }.each do |domain| 
      require "earth/#{domain}"
      if options[:apply_schemas]
        if domain == :all
          require "earth/data_miner" 
        else
          require "earth/#{domain}/data_miner" 
        end
      end
    end

    load_schemas if options[:apply_schemas]
  end

  def load_plugins
    Dir[File.join(Earth.root, 'vendor', '**', 'init.rb')].each do |pluginit|
      $:.unshift File.join(File.dirname(pluginit), 'lib')
      load pluginit
    end
  end

  def load_schemas
    models = Module.constants.select do |k|
      const = Object.const_get(k)
      if const.instance_of?(Class)
        const.superclass == ActiveRecord::Base
      else
        false
      end
    end
    models.sort.each do |model|
      klass = Object.const_get(model)
      if klass.respond_to?(:execute_schema) and !klass.table_exists?
        klass.execute_schema 
      end
    end
  end

  def database_options
    if ActiveRecord::Base.connection.adapter_name.downcase == 'sqlite'
      {}
    else
      { :options => 'ENGINE=InnoDB default charset=utf8' }
    end
  end
end
