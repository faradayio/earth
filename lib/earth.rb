require 'active_record'
require 'cohort_scope'
require 'earth/conversions_ext'
require 'earth/inflectors'
require 'data_miner'
require 'falls_back_on'
require 'falls_back_on/active_record_ext'

# The earth module is an interface for establishing a taps server (used to fetch 
# data) and for loading data models from various domains.
module Earth
  extend self

  def taps_server
    if defined?(@taps_server)
      @taps_server
    else
      @taps_server = nil
    end
  end

  # taps_server is a URL. See the data_miner gem docs
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
    %w{air automobile bus diet fuel locality pet rail residence}
  end

  # Earth.init will load any specified domains, any needed ActiveRecord plugins, 
  # and will apply each domain model's schema to the database if the 
  # :apply_schemas option is given. See #domains for the list of allowable 
  # domains.
  #
  # #init should be performed after a connection is made to the database and 
  # before any domain models are referenced.
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

    load_domains(domains, options[:apply_schemas])
    load_schemas if options[:apply_schemas]
  end

private
  def load_domains(domains, apply_schemas)
    if domains.empty? or domains.include?(:all)
      require 'earth/all'
      require 'earth/data_miner' if apply_schemas
    elsif !domains.include?(:none)
      domains.each do |domain| 
        require "earth/#{domain}"
        require "earth/#{domain}/data_miner" if apply_schemas
      end
    end
  end

  def load_plugins
    Dir[File.join(Earth.root, 'vendor', '**', 'init.rb')].each do |pluginit|
      $:.unshift File.join(File.dirname(pluginit), 'lib')
      load pluginit
    end
  end

  def load_schemas
    load_ar_schema
    load_data_miner_schemas
  end

  def load_ar_schema
    orig_std_out = STDOUT.clone
    STDOUT.reopen File.open(File.join('/tmp', 'schema_output'), 'w') 

    load File.join(File.dirname(__FILE__), 'earth', 'schema.rb')
  ensure
    STDOUT.reopen(orig_std_out)
  end

  def load_data_miner_schemas
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
