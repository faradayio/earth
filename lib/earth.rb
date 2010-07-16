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

  def init(options = {})
    load_plugins

    chosen_domains = case options[:earth]
    when nil then
      []
    when :none then
      []
    when :all then
      domains.map(&:to_sym)
    else
      [options[:earth]]
    end

    domains.each { |domain| require "earth/#{domain}" }

    if options[:load_schemas]
      read_schema File.join(File.dirname(__FILE__),'earth', 'schema.rb')
      chosen_domains.each { |d| read_schema d }
      load_all_schemas unless chosen_domains.empty?
    end
  end

  def load_plugins
    Dir[File.join(Earth.root, 'vendor', '**', 'init.rb')].each do |pluginit|
      $:.unshift File.join(File.dirname(pluginit), 'lib')
      load pluginit
    end
  end

  def read_schema(domain)
    schema_path = File.join File.dirname(__FILE__),'earth', domain.to_s, 'schema.rb'
    load schema_path if File.exist? schema_path
  end

  def define_schema(&blk)
    @schemas = [] unless defined?(@schemas)
    @schemas << blk
  end

  def schemas
    @schemas
  end

  def load_all_schemas
    orig_std_out = STDOUT.clone
    STDOUT.reopen File.open(File.join('/tmp', 'schema_output'), 'w') 

    ActiveRecord::Schema.define(:version => 1) do
      ar_schema = self
      Earth.schemas.each do |s|
        ar_schema.instance_eval &s
      end
    end
  ensure
    STDOUT.reopen(orig_std_out)
  end
end
