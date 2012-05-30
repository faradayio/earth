# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'earth/automobile/automobile_make_model_year_variant'
require 'earth/acronyms' # lets us use AMMYV to refer to AutomobileMakeModelYearVariant

describe AutomobileMakeModelYearVariant do
  before :all do
    Earth.init :automobile, :load_data_miner => true, :skip_parent_associations => :true
  end
  
  describe 'import', :data_miner => true do
    it 'should import data' do
      AMMYV.run_data_miner!
      AMMYV.count.should == 28433
    end
  end
  
  describe 'verify imported data', :sanity => true do
    # confirm we have right data from all years
    it { AMMYV.where(:year => 1985).count.should == 1152 }
    it { AMMYV.where(:year => 1986).count.should == 1183 }
    it { AMMYV.where(:year => 1987).count.should == 1206 }
    it { AMMYV.where(:year => 1988).count.should == 1104 }
    it { AMMYV.where(:year => 1989).count.should == 1137 }
    it { AMMYV.where(:year => 1990).count.should == 1049 }
    it { AMMYV.where(:year => 1991).count.should == 1062 }
    it { AMMYV.where(:year => 1992).count.should == 1055 }
    it { AMMYV.where(:year => 1993).count.should ==  986 }
    it { AMMYV.where(:year => 1994).count.should ==  963 }
    it { AMMYV.where(:year => 1995).count.should ==  917 }
    it { AMMYV.where(:year => 1996).count.should ==  750 }
    it { AMMYV.where(:year => 1997).count.should ==  727 }
    it { AMMYV.where(:year => 1998).count.should ==  794 }
    it { AMMYV.where(:year => 1999).count.should ==  800 }
    it { AMMYV.where(:year => 2000).count.should ==  834 }
    it { AMMYV.where(:year => 2001).count.should ==  846 }
    it { AMMYV.where(:year => 2002).count.should ==  933 }
    it { AMMYV.where(:year => 2003).count.should ==  995 }
    it { AMMYV.where(:year => 2004).count.should == 1091 }
    it { AMMYV.where(:year => 2005).count.should == 1069 }
    it { AMMYV.where(:year => 2006).count.should == 1043 }
    it { AMMYV.where(:year => 2007).count.should == 1126 }
    it { AMMYV.where(:year => 2008).count.should == 1186 }
    it { AMMYV.where(:year => 2009).count.should == 1092 }
    it { AMMYV.where(:year => 2010).count.should == 1107 }
    it { AMMYV.where(:year => 2011).count.should == 1097 }
    it { AMMYV.where(:year => 2012).count.should == 1129 }
    
    # confirm make, model, year, and size class aren't missing
    it { AMMYV.where(:make_name => nil).count.should == 0 }
    it { AMMYV.where(:model_name => nil).count.should == 0 }
    it { AMMYV.where(:year => nil).count.should == 0 }
    it { AMMYV.where(:size_class => nil).count.should == 0 }
    
    it 'should have valid transmissions' do
      AMMYV.connection.select_values("SELECT DISTINCT transmission FROM #{AMMYV.quoted_table_name}").each do |transmission|
        fail "#{transmission} is not a valid transmission" unless AMMYV::Parser::TRANSMISSIONS.values.include?(transmission)
      end
    end
    
    it 'should have valid speeds' do
      valid_speeds = ["1", "3", "4", "5", "6", "7", "8", "variable"]
      AMMYV.connection.select_values("SELECT DISTINCT speeds FROM #{AMMYV.quoted_table_name}").each do |speeds|
        fail "#{speeds} is not a valid speeds" unless valid_speeds.include?(speeds)
      end
    end
    
    it 'should have valid drives' do
      valid_drives = ["FWD", "RWD", "4WD", "AWD", "PWD"] # PWD = part-time 4-wheel drive
      AMMYV.connection.select_values("SELECT DISTINCT drive FROM #{AMMYV.quoted_table_name}").each do |drive|
        fail "#{drive} is not a valid drive" unless valid_drives.include?(drive)
      end
    end
    
    it 'should have valid fuel codes' do
      AMMYV.connection.select_values("SELECT DISTINCT fuel_code FROM #{AMMYV.quoted_table_name}").each do |code|
        fail "#{code} is not a valid code" unless AMMYV::Parser::FUEL_CODES.values.include?(code)
      end
    end
    
    it 'should have valid alt fuel codes' do
      AMMYV.connection.select_values("SELECT DISTINCT alt_fuel_code FROM #{AMMYV.quoted_table_name} WHERE alt_fuel_code IS NOT NULL").each do |code|
        fail "#{code} is not a valid code" unless AMMYV::Parser::FUEL_CODES.values.include?(code)
      end
    end
    
    # confirm fuel efficiencies are valid and proper units
    it { AMMYV.where("fuel_efficiency > 0").count.should == AMMYV.count }
    it { AMMYV.where("fuel_efficiency_city > 0").count.should == AMMYV.count }
    it { AMMYV.where("fuel_efficiency_highway > 0").count.should == AMMYV.count }
    it { AMMYV.where(:fuel_efficiency_units => 'kilometres_per_litre').count.should == AMMYV.count }
    it { AMMYV.where(:fuel_efficiency_city_units => 'kilometres_per_litre').count.should == AMMYV.count }
    it { AMMYV.where(:fuel_efficiency_highway_units => 'kilometres_per_litre').count.should == AMMYV.count }
    
    # confirm alt fuel efficiencies are valid and proper units
    it { AMMYV.where("alt_fuel_efficiency > 0").count.should == AMMYV.where("alt_fuel_code IS NOT NULL").count }
    it { AMMYV.where("alt_fuel_efficiency_city > 0").count.should == AMMYV.where("alt_fuel_code IS NOT NULL").count }
    it { AMMYV.where("alt_fuel_efficiency_highway > 0").count.should == AMMYV.where("alt_fuel_code IS NOT NULL").count }
    it { AMMYV.where(:alt_fuel_efficiency_units => 'kilometres_per_litre').count.should == AMMYV.where("alt_fuel_code IS NOT NULL").count }
    it { AMMYV.where(:alt_fuel_efficiency_city_units => 'kilometres_per_litre').count.should == AMMYV.where("alt_fuel_code IS NOT NULL").count }
    it { AMMYV.where(:alt_fuel_efficiency_highway_units => 'kilometres_per_litre').count.should == AMMYV.where("alt_fuel_code IS NOT NULL").count }
    
    # confirm flex-fuel variants of models where not all variants are flex-fuel have been identified
    it { AMMYV.find(:first, :conditions => {:year => 2012, :make_name => 'Toyota', :model_name => 'SEQUOIA FFV'}).alt_fuel_code.should == 'E' }
    it { AMMYV.find(:first, :conditions => {:year => 2012, :make_name => 'Toyota', :model_name => 'SEQUOIA'}).alt_fuel_code.should == nil }
    
    # confirm certain hybrids have been identified
    it { AMMYV.where(:year => 2012, :make_name => 'Buick', :model_name => 'LACROSSE HYBRID').count.should == 1 }
    it { AMMYV.where(:year => 2012, :make_name => 'Buick', :model_name => 'REGAL HYBRID').count.should == 1 }
    
    # confirm dual-fuel and CNG variants have been merged and identified
    it { AMMYV.where(:make_name => 'Chevrolet', :model_name => 'CAVALIER DUAL-FUEL', :fuel_code => 'C').count.should == 0 }
    it { AMMYV.where(:make_name => 'Chevrolet', :model_name => 'CAVALIER DUAL-FUEL', :fuel_code => 'R', :alt_fuel_code => 'C').count.should == 5 }
    it { AMMYV.where(:fuel_code => 'C').count.should == AMMYV.where("model_name LIKE '%CNG'").count }
    
    # confirm FFV variants have been merged and identified
    it { AMMYV.where(:fuel_code => 'E').count.should == 0 }
    it { AMMYV.where(:alt_fuel_code => 'E').count.should > 0 }
    it { AMMYV.where("model_name LIKE '%FFV'").count.should > 0 }
    
    # confirm Chevy and GMC model names have been simplified
    it { AMMYV.where("make_name IN ('Chevrolet', 'GMC') AND model_name REGEXP '^[CK][0-9]+'").count.should == 0 }
    
    # spot check fuel efficiency calcs
    it { AMMYV.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_city.should    be_within(0.0001).of(14.8800) }
    it { AMMYV.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_highway.should be_within(0.0001).of(17.0057) }
    it { AMMYV.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency.should         be_within(0.0001).of(16.0216) }
    
    it { AMMYV.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_city.should    be_within(0.0001).of(40.3887) }
    it { AMMYV.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_highway.should be_within(0.0001).of(39.5384) }
    it { AMMYV.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency.should         be_within(0.0001).of(39.8996) }
    
    it { AMMYV.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_city.should    be_within(0.0001).of(14.8800) }
    it { AMMYV.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_highway.should be_within(0.0001).of(17.0057) }
    it { AMMYV.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency.should         be_within(0.0001).of(16.0216) }
    
    it { AMMYV.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_city.should    be_within(0.0001).of(40.3887) }
    it { AMMYV.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_highway.should be_within(0.0001).of(38.2629) }
    it { AMMYV.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency.should         be_within(0.0001).of(39.1489) }
    
    it { AMMYV.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).fuel_efficiency_city.should    be_within(0.0001).of( 8.0777) }
    it { AMMYV.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).fuel_efficiency_highway.should be_within(0.0001).of(11.4789) }
    it { AMMYV.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).fuel_efficiency.should         be_within(0.0001).of( 9.7192) }
    
    it { AMMYV.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).alt_fuel_efficiency_city.should    be_within(0.0001).of(5.9520) }
    it { AMMYV.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).alt_fuel_efficiency_highway.should be_within(0.0001).of(8.5029) }
    it { AMMYV.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).alt_fuel_efficiency.should         be_within(0.0001).of(7.1797) }
    
    it { AMMYV.find(:first, :conditions => {:year => 2009, :make_name => 'Toyota', :model_name => 'PRIUS'}).fuel_efficiency_city.should    be_within(0.0001).of(20.2602) }
    it { AMMYV.find(:first, :conditions => {:year => 2009, :make_name => 'Toyota', :model_name => 'PRIUS'}).fuel_efficiency_highway.should be_within(0.0001).of(19.1879) }
    it { AMMYV.find(:first, :conditions => {:year => 2009, :make_name => 'Toyota', :model_name => 'PRIUS'}).fuel_efficiency.should         be_within(0.0001).of(19.6347) }
    
    it { AMMYV.find(:first, :conditions => {:year => 1998, :make_name => 'Honda', :model_name => 'ODYSSEY'}).fuel_efficiency_city.should    be_within(0.0001).of( 7.9773) }
    it { AMMYV.find(:first, :conditions => {:year => 1998, :make_name => 'Honda', :model_name => 'ODYSSEY'}).fuel_efficiency_highway.should be_within(0.0001).of(10.2480) }
    it { AMMYV.find(:first, :conditions => {:year => 1998, :make_name => 'Honda', :model_name => 'ODYSSEY'}).fuel_efficiency.should         be_within(0.0001).of( 9.1305) }
    
    it { AMMYV.find(:first, :conditions => {:year => 1997, :make_name => 'Honda', :model_name => 'ODYSSEY'}).fuel_efficiency_city.should    be_within(0.0001).of( 7.7886) }
    it { AMMYV.find(:first, :conditions => {:year => 1997, :make_name => 'Honda', :model_name => 'ODYSSEY'}).fuel_efficiency_highway.should be_within(0.0001).of(10.3739) }
    it { AMMYV.find(:first, :conditions => {:year => 1997, :make_name => 'Honda', :model_name => 'ODYSSEY'}).fuel_efficiency.should         be_within(0.0001).of( 9.0782) }
    
    it { AMMYV.find(:first, :conditions => {:year => 1995, :make_name => 'Jaguar', :model_name => 'XJR'}).fuel_efficiency_city.should    be_within(0.0001).of(5.8670) }
    it { AMMYV.find(:first, :conditions => {:year => 1995, :make_name => 'Jaguar', :model_name => 'XJR'}).fuel_efficiency_highway.should be_within(0.0001).of(8.2903) }
    it { AMMYV.find(:first, :conditions => {:year => 1995, :make_name => 'Jaguar', :model_name => 'XJR'}).fuel_efficiency.should         be_within(0.0001).of(7.0399) }
    
    it { AMMYV.find(:first, :conditions => {:year => 1985, :make_name => 'Jaguar', :model_name => 'XJ'}).fuel_efficiency_city.should    be_within(0.0001).of(5.8479) }
    it { AMMYV.find(:first, :conditions => {:year => 1985, :make_name => 'Jaguar', :model_name => 'XJ'}).fuel_efficiency_highway.should be_within(0.0001).of(7.3958) }
    it { AMMYV.find(:first, :conditions => {:year => 1985, :make_name => 'Jaguar', :model_name => 'XJ'}).fuel_efficiency.should         be_within(0.0001).of(6.6401) }
  end
end
