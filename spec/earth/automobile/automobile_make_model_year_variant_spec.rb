# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'earth/automobile/automobile_make_model_year_variant'

describe AutomobileMakeModelYearVariant do
  let(:ammyv) { AutomobileMakeModelYearVariant }
  
  describe 'Sanity check', :sanity => true do
    # confirm we have right data from all years
    it { ammyv.where(:year => 1985).count.should == 1152 }
    it { ammyv.where(:year => 1986).count.should == 1183 }
    it { ammyv.where(:year => 1987).count.should == 1206 }
    it { ammyv.where(:year => 1988).count.should == 1104 }
    it { ammyv.where(:year => 1989).count.should == 1137 }
    it { ammyv.where(:year => 1990).count.should == 1049 }
    it { ammyv.where(:year => 1991).count.should == 1062 }
    it { ammyv.where(:year => 1992).count.should == 1055 }
    it { ammyv.where(:year => 1993).count.should ==  986 }
    it { ammyv.where(:year => 1994).count.should ==  963 }
    it { ammyv.where(:year => 1995).count.should ==  917 }
    it { ammyv.where(:year => 1996).count.should ==  750 }
    it { ammyv.where(:year => 1997).count.should ==  727 }
    it { ammyv.where(:year => 1998).count.should ==  794 }
    it { ammyv.where(:year => 1999).count.should ==  800 }
    it { ammyv.where(:year => 2000).count.should ==  834 }
    it { ammyv.where(:year => 2001).count.should ==  846 }
    it { ammyv.where(:year => 2002).count.should ==  933 }
    it { ammyv.where(:year => 2003).count.should ==  995 }
    it { ammyv.where(:year => 2004).count.should == 1091 }
    it { ammyv.where(:year => 2005).count.should == 1069 }
    it { ammyv.where(:year => 2006).count.should == 1043 }
    it { ammyv.where(:year => 2007).count.should == 1126 }
    it { ammyv.where(:year => 2008).count.should == 1186 }
    it { ammyv.where(:year => 2009).count.should == 1092 }
    it { ammyv.where(:year => 2010).count.should == 1107 }
    it { ammyv.where(:year => 2011).count.should == 1097 }
    it { ammyv.where(:year => 2012).count.should == 1123 }
    
    # confirm make, model, year, size class, and type aren't missing
    it { ammyv.where(:make_name => nil).count.should == 0 }
    it { ammyv.where(:model_name => nil).count.should == 0 }
    it { ammyv.where(:year => nil).count.should == 0 }
    it { ammyv.where(:size_class => nil).count.should == 0 }
    it { ammyv.where(:type_name => nil).count.should == 0 }
    
    # confirm it handles special characters
    it { ammyv.where(:make_name => 'Citroën').count.should > 13 }
    
    # confirm Chevy and GMC model names have been simplified
    it { ammyv.where("make_name IN ('Chevrolet', 'GMC') AND model_name REGEXP '^[CK][0-9]+'").count.should == 0 }
    
    # confirm certain hybrids have been identified
    it { ammyv.where(:year => 2012, :make_name => 'Buick', :model_name => 'LACROSSE HYBRID').count.should == 1 }
    it { ammyv.find(:first, :conditions => {:year => 2012, :make_name => 'Buick', :model_name => 'LACROSSE HYBRID'}).fuel_efficiency.should be_within(1e-4).of(12.8701) }
    it { ammyv.where(:year => 2012, :make_name => 'Buick', :model_name => 'REGAL HYBRID').count.should == 1 }
    it { ammyv.find(:first, :conditions => {:year => 2012, :make_name => 'Buick', :model_name => 'REGAL HYBRID'}).fuel_efficiency.should be_within(1e-4).of(12.8701) }
    
    # confirm dual-fuel and CNG variants have been merged and identified
    it { ammyv.where(:make_name => 'Chevrolet', :model_name => 'CAVALIER DUAL-FUEL', :fuel_code => 'C').count.should == 0 }
    it { ammyv.where(:make_name => 'Chevrolet', :model_name => 'CAVALIER DUAL-FUEL', :fuel_code => 'R', :alt_fuel_code => 'C').count.should == 5 }
    it { ammyv.where(:fuel_code => 'C').count.should == ammyv.where("model_name LIKE '%CNG'").count }
    
    # confirm FFV variants have been merged
    it { ammyv.where(:fuel_code => 'E').count.should == 0 }
    it { ammyv.where(:alt_fuel_code => 'E').count.should > 750 }
    
    # confirm flex-fuel variants of models where not all variants are flex-fuel have been identified
    it { ammyv.where("model_name LIKE '%FFV'").count.should > 700 }
    it { ammyv.find(:first, :conditions => {:year => 2012, :make_name => 'Toyota', :model_name => 'SEQUOIA FFV'}).alt_fuel_code.should == 'E' }
    it { ammyv.find(:first, :conditions => {:year => 2012, :make_name => 'Toyota', :model_name => 'SEQUOIA'}).alt_fuel_code.should == nil }
    
    # confirm diesel variants of models where not all variants are diesel have been identified
    it { ammyv.where("model_name LIKE '%DIESEL'").count.should > 575 }
    it { ammyv.find(:first, :conditions => {:year => 2012, :make_name => 'Volkswagen', :model_name => 'JETTA DIESEL'}).fuel_code.should == 'D' }
    it { ammyv.find(:first, :conditions => {:year => 2012, :make_name => 'Volkswagen', :model_name => 'JETTA'}).fuel_code.should_not == 'D' }
    
    it "type name shouldn't vary within a make model" do
      ammyv.connection.select_values(%{
        SELECT * FROM
        (SELECT make_name, model_name, GROUP_CONCAT(DISTINCT type_name) AS types
        FROM #{ammyv.quoted_table_name}
        GROUP BY make_name, model_name) AS t1
        WHERE types LIKE '%,%'
      }).count.should == 0
    end
    
    it 'should have valid transmissions' do
      ammyv.connection.select_values("SELECT DISTINCT transmission FROM #{ammyv.quoted_table_name}").each do |transmission|
        fail "#{transmission} is not a valid transmission" unless AutomobileMakeModelYearVariant::Parser::TRANSMISSIONS.values.include?(transmission)
      end
    end
    
    it 'should have valid speeds' do
      valid_speeds = ["1", "3", "4", "5", "6", "7", "8", "variable"]
      ammyv.connection.select_values("SELECT DISTINCT speeds FROM #{ammyv.quoted_table_name}").each do |speeds|
        fail "#{speeds} is not a valid speeds" unless valid_speeds.include?(speeds)
      end
    end
    
    it 'should have valid drives' do
      valid_drives = ["FWD", "RWD", "4WD", "AWD", "PWD"] # PWD = part-time 4-wheel drive
      ammyv.connection.select_values("SELECT DISTINCT drive FROM #{ammyv.quoted_table_name}").each do |drive|
        fail "#{drive} is not a valid drive" unless valid_drives.include?(drive)
      end
    end
    
    it 'should have valid fuel codes' do
      ammyv.connection.select_values("SELECT DISTINCT fuel_code FROM #{ammyv.quoted_table_name}").each do |code|
        fail "#{code} is not a valid code" unless AutomobileMakeModelYearVariant::Parser::FUEL_CODES.values.include?(code)
      end
    end
    
    it 'should have valid alt fuel codes' do
      ammyv.connection.select_values("SELECT DISTINCT alt_fuel_code FROM #{ammyv.quoted_table_name} WHERE alt_fuel_code IS NOT NULL").each do |code|
        fail "#{code} is not a valid code" unless AutomobileMakeModelYearVariant::Parser::FUEL_CODES.values.include?(code)
      end
    end
    
    # confirm fuel efficiencies are valid and proper units
    let(:total) { ammyv.count }
    it { ammyv.where("fuel_efficiency > 0").count.should == total }
    it { ammyv.where("fuel_efficiency_city > 0").count.should == total }
    it { ammyv.where("fuel_efficiency_highway > 0").count.should == total }
    it { ammyv.where(:fuel_efficiency_units => 'kilometres_per_litre').count.should == total }
    it { ammyv.where(:fuel_efficiency_city_units => 'kilometres_per_litre').count.should == total }
    it { ammyv.where(:fuel_efficiency_highway_units => 'kilometres_per_litre').count.should == total }
    
    # confirm alt fuel efficiencies are valid and proper units
    it { ammyv.where("alt_fuel_efficiency > 0").count.should == ammyv.where("alt_fuel_code IS NOT NULL").count }
    it { ammyv.where("alt_fuel_efficiency_city > 0").count.should == ammyv.where("alt_fuel_code IS NOT NULL").count }
    it { ammyv.where("alt_fuel_efficiency_highway > 0").count.should == ammyv.where("alt_fuel_code IS NOT NULL").count }
    it { ammyv.where(:alt_fuel_efficiency_units => 'kilometres_per_litre').count.should == ammyv.where("alt_fuel_code IS NOT NULL").count }
    it { ammyv.where(:alt_fuel_efficiency_city_units => 'kilometres_per_litre').count.should == ammyv.where("alt_fuel_code IS NOT NULL").count }
    it { ammyv.where(:alt_fuel_efficiency_highway_units => 'kilometres_per_litre').count.should == ammyv.where("alt_fuel_code IS NOT NULL").count }
    
    # spot check fuel efficiency calcs
    it { ammyv.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_city.should    be_within(0.0001).of(14.8800) }
    it { ammyv.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_highway.should be_within(0.0001).of(17.0057) }
    it { ammyv.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency.should         be_within(0.0001).of(16.0216) }
    
    it { ammyv.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_city.should    be_within(0.0001).of(40.3887) }
    it { ammyv.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_highway.should be_within(0.0001).of(39.5384) }
    it { ammyv.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency.should         be_within(0.0001).of(39.8996) }
    
    it { ammyv.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_city.should    be_within(0.0001).of(14.8800) }
    it { ammyv.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_highway.should be_within(0.0001).of(17.0057) }
    it { ammyv.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency.should         be_within(0.0001).of(16.0216) }
    
    it { ammyv.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_city.should    be_within(0.0001).of(40.3887) }
    it { ammyv.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_highway.should be_within(0.0001).of(38.2629) }
    it { ammyv.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency.should         be_within(0.0001).of(39.1489) }
    
    it { ammyv.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).fuel_efficiency_city.should    be_within(0.0001).of( 8.0777) }
    it { ammyv.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).fuel_efficiency_highway.should be_within(0.0001).of(11.4789) }
    it { ammyv.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).fuel_efficiency.should         be_within(0.0001).of( 9.7192) }
    
    it { ammyv.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).alt_fuel_efficiency_city.should    be_within(0.0001).of(5.9520) }
    it { ammyv.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).alt_fuel_efficiency_highway.should be_within(0.0001).of(8.5029) }
    it { ammyv.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).alt_fuel_efficiency.should         be_within(0.0001).of(7.1797) }
    
    it { ammyv.find(:first, :conditions => {:year => 2009, :make_name => 'Toyota', :model_name => 'PRIUS'}).fuel_efficiency_city.should    be_within(0.0001).of(20.2602) }
    it { ammyv.find(:first, :conditions => {:year => 2009, :make_name => 'Toyota', :model_name => 'PRIUS'}).fuel_efficiency_highway.should be_within(0.0001).of(19.1879) }
    it { ammyv.find(:first, :conditions => {:year => 2009, :make_name => 'Toyota', :model_name => 'PRIUS'}).fuel_efficiency.should         be_within(0.0001).of(19.6347) }
    
    it { ammyv.find(:first, :conditions => {:year => 1998, :make_name => 'Honda', :model_name => 'ODYSSEY'}).fuel_efficiency_city.should    be_within(0.0001).of( 7.9773) }
    it { ammyv.find(:first, :conditions => {:year => 1998, :make_name => 'Honda', :model_name => 'ODYSSEY'}).fuel_efficiency_highway.should be_within(0.0001).of(10.2480) }
    it { ammyv.find(:first, :conditions => {:year => 1998, :make_name => 'Honda', :model_name => 'ODYSSEY'}).fuel_efficiency.should         be_within(0.0001).of( 9.1305) }
    
    it { ammyv.find(:first, :conditions => {:year => 1997, :make_name => 'Honda', :model_name => 'ODYSSEY'}).fuel_efficiency_city.should    be_within(0.0001).of( 7.7886) }
    it { ammyv.find(:first, :conditions => {:year => 1997, :make_name => 'Honda', :model_name => 'ODYSSEY'}).fuel_efficiency_highway.should be_within(0.0001).of(10.3739) }
    it { ammyv.find(:first, :conditions => {:year => 1997, :make_name => 'Honda', :model_name => 'ODYSSEY'}).fuel_efficiency.should         be_within(0.0001).of( 9.0782) }
    
    it { ammyv.find(:first, :conditions => {:year => 1995, :make_name => 'Jaguar', :model_name => 'XJR'}).fuel_efficiency_city.should    be_within(0.0001).of(5.8670) }
    it { ammyv.find(:first, :conditions => {:year => 1995, :make_name => 'Jaguar', :model_name => 'XJR'}).fuel_efficiency_highway.should be_within(0.0001).of(8.2903) }
    it { ammyv.find(:first, :conditions => {:year => 1995, :make_name => 'Jaguar', :model_name => 'XJR'}).fuel_efficiency.should         be_within(0.0001).of(7.0399) }
    
    it { ammyv.find(:first, :conditions => {:year => 1985, :make_name => 'Jaguar', :model_name => 'XJ'}).fuel_efficiency_city.should    be_within(0.0001).of(5.8479) }
    it { ammyv.find(:first, :conditions => {:year => 1985, :make_name => 'Jaguar', :model_name => 'XJ'}).fuel_efficiency_highway.should be_within(0.0001).of(7.3958) }
    it { ammyv.find(:first, :conditions => {:year => 1985, :make_name => 'Jaguar', :model_name => 'XJ'}).fuel_efficiency.should         be_within(0.0001).of(6.6401) }
  end
end
