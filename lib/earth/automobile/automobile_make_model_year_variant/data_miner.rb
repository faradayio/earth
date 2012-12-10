require 'earth/automobile/automobile_make_model_year_variant/parser'

AutomobileMakeModelYearVariant.class_eval do
  # For errata
  class AutomobileMakeModelYearVariant::Guru
    %w{ alpina bentley chevrolet chrysler dodge ferrari ford gmc jaguar kia lexus maybach mercedes-benz mitsubishi porsche toyota tvr volvo yugo }.each do |make|
      method_name = "is_a_#{make.gsub('-', '_')}?"
      define_method method_name do |row|
        row['make_name'].downcase == make
      end
    end
    
    %w{ alpina bentley marquis maybach milan mystique scion smart }.each do |model_name|
      method_name = "model_contains_#{model_name}?"
      define_method method_name do |row|
        row['model_name'].to_s =~ /#{model_name}/i
      end
    end
    
    [["ford", "contour"], ["hyundai", "sonata"], ["jaguar", "xjr"], ["jaguar", "xjs convertible"], ["jaguar", "xjs coupe"], ["mercury", "mystique"], ["mitsubishi", "mirage"], ["volvo", "850"], ["volvo", "850 wagon"], ["volvo", "940"], ["volvo", "940 wagon"]].each do |make_name, model_name|
      method_name = "is_a_1995_#{make_name}_#{model_name.gsub(' ', '_')}_missing_fuel_efficiency?"
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
    
    %w{ 5 hatchback justy loyale loyale_wagon odyssey pt_cruiser_convertible space_wagon stanza_wagon wagon xt }.each do |model_name|
      method_name = "is_a_#{model_name}?"
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
      2012 => { :url => 'http://www.fueleconomy.gov/feg/epadata/12data.zip',   :filename => '2012 FEGuide-for DOE-OK to release-no-sales-11-13-2012public.xlsx' }
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
        hybrid.update_attributes! :model_name => hybrid.model_name + ' HYBRID'
      end
    end
    
    process "Merge rows for dual-fuel Chevy Cavaliers (these are listed once for each fuel type)" do
      where(:make_name => 'Chevrolet', :model_name => 'CAVALIER DUAL-FUEL', :fuel_code => 'C').each do |cng_variant|
        gasoline_variant = where(:make_name => 'Chevrolet', :model_name => 'CAVALIER DUAL-FUEL', :fuel_code => ['R', 'P'], :alt_fuel_code => nil).find_by_year(cng_variant.year)
        %w{ fuel_code fuel_efficiency_city fuel_efficiency_city_units fuel_efficiency_highway fuel_efficiency_highway_units }.each do |attribute|
          gasoline_variant.update_attributes! "alt_#{attribute}" => cng_variant.send(attribute)
        end
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
            gasoline_variant.update_attributes! "alt_#{attribute}" => ethanol_variant.send(attribute)
          end
          ethanol_variant.destroy
        end
      end
    end
    
    process "Update model name to indicate flex-fuel variants of models where variants in some years are not flex-fuel" do
      where("alt_fuel_code = 'E' AND model_name NOT LIKE '% FFV'").each do |variant|
        if where(:make_name => variant.make_name, :model_name => variant.model_name, :alt_fuel_code => nil).any?
          variant.update_attributes! :model_name => variant.model_name + ' FFV'
        end
      end
    end
    
    process "Update model name to indicate diesel variants of models where variants in some years are not diesel" do
      where("fuel_code = 'D' AND model_name NOT LIKE '% DIESEL'").each do |variant|
        if where("make_name = ? AND model_name = ? AND fuel_code != 'D'", variant.make_name, variant.model_name).any?
          variant.update_attributes! :model_name => variant.model_name + ' DIESEL'
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
    
    process "Derive type name from size class" do
      where(:size_class => [
        'Two seaters',
        'Minicompact cars',
        'Subcompact cars',
        'Compact cars',
        'Midsize cars',
        'Large cars',
        'Small station wagons',
        'Midsize station wagons',
        'Large station wagons'
      ]).update_all "type_name = 'Passenger cars'"
      where(:type_name => nil).update_all "type_name = 'Light-duty trucks'"
    end
  end
end
