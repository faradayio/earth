require 'earth/automobile/automobile_make_model_year_variant'

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
        'speeds'                  => row['model_trans'][1,1] == 'V' ? 'variable' : row['model_trans'][1,1],
        'drive'                   => row['drive_system'],
        'fuel_code'               => row['fuel_type'],
        'fuel_efficiency_city'    => 1.0 / (0.003259 + (1.1805 / row['unadj_city_mpg'].to_f)), # adjust for real-world driving
        'fuel_efficiency_highway' => 1.0 / (0.001376 + (1.3466 / row['unadj_hwy_mpg'].to_f)),  # adjust for real-world driving
        'cylinders'               => row['no_cyl'],
        'displacement'            => _displacement(row),
        'turbo'                   => _turbo(row),
        'supercharger'            => [ENGINE_TYPES[row['engine_desc1'].to_s], ENGINE_TYPES[row['engine_desc2'].to_s]].flatten.include?('supercharger'),
        'injection'               => row['fuel_system'] == 'FI' ? true : false
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
        'carline_class'           => row['Class'] || row['CLASS']
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
        'carline_class'               => row['Carline Class Desc']
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
  
  ::FixedWidth.define :fuel_economy_guide do |d|
    d.rows do |row|
      row.trap { true } # there's only one section
      row.column 'active_year',       4, :type => :integer # ACTIVE YEAR
      row.column 'state_code',        1, :type => :string  # STATE CODE:  F=49-STATE,C=CALIFORNIA
      row.column 'carline_clss',      2, :type => :integer # CARLINE CLASS CODE
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
