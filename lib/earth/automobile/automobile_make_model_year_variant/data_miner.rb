AutomobileMakeModelYearVariant.class_eval do
  # For errata
  class AutomobileMakeModelYearVariant::Guru
    %w{ alpina bentley chevrolet chrysler dodge ferrari ford gmc jaguar kia lexus maybach mercedes-benz mitsubishi porsche toyota tvr volvo yugo }.each do |make|
      method_name = :"is_a_#{make.gsub('-', '_')}?"
      define_method method_name do |row|
        row['make_name'].downcase == make
      end
    end
    
    %w{ alpina bentley marquis maybach milan mystique scion smart }.each do |model_name|
      method_name = :"model_contains_#{model_name}?"
      define_method method_name do |row|
        row['model_name'].to_s =~ /#{model_name}/i
      end
    end
    
    [["ford", "contour"], ["hyundai", "sonata"], ["jaguar", "xjr"], ["jaguar", "xjs convertible"], ["jaguar", "xjs coupe"], ["mercury", "mystique"], ["mitsubishi", "mirage"], ["volvo", "850"], ["volvo", "850 wagon"], ["volvo", "940"], ["volvo", "940 wagon"]].each do |make_name, model_name|
      method_name = :"is_a_1995_#{make_name}_#{model_name.gsub(' ', '_')}_missing_fuel_efficiency?"
      define_method method_name do |row|
        row['year'] == 1995 and row['make_name'].downcase == make_name and row['model_name'].downcase == model_name and (row['fuel_efficiency_city'] == 0 or row['fuel_efficiency_highway'] == 0)
      end
    end
    
    def is_a_turbo_brooklands?(row)
      row['model_name'] =~ /TURBO R\/RL BKLDS/i
    end
    
    def is_a_1989_hyundai_sonata_missing_transmission_and_speeds?(row)
      row['make_name'].downcase == 'hyundai' and row['model_name'].downcase == 'sonata' and row['year'] == 1989 and (row['transmission'].blank? || row['speeds'].blank?)
    end
    
    def is_a_1989_isuzu_trooper_missing_transmission_and_speeds?(row)
      row['make_name'].downcase == 'isuzu' and row['model_name'].downcase == 'trooper' and row['year'] == 1989 and (row['transmission'].blank? || row['speeds'].blank?)
    end
    
    def is_a_2005_mercedes_benz_slk55_amg?(row)
      row['make_name'].downcase == 'mercedes-benz' and row['model_name'].downcase == 'slk55 amg' and row['year'] == 2005
    end
    
    def is_a_1995_ffv?(row)
      row['year'] == 1995 and row['model_name'] =~ / ffv$/i
    end
    
    def is_a_1999_ffv?(row)
      row['year'] == 1999 and row['model_name'] =~ / ffv$/i
    end
    
    def is_a_2000_ford_4wd_ffv?(row)
      row['year'] == 2000 and row['make_name'].downcase == 'ford' and row['drive'] == '4WD' and row['model_name'] =~ / ffv$/i
    end
    
    def is_2000_b3000_5_spd_4wd_ethanol_ucity_19?(row)
      row['year'] == 2000 and
        row['model_name'] =~ /b3000 ffv/i and
        row['speeds'] == '5' and
        row['drive'] == '4WD' and
        row['fuel_code'] == 'E' and
        row['ucty'].to_i == 19
    end
    
    def is_a_station_wagon?(row)
      row['size_class'] =~ /station wagons/i
    end
    
    %w{ hatchback justy loyale loyale_wagon space_wagon stanza_wagon wagon xt }.each do |model_name|
      method_name = :"is_a_#{model_name}?"
      define_method method_name do |row|
        row['model_name'] =~ /^#{model_name.gsub('_', ' ')}$/i
      end
    end
    
    def is_a_colt_vista_or_wagon?(row)
      row['model_name'] =~ /^colt [vw].+$/i
    end
    
    def is_a_subaru_sedan?(row)
      row['make_name'] =~ /subaru/i and row['model_name'] =~ /^sedan(\/.+)?$/i
    end
  end
  
  # To parse the FEG files
  class AutomobileMakeModelYearVariant::Parser
    attr_reader :year
    
    TRANSMISSIONS = {
      'A'   => 'Automatic',
      'L'   => 'Automatic',
      'M'   => 'Manual',
      'S'   => 'Semi-Automatic',
      'C'   => 'Continuously Variable',
      'AM'  => 'Automated Manual',
      'SA'  => 'Semi-Automatic',
      'CVT' => 'Continuously Variable',
      'SCV' => 'Selectable Continuously Variable',
      'OT'  => 'Other'
    }
    
    ENGINE_TYPES = {
      '(GUZZLER)'  => nil, # "gas guzzler"
      '(POLICE)'   => nil, # police automobile_variant
      '(MPFI)'     => 'injection',
      '(MPI*)'     => 'injection',
      '(SPFI)'     => 'injection',
      '(FFS)'      => nil, # doesn't necessarily mean fuel injection
      '(TURBO)'    => 'turbo',
      '(TRBO)'     => 'turbo',
      '(TC*)'      => 'turbo',
      '(FFS,TRBO)' => 'turbo',
      '(S-CHARGE)' => 'supercharger',
      '(SC*)'      => 'supercharger',
      '(DIESEL)'   => nil, # diesel
      '(DSL)'      => nil, # diesel
      '(ROTARY)'   => nil, # rotary
      '(VARIABLE)' => nil, # variable displacement
      '(NO-CAT)'   => nil, # no catalytic converter
      '(OHC)'      => nil, # overhead camshaft
      '(OHV)'      => nil, # overhead valves
      '(16-VALVE)' => nil, # 16V
      '(305)'      => nil, # 305 cubic inch displacement
      '(307)'      => nil, # 307 cubic inch displacement
      '(M-ENG)'    => nil,
      '(W-ENG)'    => nil,
      '(GM-BUICK)' => nil,
      '(GM-CHEV)'  => nil,
      '(GM-OLDS)'  => nil,
      '(GM-PONT)'  => nil
    }
    
    FUEL_CODES = {
      'BE'  => 'EL', # battery electric
      'CNG' => 'C',  # CNG
      'DU'  => 'D',  # diesel (ultra-low sulphur)
      'E'   => 'E',  # ethanol
      'EL'  => 'EL', # electric
      'G'   => 'R',  # regular gasoline
      'GP'  => 'P',  # premium gasoline recommended
      'GPR' => 'P',  # premium gasoline required
      'GM'  => 'P',  # midgrade gasoline recommended
      'H'   => 'H',  # hydrogen
      'PE'  => 'EL'  # plug-in electric
    }
    
    CLASS_CODES = {
      '1' => 'Two seaters',
      '2' => 'Minicompact cars',
      '3' => 'Subcompact cars',
      '4' => 'Compact cars',
      '5' => 'Midsize cars',
      '6' => 'Large cars',
      '7' => 'Small station wagons',
      '8' => 'Midsize station wagons',
      '9' => 'Large station wagons',
      '10' => 'Small pickup trucks 2WD',
      '11' => 'Small pickup trucks 4WD',
      '12' => 'Standard pickup trucks 2WD',
      '13' => 'Standard pickup trucks 4WD',
      '14' => 'Cargo vans',
      '15' => 'Passenger vans',
      '16' => nil,
      '17' => 'Special purpose vehicles 2WD',
      '18' => 'Special purpose vehicles 4WD',
      '19' => 'Special purpose vehicles'
    }
    
    def initialize(options = {})
      options = options.stringify_keys
      @year = options['year']
    end
    
    def apply(row)
      # Pre-2010 fuel efficiencies need to be adjusted downwards to reflect real-world driving
      # We do this by applying equations to the *unadjusted* city and highway fuel efficiency
      # Source for the equations is EPA Fuel Economy Trends report Appendix A
      # Starting in 2008 we could use the *adjusted* values from the FEG but this would require writing a new case for 2008 and 2009
      # Starting in 2010 we use the *adjusted* fuel efficiencies from the FEG
      case year
      when (1985..1997)
        row.merge!({
          'make_name'               => row['carline_mfr_name'],
          'model_name'              => row['carline_name'],
          'year'                    => year,
          'transmission'            => TRANSMISSIONS[row['model_trans'][0,1].to_s],
          'speeds'                  => (row['model_trans'][1,1] == 'V') ? 'variable' : row['model_trans'][1,1],
          'drive'                   => row['drive_system'],
          'fuel_code'               => row['fuel_type'],
          'fuel_efficiency_city'    => 1.0 / (0.003259 + (1.1805 / row['unadj_city_mpg'].to_f)), # adjust for real-world driving
          'fuel_efficiency_highway' => 1.0 / (0.001376 + (1.3466 / row['unadj_hwy_mpg'].to_f)),  # adjust for real-world driving
          'cylinders'               => row['no_cyl'],
          'displacement'            => _displacement(row),
          'turbo'                   => _turbo(row),
          'supercharger'            => [ENGINE_TYPES[row['engine_desc1'].to_s], ENGINE_TYPES[row['engine_desc2'].to_s]].flatten.include?('supercharger'),
          'injection'               => (row['fuel_system'] == 'FI') ? true : false,
          'size_class'              => CLASS_CODES[row['size_class']]
        })
      when (1998..2009)
        row.merge!({
          'make_name'               => row['Manufacturer']  || row['MFR'],
          'model_name'              => (row['carline name'] || row['CAR LINE']).upcase,
          'year'                    => year,
          'transmission'            => TRANSMISSIONS[(row['trans'] || row['TRANS'])[-3,1]],
          'speeds'                  => ((row['trans'] || row['TRANS'])[-2,1] == 'V') ? 'variable' : (row['trans'] || row['TRANS'])[-2,1],
          'drive'                   => ((row['drv'] || row['DRIVE SYS']) + 'WD').gsub('.0', ''),
          'fuel_code'               => row['fl']    || row['FUEL TYPE'],
          'fuel_efficiency_city'    => 1.0 / (0.003259 + (1.1805 / (row['ucty'] || row['UNRND CITY (EPA)']).to_f)), # adjust for real-world driving
          'fuel_efficiency_highway' => 1.0 / (0.001376 + (1.3466 / (row['uhwy'] || row['UNRND HWY (EPA)']).to_f)),  # adjust for real-world driving
          'cylinders'               => row['cyl']   || row['NUMB CYL'],
          'displacement'            => row['displ'] || row['DISPLACEMENT'],
          'turbo'                   => ((row['T'] || row['TURBO']) == 'T' || (row['carline name'] || row['CAR LINE']).downcase.include?('turbo')) ? true : false,
          'supercharger'            => (row['S'] || row['SPCHGR']) == 'S',
          'injection'               => true,
          'size_class'              => row['Class'] || row['CLASS']
        })
      else # 2010..present
        row.merge!({
          'make_name'                   => row['Division'],
          'model_name'                  => row['Carline'].upcase,
          'year'                        => year,
          'transmission'                => TRANSMISSIONS[row['Trans']],
          'speeds'                      => row['# Gears'].to_i,
          'drive'                       => row['Drive Sys'] + 'WD',
          'fuel_code'                   => FUEL_CODES[row['Fuel Usage  - Conventional Fuel']],
          'fuel_efficiency_city'        => row['City FE (Guide) - Conventional Fuel'],
          'fuel_efficiency_highway'     => row['Hwy FE (Guide) - Conventional Fuel'],
          'alt_fuel_code'               => FUEL_CODES[row[' Fuel2 Usage - Alternative Fuel']],
          'alt_fuel_efficiency_city'    => row['City2 FE (Guide) - Alternative Fuel'],
          'alt_fuel_efficiency_highway' => row['Hwy2 Fuel FE (Guide) - Alternative Fuel'],
          'cylinders'                   => row['# Cyl'],
          'displacement'                => row['Eng Displ'],
          'turbo'                       => row['Air Aspir Method'] == 'TC',
          'supercharger'                => row['Air Aspir Method'] == 'SC',
          'injection'                   => row['# Cyl'].present? ? true : false,
          'size_class'                  => row['Carline Class Desc']
        })
      end
    end
    
    def _displacement(row)
      optional_displacement = row['opt_disp'].gsub(/[\(\)]/, '').strip.to_s
      if optional_displacement =~ /^(\d\.\d)L$/
        $1.to_f
      elsif optional_displacement =~ /^(\d{4})CC$/
        ($1.to_f / 1000).round(1)
      else
        row['disp_cub_in'].to_f.cubic_inches.to(:litres).round(1)
      end
    end
    
    def _turbo(row)
      engine_types = [ENGINE_TYPES[row['engine_desc1'].to_s], ENGINE_TYPES[row['engine_desc2'].to_s]]
      engine_types << (row['model_name'].to_s.downcase.include?('turbo') ? 'turbo' : nil)
      engine_types.flatten.include?('turbo')
    end
    
    # for the 1985-1997 fuel economy guides
    ::FixedWidth.define :fuel_economy_guide do |d|
      d.rows do |row|
        row.trap { true } # there's only one section
        row.column 'active_year',       4, :type => :integer # ACTIVE YEAR
        row.column 'state_code',        1, :type => :string  # STATE CODE:  F=49-STATE,C=CALIFORNIA
        row.column 'size_class',        2, :type => :integer # CARLINE CLASS CODE
        row.column 'carline_mfr_code',  3, :type => :integer # CARLINE MANUFACTURER CODE
        row.column 'carline_name',     28, :type => :string  # CARLINE NAME
        row.column 'disp_cub_in',       4, :type => :integer # DISP CUBIC INCHES
        row.column 'fuel_system',       2, :type => :string  # FUEL SYSTEM: 'FI' FOR FUEL INJECTION, 2-DIGIT INTEGER VALUE FOR #OF VENTURIES IF CARBURETOR SYSTEM.
        row.column 'model_trans',       6, :type => :string  # TRANSMISSION TYPE
        row.column 'no_cyl',            2, :type => :integer # NUMBER OF ENGINE CYLINDERS
        row.column 'date_time',        12, :type => :string  # DATE AND TIME RECORD ENTERED -YYMMDDHHMMSS (YEAR, MONTH, DAY, HOUR, MINUTE, SECOND)
        row.column 'release_date',      6, :type => :string  # RELEASE DATE - YYMMDD (YEAR, MONTH, DAY)
        row.column 'vi_mfr_code',       3, :type => :integer # VI MANUFACTURER CODE
        row.column 'carline_code',      5, :type => :integer # CARLINE CODE
        row.column 'basic_eng_id',      5, :type => :integer # BASIC ENGINE INDEX
        row.column 'carline_mfr_name', 32, :type => :string  # CARLINE MANUFACTURER NAME
        row.column 'suppress_code',     1, :type => :integer # SUPPRESSION CODE (NO SUPPRESSED RECORD IF FOR PUBLIC ACCESS)
        row.column 'city_mpg',          3, :type => :integer # ESTIMATED (CITY) MILES PER GALLON - 90% OF UNADJUSTED VALUE
        row.spacer 2
        row.column 'highway_mpg',       3, :type => :integer # ESTIMATED (HWY) MILES PER GALLON - 78% OF UNADJUSTED VALUE
        row.spacer 2
        row.column 'combined_mpg',      3, :type => :integer # COMBINED MILES PER GALLON
        row.spacer 2
        row.column 'unadj_city_mpg',    3, :type => :integer # UNADJUSTED  CITY MILES PER GALLON
        row.spacer 2
        row.column 'unadj_hwy_mpg',     3, :type => :integer # UNADJUSTED HIGHWAY MILES PER GALLON
        row.spacer 2
        row.column 'unadj_comb_mpg',    3, :type => :integer # UNADJUSTED COMBINED MILES PER GALLON
        row.spacer 2
        row.column 'ave_anl_fuel',      6, :type => :integer # "$" in col 147, Annual Fuel Cost starting col 148 in I5
        row.column 'opt_disp',          8, :type => :string  # OPTIONAL DISPLACEMENT
        row.column 'engine_desc1',     10, :type => :string  # ENGINE DESCRIPTION 1
        row.column 'engine_desc2',     10, :type => :string  # ENGINE DESCRIPTION 2
        row.column 'engine_desc3',     10, :type => :string  # ENGINE DESCRIPTION 3
        row.column 'body_type_2d',     10, :type => :string  # BODY TYPE 2 DOOR - IF THE BODY TYPE APPLIES IT WILL TAKE THE FORM '2DR-PPP/LL' WHERE PPP=PASSENGER INTERIOR VOLUME AND LL=LUGGAGE INTERIOR VOLUME.
        row.column 'body_type_4d',     10, :type => :string  # BODY TYPE 4 DOOR - IF THE BODY TYPE APPLIES IT WILL TAKE THE FORM '4DR-PPP/LL' WHERE PPP=PASSENGER INTERIOR VOLUME AND LL=LUGGAGE INTERIOR VOLUME.
        row.column 'body_type_hbk',    10, :type => :string  # BODY TYPE HBK    - IF THE BODY TYPE APPLIES IT WILL TAKE THE FORM 'HBK-PPP/LL' WHERE PPP=PASSENGER INTERIOR VOLUME AND LL=LUGGAGE INTERIOR VOLUME.
        row.column 'puerto_rico',       1, :type => :string  # '*' IF FOR PUERTO RICO SALES ONLY
        row.column 'overdrive',         4, :type => :string  # OVERDRIVE:  ' OD ' FOR OVERDRIVE, 'EOD ' FOR ELECTRICALLY OPERATED OVERDRIVE AND 'AEOD' FOR AUTOMATIC OVERDRIVE
        row.column 'drive_system',      3, :type => :string  # FWD=FRONT WHEEL DRIVE, RWD=REAR,  4WD=4-WHEEL
        row.column 'filler',            1, :type => :string  # NOT USED
        row.column 'fuel_type',         1, :type => :string  # R=REGULAR(UNLEADED), P=PREMIUM,  D=DIESEL
        row.column 'trans_desc',       15, :type => :string  # TRANSMISSION DESCRIPTORS
      end
    end
  end
  
  data_miner do
    fuel_economy_guides = (1985..1997).inject({}) do |memo, year|
      yy = year.to_s[2..3]
      memo[year] = {
        :url => "http://www.fueleconomy.gov/FEG/epadata/#{yy}mfgui.zip",
        :filename => ((yy == "96") ? "#{yy}MFGUI.ASC" : "#{yy}MFGUI.DAT"),
        :format => :fixed_width,
        :schema_name => :fuel_economy_guide,
        :cut => ((yy == "95") ? '13-' : nil),
        :select => proc { |row| row['model_name'].present? and (row['suppress_code'].blank? or row['suppress_code'].to_f == 0) and row['state_code'] == 'F' }
      }
      memo
    end
    
    fuel_economy_guides.merge!({
      1998 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/98guide6.zip', :filename => '98guide6.csv' },
      1999 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/99guide.zip',  :filename => '99guide6.csv' },
      2000 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/00data.zip',   :filename => 'G6080900.xls' },
      2001 => { :url => 'http://static.brighterplanet.com/science/data/transport/automobiles/fuel_economy_guide/01guide0918.csv' }, # parseexcel 0.5.2 can't read Excel 5.0 { :url => 'http://www.fueleconomy.gov/FEG/epadata/01data.zip', :filename => '01guide0918.xls' }
      2002 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/02data.zip',   :filename => 'guide_jan28.xls' },
      2003 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/03data.zip',   :filename => 'guide_2003_feb04-03b.csv' },
      2004 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/04data.zip',   :filename => 'gd04-Feb1804-RelDtFeb20.csv' },
      2005 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/05data.zip',   :filename => 'guide2005-2004oct15.csv' },
      2006 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/06data.zip',   :filename => '2006_FE_Guide_14-Nov-2005_download.csv' },
      2007 => { :url => 'http://static.brighterplanet.com/science/data/transport/automobiles/fuel_economy_guide/2007_FE_guide_ALL_no_sales_May_01_2007.csv' }, # the 07data.xls file provided by the government has a bad encoding
      2008 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/08data.zip',   :filename => '2008_FE_guide_ALL_rel_dates_-no sales-for DOE-5-1-08.csv' },
      2009 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/09data.zip',   :filename => '2009_FE_guide for DOE_ALL-rel dates-no-sales-8-28-08download.csv' },
      2010 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/10data.zip',   :filename => '2010FEGuide for DOE-all rel dates-no-sales-02-22-2011public.xlsx' },
      2011 => { :url => 'http://www.fueleconomy.gov/FEG/epadata/11data.zip',   :filename => '2011FEGuide-for DOE rel-dates before 1-23-2011-no-sales-01-10-2011_All_public.xlsx' },
      2012 => { :url => 'http://www.fueleconomy.gov/feg/epadata/12data.zip',   :filename => '2012 FEGuide for DOE-rev1-rel dates before 3-13-2012-no-sales-3-7-2012public3-20.xlsx' }
    })
    
    fuel_economy_guides.each do |year, options|
      options.merge!({
        :transform => { :class => AutomobileMakeModelYearVariant::Parser, :year => year },
        :select    => (options[:select] || proc { |row| row['model_name'].present? }),
        :errata    => { 
                        :url => "file://#{Earth::ERRATA_DIR}/automobile_make_model_year_variant/feg_errata.csv",
                        :responder => "AutomobileMakeModelYearVariant::Guru"
                      }
      })
    end
    
    fuel_economy_guides.each do |year, options|
      process "Clear old data from #{year}" do
        where(:year => year).delete_all
      end
      
      import "#{year} Fuel Economy Guide", options do
        key   'row_hash'
        store 'make_name'
        store 'model_name'
        store 'year'
        store 'transmission'
        store 'speeds'
        store 'drive'
        store 'fuel_code'
        store 'fuel_efficiency_city',    :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'fuel_efficiency_highway', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'alt_fuel_code'
        store 'alt_fuel_efficiency_city',    :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'alt_fuel_efficiency_highway', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'cylinders'
        store 'displacement'
        store 'turbo'
        store 'supercharger'
        store 'injection'
        store 'size_class'
      end
    end
    
    # FIXME TODO hybrids listed on FEG website but not in downloadable files
    # 2001 Honda Insight (automatic, variable transmission) - listed twice on FEG website
    # 2003 Honda Civic Hybrid (manual, 5-speed, lower mpg)
    # 2003 Honda Civic Hybrid (automatic, variable transmission, higher mpg)
    # 2005 Honda Accord Hybrid
    # 2006 Honda Accord Hybrid
    # 2009 Chrysler Aspen HEV
    # 2009 Dodge Durango HEV
    # 2009 Saturn Vue Hybrid (automatic, variable transmission)
    process "Update the model names of certain hybrid variants" do
      hybrids = []
      if where(:make_name => 'Buick', :model_name => 'LACROSSE HYBRID', :year => 2012).none? and where(:make_name => 'Buick', :model_name => 'LACROSSE', :year => 2012, :alt_fuel_code => nil).any?
        hybrids << where(:make_name => 'Buick', :model_name => 'LACROSSE', :year => 2012, :alt_fuel_code => nil).first
      end
      if where(:make_name => 'Buick', :model_name => 'REGAL HYBRID', :year => 2012).none? and where(:make_name => 'Buick', :model_name => 'REGAL', :year => 2012, :alt_fuel_code => nil).any?
        hybrids << where(:make_name => 'Buick', :model_name => 'REGAL', :year => 2012, :alt_fuel_code => nil).sort_by!(&:fuel_efficiency_city).last
      end
      hybrids.each do |hybrid|
        hybrid.model_name += ' HYBRID'
        hybrid.save!
      end
    end
    
    process "Merge rows for dual-fuel Chevy Cavaliers (these are listed once for each fuel type)" do
      where(:make_name => 'Chevrolet', :model_name => 'CAVALIER DUAL-FUEL', :fuel_code => 'C').each do |cng_variant|
        gasoline_variant = where(:make_name => 'Chevrolet', :model_name => 'CAVALIER DUAL-FUEL', :fuel_code => ['R', 'P'], :alt_fuel_code => nil).find_by_year(cng_variant.year)
        %w{ fuel_code fuel_efficiency_city fuel_efficiency_city_units fuel_efficiency_highway fuel_efficiency_highway_units }.each do |attribute|
          gasoline_variant.send("alt_#{attribute}=", cng_variant.send(attribute))
        end
        gasoline_variant.save!
        cng_variant.destroy
      end
    end
    
    process "Update model name to indicate CNG variants" do
      where("fuel_code = 'C' AND model_name NOT LIKE '% CNG'").update_all "model_name = model_name || ' CNG'"
    end
    
    process "Merge rows for flex-fuel vehicles (these are listed once for each fuel type)" do
      where(:fuel_code => 'E').each do |ethanol_variant|
        gasoline_variant = where(%{
          (fuel_code = 'R' OR fuel_code = 'P')
          AND alt_fuel_code IS NULL
          AND make_name    = ?
          AND model_name   = ?
          AND year         = ?
          AND transmission = ?
          AND speeds       = ?
          AND drive        = ?
          AND cylinders    = ?
          AND displacement < ?
          AND displacement > ?
        },
          ethanol_variant.make_name,
          ethanol_variant.model_name,
          ethanol_variant.year,
          ethanol_variant.transmission,
          ethanol_variant.speeds,
          ethanol_variant.drive,
          ethanol_variant.cylinders,
          (ethanol_variant.displacement + 0.01),
          (ethanol_variant.displacement - 0.01)
        ).first
        
        if gasoline_variant.present?
          %w{ fuel_code fuel_efficiency_city fuel_efficiency_city_units fuel_efficiency_highway fuel_efficiency_highway_units }.each do |attribute|
            gasoline_variant.send("alt_#{attribute}=", ethanol_variant.send(attribute))
          end
          gasoline_variant.save!
          ethanol_variant.destroy
        end
      end
    end
    
    process "Update model name to indicate flex-fuel variants of models where variants in some years are not flex-fuel" do
      where("alt_fuel_code = 'E' AND model_name NOT LIKE '% FFV'").each do |variant|
        if where(:make_name => variant.make_name, :model_name => variant.model_name, :alt_fuel_code => nil).any?
          variant.model_name += ' FFV'
          variant.save!
        end
      end
    end
    
    process "Update model name to indicate diesel variants of models where variants in some years are not diesel" do
      where("fuel_code = 'D' AND model_name NOT LIKE '% DIESEL'").each do |variant|
        if where("make_name = ? AND model_name = ? AND fuel_code != 'D'", variant.make_name, variant.model_name).any?
          variant.model_name += ' DIESEL'
          variant.save!
        end
      end
    end
    
    # Combined fuel efficiency will be useful for deriving fuel efficiency for other classes
    # NOTE: we use a 43/57 city/highway weighting per the latest EPA analysis of real-world driving behavior
    # This results in a deviation from EPA fuel economy label values which use a historical 55/45 weighting
    process "Calculate combined adjusted fuel efficiency using the latest EPA equation" do
      where("fuel_efficiency_city IS NOT NULL AND fuel_efficiency_highway IS NOT NULL").update_all(%{
        fuel_efficiency = 1.0 / ((0.43 / fuel_efficiency_city) + (0.57 / fuel_efficiency_highway)),
        fuel_efficiency_units = 'kilometres_per_litre'
      })
      where("alt_fuel_efficiency_city IS NOT NULL AND alt_fuel_efficiency_highway IS NOT NULL").update_all(%{
        alt_fuel_efficiency = 1.0 / ((0.43 / alt_fuel_efficiency_city) + (0.57 / alt_fuel_efficiency_highway)),
        alt_fuel_efficiency_units = 'kilometres_per_litre'
      })
    end
  end
end
