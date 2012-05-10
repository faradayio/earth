require 'ruby-debug'
require 'earth/automobile/automobile_make_model_year_variant/parser'

AutomobileMakeModelYearVariant.class_eval do
  # For errata
  class AutomobileMakeModelYearVariant::Guru
    %w{ alpina bentley chevrolet dodge ferrari ford jaguar kia lexus maybach mercedes-benz mitsubishi porsche toyota tvr volvo yugo }.each do |make|
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
        row['year'] == 1995 and row['make_name'].downcase == make_name and row['model_name'].downcase == model_name and (row['raw_fuel_efficiency_city'].blank? or row['raw_fuel_efficiency_highway'].blank?)
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
  end
  
  data_miner do
    # FIXME TODO 2005 Mercedes-Benz SLK55 AMG has NULL speeds (it does in the EPA FEG also)
    
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
      import "#{year} Fuel Economy Guide", options do
        key   'row_hash'
        store 'make_name'
        store 'model_name'
        store 'year'
        store 'transmission'
        store 'speeds'
        store 'drive'
        store 'fuel_code'
        store 'raw_fuel_efficiency_city',    :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'raw_fuel_efficiency_highway', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'alt_fuel_code'
        store 'alt_raw_fuel_efficiency_city',    :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'alt_raw_fuel_efficiency_highway', :from_units => :miles_per_gallon, :to_units => :kilometres_per_litre
        store 'cylinders'
        store 'displacement'
        store 'turbo'
        store 'supercharger'
        store 'injection'
        store 'carline_class'
      end
    end
    
    # Note: equation designed for miles / gallon so need to convert to km / l
    # Note: EPA seems to adjust differently for plug-in hybrid electric vehicles (e.g. Leaf and Volt)
    process "Calculate adjusted fuel efficiency using the latest EPA equations from EPA Fuel Economy Trends report Appendix A including conversion from miles per gallon to kilometres per litre" do
      where("raw_fuel_efficiency_city IS NOT NULL").update_all(%{
        fuel_efficiency_city = 1.0 / ((0.003259 / #{1.miles_per_gallon.to(:kilometres_per_litre)}) + (1.1805 / raw_fuel_efficiency_city)),
        fuel_efficiency_city_units = 'kilometres_per_litre'
      })
      where("raw_fuel_efficiency_highway IS NOT NULL").update_all(%{
        fuel_efficiency_highway = 1.0 / ((0.001376 / #{1.miles_per_gallon.to(:kilometres_per_litre)}) + (1.3466 / raw_fuel_efficiency_highway)),
        fuel_efficiency_highway_units = 'kilometres_per_litre'
      })
      where("alt_raw_fuel_efficiency_city IS NOT NULL").update_all(%{
        alt_fuel_efficiency_city = 1.0 / ((0.003259 / #{1.miles_per_gallon.to(:kilometres_per_litre)}) + (1.1805 / alt_raw_fuel_efficiency_city)),
        alt_fuel_efficiency_city_units = 'kilometres_per_litre'
      })
      where("alt_raw_fuel_efficiency_highway IS NOT NULL").update_all(%{
        alt_fuel_efficiency_highway = 1.0 / ((0.001376 / #{1.miles_per_gallon.to(:kilometres_per_litre)}) + (1.3466 / alt_raw_fuel_efficiency_highway)),
        alt_fuel_efficiency_highway_units = 'kilometres_per_litre'
      })
    end
    
    # This will be useful later for calculating MakeModel and Make fuel efficiency based on Variant
    # NOTE: we use a 43/57 city/highway weighting per the latest EPA analysis of real-world driving behavior
    # This results in a deviation from EPA fuel economy label values which use a historical 55/45 weighting
    process "Calculate combined adjusted fuel efficiency using the latest EPA equation" do
      update_all(%{
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
