AutomobileVariant.class_eval do
  class << self
    def transmission_is_blank?(row)
      row['transmission'].blank?
    end

    def is_a_2007_gmc_or_chevrolet?(row)
      row['year'] == 2007 and %w(GMC CHEVROLET).include? row['MFR'].upcase
    end

    def is_a_porsche?(row)
      row['make'].upcase == 'PORSCHE'
    end

    def is_not_a_porsche?(row)
      !is_a_porsche? row
    end

    def is_a_mercedes_benz?(row)
      row['make'] =~ /MERCEDES/i
    end

    def is_a_lexus?(row)
      row['make'].upcase == 'LEXUS'
    end

    def is_a_bmw?(row)
      row['make'].upcase == 'BMW'
    end

    def is_a_ford?(row)
      row['make'].upcase == 'FORD'
    end

    def is_a_rolls_royce_and_model_contains_bentley?(row)
      is_a_rolls_royce?(row) and model_contains_bentley?(row)
    end

    def is_a_bentley?(row)
      row['make'].upcase == 'BENTLEY'
    end

    def is_a_rolls_royce?(row)
      row['make'] =~ /ROLLS/i
    end

    def is_a_turbo_brooklands?(row)
      row['model'] =~ /TURBO R\/RL BKLDS/i
    end

    def model_contains_maybach?(row)
      row['model'] =~ /MAYBACH/i
    end
    
    def model_contains_bentley?(row)
      row['model'] =~ /BENTLEY/i
    end
    
    def source_code
      IO.read __FILE__
    end
  end
  
  # updated with 2010 names
  TRANSMISSIONS = {
    'A'   => 'Automatic',      # prefix
    'M'   => 'Manual',         # prefix
    'L'   => 'Automatic',      # prefix
    'S'   => 'Semi-Automatic', # prefix
    'AM'  => 'Automated Manual',
    'C'   => 'Continuously Variable',
    'SA'  => 'Semi-Automatic',
    'CVT' => 'Continuously Variable',
    'OT'  => 'Other'
  }

  ENGINE_TYPES = {
    '(GUZZLER)' => nil, # "gas guzzler"
    '(POLICE)' => nil, # police automobile_variant
    '(MPFI)' => 'injection',
    '(MPI*)' => 'injection',
    '(SPFI)' => 'injection',
    '(FFS)' => 'injection',
    '(TURBO)' => 'turbo',
    '(TRBO)' => 'turbo',
    '(TC*)' => 'turbo',
    '(FFS,TRBO)' => %w(injection turbo),
    '(S-CHARGE)' => 'supercharger',
    '(SC*)' => 'supercharger',
    '(DIESEL)' => nil, # diesel
    '(DSL)' => nil, # diesel
    '(ROTARY)' => nil, # rotary
    '(VARIABLE)' => nil, # variable displacement
    '(NO-CAT)' => nil, # no catalytic converter
    '(OHC)' => nil, # overhead camshaft
    '(OHV)' => nil, # overhead valves
    '(16-VALVE)' => nil, # 16V
    '(305)' => nil, # 305 cubic inch displacement
    '(307)' => nil, # 307 cubic inch displacement
    '(M-ENG)' => nil,
    '(W-ENG)' => nil,
    '(GM-BUICK)' => nil,
    '(GM-CHEV)' => nil,
    '(GM-OLDS)' => nil,
    '(GM-PONT)' => nil,
  }
  
  class AutomobileVariant::ParserB
    attr_accessor :year
    def initialize(options = {})
      @year = options[:year]
    end
  
    def apply(row)
      row.merge!({
        'make'           => row['carline_mfr_name'], # make it line up with the errata
        'model'          => row['carline_name'],     # ditto
        'transmission'   => TRANSMISSIONS[row['model_trans'][0, 1]],
        'speeds'         => (row['model_trans'][1, 1] == 'V') ? 'variable' : row['model_trans'][1, 1],
        'turbo'          => [ENGINE_TYPES[row['engine_desc1']], ENGINE_TYPES[row['engine_desc2']]].flatten.include?('turbo'),
        'supercharger'   => [ENGINE_TYPES[row['engine_desc1']], ENGINE_TYPES[row['engine_desc2']]].flatten.include?('supercharger'),
        'injection'      => [ENGINE_TYPES[row['engine_desc1']], ENGINE_TYPES[row['engine_desc2']]].flatten.include?('injection'),
        'displacement'   => _displacement(row['opt_disp']),
        'year'           => year
      })
      row
    end
  
    def _displacement(str)
      str = str.gsub(/[\(\)]/, '').strip
      if str =~ /^(.+)L$/
        $1.to_f
      elsif str =~ /^(.+)CC$/
        $1.to_f / 1000
      end
    end
  
    def add_hints!(bus)
      bus[:format] = :fixed_width
      bus[:cut] = '13-' if year == 1995
      bus[:schema_name] = :fuel_economy_guide_b
      bus[:select] = lambda { |row| row['supress_code'].blank? and row['state_code'] == 'F' }
      Slither.define :fuel_economy_guide_b do |d|
        d.rows do |row|
          row.trap { true } # there's only one section
          row.column 'active_year'      , 4,    :type => :integer  #   ACTIVE YEAR
          row.column 'state_code'       , 1,    :type => :string  #   STATE CODE:  F=49-STATE,C=CALIFORNIA
          row.column 'carline_clss'     , 2,    :type => :integer  #   CARLINE CLASS CODE
          row.column 'carline_mfr_code' , 3,    :type => :integer  #   CARLINE MANUFACTURER CODE
          row.column 'carline_name'     , 28,   :type => :string  #   CARLINE NAME
          row.column 'disp_cub_in'      , 4,    :type => :integer   #  DISP CUBIC INCHES
          row.column 'fuel_system'      , 2,    :type => :string   #  FUEL SYSTEM: 'FI' FOR FUEL INJECTION, 2-DIGIT INTEGER VALUE FOR #OF VENTURIES IF CARBURETOR SYSTEM.
          row.column 'model_trans'      , 6,    :type => :string   #  TRANSMISSION TYPE
          row.column 'no_cyc'           , 2,    :type => :integer   #  NUMBER OF ENGINE CYLINDERS
          row.column 'date_time'        , 12,   :type => :string  #   DATE AND TIME RECORD ENTERED -YYMMDDHHMMSS (YEAR, MONTH, DAY, HOUR, MINUTE, SECOND)
          row.column 'release_date'     , 6,    :type => :string   #  RELEASE DATE - YYMMDD (YEAR, MONTH, DAY)
          row.column 'vi_mfr_code'      , 3,    :type => :integer   #  VI MANUFACTURER CODE
          row.column 'carline_code'     , 5,    :type => :integer   #  CARLINE CODE
          row.column 'basic_eng_id'     , 5,    :type => :integer   #  BASIC ENGINE INDEX
          row.column 'carline_mfr_name' , 32,   :type => :string  #   CARLINE MANUFACTURER NAME
          row.column 'suppress_code'    , 1,    :type => :integer    # SUPPRESSION CODE (NO SUPPRESSED RECORD IF FOR PUBLIC ACCESS)
          row.column 'est_city_mpg'     , 3,    :type => :integer    # ESTIMATED (CITY) MILES PER GALLON - 90% OF UNADJUSTED VALUE
          row.spacer 2
          row.column 'highway_mpg'      , 3,    :type => :integer    # ESTIMATED (HWY) MILES PER GALLON - 78% OF UNADJUSTED VALUE
          row.spacer 2
          row.column 'combined_mpg'     , 3,    :type => :integer    # COMBINED MILES PER GALLON
          row.spacer 2
          row.column 'unadj_city_mpg'   , 3,    :type => :integer    # UNADJUSTED  CITY MILES PER GALLON
          row.spacer 2
          row.column 'unadj_hwy_mpg'    , 3,    :type => :integer    # UNADJUSTED HIGHWAY MILES PER GALLON
          row.spacer 2
          row.column 'unadj_comb_mpg'   , 3,    :type => :integer    # UNADJUSTED COMBINED MILES PER GALLON
          row.spacer 2
          row.column 'ave_anl_fuel'     , 6,    :type => :integer    # "$" in col 147, Annual Fuel Cost starting col 148 in I5
          row.column 'opt_disp'         , 8,    :type => :string    # OPTIONAL DISPLACEMENT
          row.column 'engine_desc1'     , 10,   :type => :string   #  ENGINE DESCRIPTION 1
          row.column 'engine_desc2'     , 10,   :type => :string   #  ENGINE DESCRIPTION 2
          row.column 'engine_desc3'     , 10,   :type => :string   #  ENGINE DESCRIPTION 3
          row.column 'body_type_2d'     , 10,   :type => :string   #  BODY TYPE 2 DOOR - IF THE BODY TYPE APPLIES IT WILL TAKE THE FORM '2DR-PPP/LL' WHERE PPP=PASSENGER INTERIOR VOLUME AND LL=LUGGAGE INTERIOR VOLUME.
          row.column 'body_type_4d'     , 10,   :type => :string   #  BODY TYPE 4 DOOR - IF THE BODY TYPE APPLIES IT WILL TAKE THE FORM '4DR-PPP/LL' WHERE PPP=PASSENGER INTERIOR VOLUME AND LL=LUGGAGE INTERIOR VOLUME.
          row.column 'body_type_hbk'    , 10,   :type => :string   #  BODY TYPE HBK    - IF THE BODY TYPE APPLIES IT WILL TAKE THE FORM 'HBK-PPP/LL' WHERE PPP=PASSENGER INTERIOR VOLUME AND LL=LUGGAGE INTERIOR VOLUME.
          row.column 'puerto_rico'      , 1,    :type => :string    # '*' IF FOR PUERTO RICO SALES ONLY
          row.column 'overdrive'        , 4,    :type => :string    # OVERDRIVE:  ' OD ' FOR OVERDRIVE, 'EOD ' FOR ELECTRICALLY OPERATED OVERDRIVE AND 'AEOD' FOR AUTOMATIC OVERDRIVE
          row.column 'drive_system'     , 3,    :type => :string    # FWD=FRONT WHEEL DRIVE, RWD=REAR,  4WD=4-WHEEL
          row.column 'filler'           , 1,    :type => :string    # NOT USED
          row.column 'fuel_type'        , 1,    :type => :string    # R=REGULAR(UNLEADED), P=PREMIUM,  D=DIESEL
          row.column 'trans_desc'       , 15,   :type => :string   #  TRANSMISSION DESCRIPTORS
        end
      end
    end
  end
  class AutomobileVariant::ParserC
    attr_accessor :year
    def initialize(options = {})
      @year = options[:year]
    end
    
    def add_hints!(bus)
      # File will decide format based on filename
    end
    
    def apply(row)
      row.merge!({
        'make'           => row['Manufacturer'], # make it line up with the errata
        'model'          => row['carline name'], # ditto
        'drive'          => row['drv'] + 'WD',
        'transmission'   => TRANSMISSIONS[row['trans'][-3, 1]], # only using prefix, probably a FIXME
        'speeds'         => (row['trans'][-2, 1] == 'V') ? '1' : row['trans'][-2, 1],
        'turbo'          => row['T'] == 'T',
        'supercharger'   => row['S'] == 'S',
        'injection'      => true,
        'year'           => year
      })
      row
    end
  end
  class AutomobileVariant::ParserD
    attr_accessor :year
    def initialize(options = {})
      @year = options[:year]
    end
    
    def add_hints!(bus)
    end
    
    def apply(row)
      row.merge!({
        'make'           => row['MFR'],          # make it line up with the errata
        'model'          => row['CAR LINE'],     # ditto
        'drive'          => row['DRIVE SYS'] + 'WD',
        'transmission'   => TRANSMISSIONS[row['TRANS'][-3, 1]], # only using prefix, probably a FIXME
        'speeds'         => (row['TRANS'][-2, 1] == 'V') ? '1' : row['TRANS'][-2, 1],
        'turbo'          => row['TURBO'] == 'T',
        'supercharger'   => row['SPCHGR'] == 'S',
        'injection'      => true,
        'year'           => year
      })
      row
    end
  end
  class AutomobileVariant::ParserE
    OLD_FUEL_CODES = {
      'CNG' => 'C',
      'DU' => 'D',
      'G' => 'R',
      'GP' => 'P',
      'GPR' => 'P'
    }
    
    attr_accessor :year
    def initialize(options = {})
      @year = options[:year]
    end
    
    def add_hints!(bus)
    end
    
    def apply(row)
      row.merge!({
        'make'           => row['Division'],          # make it line up with the errata
        'model'          => row['Carline'],     # ditto
        'drive'          => row['Drive Sys'] + 'WD',
        'transmission'   => TRANSMISSIONS[row['Trans']],
        'speeds'         => row['# Gears'],
        'turbo'          => row['Air Aspir Method'] == 'TC',
        'supercharger'   => row['Air Aspir Method'] == 'SC',
        'injection'      => true,
        'year'           => year,
        'fuel_type_code' => OLD_FUEL_CODES[row['Fuel Usage  - Conventional Fuel']]
      })
      row
    end
  end
  
  data_miner do
    process "Don't re-import too often" do
      raise DataMiner::Skip unless DataMiner::Run.allowed? AutomobileVariant
    end
    
    schema :options => 'ENGINE=InnoDB default charset=utf8' do
      string   'row_hash'
      string   'name' # short name!
      string   'make_name'
      string   'model_name' # make + model
      string   'make_year_name' # make + year
      string   'model_year_name' # make + model + year
      integer  'year'
      float    'fuel_efficiency_city'
      string   'fuel_efficiency_city_units'
      float    'fuel_efficiency_highway'
      string   'fuel_efficiency_highway_units'
      string   'fuel_type_code'
      string   'transmission'
      string   'drive'
      boolean  'turbo'
      boolean  'supercharger'
      integer  'cylinders'
      float    'displacement'
      float    'raw_fuel_efficiency_city'
      string   'raw_fuel_efficiency_city_units'
      float    'raw_fuel_efficiency_highway'
      string   'raw_fuel_efficiency_highway_units'
      integer  'carline_mfr_code'
      integer  'vi_mfr_code'
      integer  'carline_code'
      integer  'carline_class_code'
      boolean  'injection'
      string   'carline_class_name'
      string   'speeds'
      index    'make_name'
      index    'model_name'
      index    'make_year_name'
      index    'model_year_name'
    end
    
    # # 1985---1997
    (85..97).each do |yy|
      filename = (yy == 96) ? "#{yy}MFGUI.ASC" : "#{yy}MFGUI.DAT"
      import("19#{ yy } Fuel Economy Guide",
             :url => "http://www.fueleconomy.gov/FEG/epadata/#{yy}mfgui.zip",
             :filename => filename,
             :transform => { :class => AutomobileVariant::ParserB, :year => "19#{yy}".to_i },
             :errata => 'http://static.brighterplanet.com/science/data/transport/automobiles/fuel_economy_guide/errata.csv') do
        key   'row_hash'
        store 'name', :field_name => 'model'
        store 'make_name', :field_name => 'make'
        store 'year'
        store 'fuel_type_code', :field_name => 'fuel_type'
        store 'fuel_efficiency_highway', :static => nil, :units => :kilometres_per_litre
        store 'fuel_efficiency_city', :static => nil, :units => :kilometres_per_litre
        store 'raw_fuel_efficiency_highway', :field_name => 'unadj_hwy_mpg', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'raw_fuel_efficiency_city', :field_name => 'unadj_city_mpg', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'cylinders', :field_name => 'no_cyc'
        store 'drive', :field_name => 'drive_system'
        store 'carline_mfr_code'
        store 'vi_mfr_code'
        store 'carline_code'
        store 'carline_class_code', :field_name => 'carline_clss'
        store 'transmission'
        store 'speeds'
        store 'turbo'
        store 'supercharger'
        store 'injection'
        store 'displacement'
      end
    end
    
    # 1998--2005
    {
      1998 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/98guide6.zip', :filename => '98guide6.csv' },
      1999 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/99guide.zip', :filename => '99guide6.csv' },
      2000 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/00data.zip', :filename => 'G6080900.xls' },
      2001 => { :url => 'http://static.brighterplanet.com/science/data/transport/automobiles/fuel_economy_guide/01guide0918.csv' }, # parseexcel 0.5.2 can't read Excel 5.0 { :url => 'http://www.fueleconomy.gov/FEG/epadata/01data.zip', :filename => '01guide0918.xls' }
      2002 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/02data.zip', :filename => 'guide_jan28.xls' },
      2003 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/03data.zip', :filename => 'guide_2003_feb04-03b.csv' },
      2004 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/04data.zip', :filename => 'gd04-Feb1804-RelDtFeb20.csv' },
      2005 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/05data.zip', :filename => 'guide2005-2004oct15.csv' }
    }.sort { |a, b| a.first <=> b.first }.each do |year, options|
      import "#{ year } Fuel Economy Guide",
             options.merge(:transform => { :class => AutomobileVariant::ParserC, :year => year },
                           :errata => 'http://static.brighterplanet.com/science/data/transport/automobiles/fuel_economy_guide/errata.csv') do
        key   'row_hash'
        store 'name', :field_name => 'model'
        store 'make_name', :field_name => 'make'
        store 'fuel_type_code', :field_name => 'fl'
        store 'fuel_efficiency_highway', :static => nil, :units => :kilometres_per_litre
        store 'fuel_efficiency_city', :static => nil, :units => :kilometres_per_litre
        store 'raw_fuel_efficiency_highway', :field_name => 'uhwy', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'raw_fuel_efficiency_city', :field_name => 'ucty', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'cylinders', :field_name => 'cyl'
        store 'displacement', :field_name => 'displ'
        store 'carline_class_code', :field_name => 'cls' if year >= 2000
        store 'carline_class_name', :field_name => 'Class'
        store 'year'
        store 'transmission'
        store 'speeds'
        store 'turbo'
        store 'supercharger'
        store 'injection'
        store 'drive'
      end
    end
    
    # 2006--2009
    {
      2006 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/06data.zip', :filename => '2006_FE_Guide_14-Nov-2005_download.csv' },
      2007 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/07data.zip', :filename => '2007_FE_guide_ALL_no_sales_May_01_2007.xls' },
      2008 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/08data.zip', :filename => '2008_FE_guide_ALL_rel_dates_-no sales-for DOE-5-1-08.csv' },
      2009 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/09data.zip', :filename => '2009_FE_guide for DOE_ALL-rel dates-no-sales-8-28-08download.csv' },
    }.sort { |a, b| a.first <=> b.first }.each do |year, options|
      import "#{ year } Fuel Economy Guide",
             options.merge(:transform => { :class => AutomobileVariant::ParserD, :year => year },
                           :errata => 'http://static.brighterplanet.com/science/data/transport/automobiles/fuel_economy_guide/errata.csv') do
        key   'row_hash'
        store 'name', :field_name => 'model'
        store 'make_name', :field_name => 'make'
        store 'fuel_type_code', :field_name => 'FUEL TYPE'
        store 'fuel_efficiency_highway', :static => nil, :units => :kilometres_per_litre
        store 'fuel_efficiency_city', :static => nil, :units => :kilometres_per_litre
        store 'raw_fuel_efficiency_highway', :field_name => 'UNRND HWY (EPA)', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'raw_fuel_efficiency_city', :field_name => 'UNRND CITY (EPA)', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'cylinders', :field_name => 'NUMB CYL'
        store 'displacement', :field_name => 'DISPLACEMENT'
        store 'carline_class_code', :field_name => 'CLS'
        store 'carline_class_name', :field_name => 'CLASS'
        store 'year'
        store 'transmission'
        store 'speeds'
        store 'turbo'
        store 'supercharger'
        store 'injection'
        store 'drive'
      end
    end
    
    # 2010--?
    # sabshere 5/17/10 apparently needs update
    # {
    #   2010 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/10data.zip', :filename => '2010FEguide-for DOE-rel dates before 10-16-09-no-sales10-8-09public.xls' }
    # }.sort { |a, b| a.first <=> b.first }.each do |year, options|
    #   import "#{ year } Fuel Economy Guide",
    #          options.merge(:transform => { :class => AutomobileVariant::ParserE, :year => year },
    #                        :errata => 'http://static.brighterplanet.com/science/data/transport/automobiles/fuel_economy_guide/errata.csv') do
    #     key   'row_hash'
    #     store 'name', :field_name => 'model'
    #     store 'make_name', :field_name => 'make'
    #     store 'fuel_type_code'
    #     store 'fuel_efficiency_highway', :static => nil, :units => :kilometres_per_litre
    #     store 'fuel_efficiency_city', :static => nil, :units => :kilometres_per_litre
    #     store 'raw_fuel_efficiency_highway', :field_name => 'Hwy Unadj FE - Conventional Fuel', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
    #     store 'raw_fuel_efficiency_city', :field_name => 'City Unadj FE - Conventional Fuel', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
    #     store 'cylinders', :field_name => '# Cyl'
    #     store 'displacement', :field_name => 'Eng Displ'
    #     store 'carline_class_code', :field_name => 'Carline Class'
    #     store 'carline_class_name', :field_name => 'Carline Class Desc'
    #     store 'year'
    #     store 'transmission'
    #     store 'speeds'
    #     store 'turbo'
    #     store 'supercharger'
    #     store 'injection'
    #     store 'drive'
    #   end
    # end
    
    process "Derive model and model year names" do
      update_all "model_name = CONCAT(make_name, ' ', name)"
      update_all "make_year_name = CONCAT(make_name, ' ', year)"
      update_all "model_year_name = CONCAT(make_name, ' ', name, ' ', year)"
    end
    
    process "Calculate adjusted fuel efficiency using the latest EPA equations" do
      update_all 'fuel_efficiency_city = 1 / ((0.003259 / 0.425143707) + (1.1805 / raw_fuel_efficiency_city))'
      update_all 'fuel_efficiency_highway = 1 / ((0.001376 / 0.425143707) + (1.3466 / raw_fuel_efficiency_highway))'
    end
    
    [ AutomobileMake, AutomobileModelYear, AutomobileModel ].each do |synthetic_resource|
      process "Synthesize #{synthetic_resource}" do
        synthetic_resource.run_data_miner!
      end
    end
  end
end

