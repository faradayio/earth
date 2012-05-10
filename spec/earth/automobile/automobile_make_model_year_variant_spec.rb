# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'earth/automobile/automobile_make_model_year_variant'
require 'earth/automobile/automobile_make_model_year_variant/parser' # needed for some tests

describe AutomobileMakeModelYearVariant do
  describe 'import', :data_miner => true do
    before do
      Earth.init :automobile, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'should import data' do
      AutomobileMakeModelYearVariant.run_data_miner!
      AutomobileMakeModelYearVariant.all.count.should == 28811
    end
  end
  
  describe 'verify imported data', :sanity => true do
    # confirm we have right data from all years
    it { AutomobileMakeModelYearVariant.where(:year => 1985).count.should == 1152 }
    it { AutomobileMakeModelYearVariant.where(:year => 1986).count.should == 1183 }
    it { AutomobileMakeModelYearVariant.where(:year => 1987).count.should == 1206 }
    it { AutomobileMakeModelYearVariant.where(:year => 1988).count.should == 1104 }
    it { AutomobileMakeModelYearVariant.where(:year => 1989).count.should == 1137 }
    it { AutomobileMakeModelYearVariant.where(:year => 1990).count.should == 1049 }
    it { AutomobileMakeModelYearVariant.where(:year => 1991).count.should == 1062 }
    it { AutomobileMakeModelYearVariant.where(:year => 1992).count.should == 1055 }
    it { AutomobileMakeModelYearVariant.where(:year => 1993).count.should ==  986 }
    it { AutomobileMakeModelYearVariant.where(:year => 1994).count.should ==  963 }
    it { AutomobileMakeModelYearVariant.where(:year => 1995).count.should ==  917 }
    it { AutomobileMakeModelYearVariant.where(:year => 1996).count.should ==  750 }
    it { AutomobileMakeModelYearVariant.where(:year => 1997).count.should ==  727 }
    it { AutomobileMakeModelYearVariant.where(:year => 1998).count.should ==  794 }
    it { AutomobileMakeModelYearVariant.where(:year => 1999).count.should ==  800 }
    it { AutomobileMakeModelYearVariant.where(:year => 2000).count.should ==  845 }
    it { AutomobileMakeModelYearVariant.where(:year => 2001).count.should ==  849 }
    it { AutomobileMakeModelYearVariant.where(:year => 2002).count.should ==  940 }
    it { AutomobileMakeModelYearVariant.where(:year => 2003).count.should == 1031 }
    it { AutomobileMakeModelYearVariant.where(:year => 2004).count.should == 1134 }
    it { AutomobileMakeModelYearVariant.where(:year => 2005).count.should == 1105 }
    it { AutomobileMakeModelYearVariant.where(:year => 2006).count.should == 1076 }
    it { AutomobileMakeModelYearVariant.where(:year => 2007).count.should == 1184 }
    it { AutomobileMakeModelYearVariant.where(:year => 2008).count.should == 1247 }
    it { AutomobileMakeModelYearVariant.where(:year => 2009).count.should == 1182 }
    it { AutomobileMakeModelYearVariant.where(:year => 2010).count.should == 1107 }
    it { AutomobileMakeModelYearVariant.where(:year => 2011).count.should == 1097 }
    it { AutomobileMakeModelYearVariant.where(:year => 2012).count.should == 1129 }
    
    # confirm make, model, year aren't missing
    it { AutomobileMakeModelYearVariant.where(:make_name => nil).count.should == 0 }
    it { AutomobileMakeModelYearVariant.where(:model_name => nil).count.should == 0 }
    it { AutomobileMakeModelYearVariant.where(:year => nil).count.should == 0 }
    
    it 'should have valid transmissions' do
      AutomobileMakeModelYearVariant.connection.select_values("SELECT DISTINCT transmission FROM #{AutomobileMakeModelYearVariant.quoted_table_name}").each do |transmission|
        fail "#{transmission} is not a valid transmission" unless AutomobileMakeModelYearVariant::Parser::TRANSMISSIONS.values.include?(transmission)
      end
    end
    
    it 'should have valid speeds' do
      valid_speeds = ["1", "3", "4", "5", "6", "7", "8", "variable"]
      AutomobileMakeModelYearVariant.connection.select_values("SELECT DISTINCT speeds FROM #{AutomobileMakeModelYearVariant.quoted_table_name}").each do |speeds|
        fail "#{speeds} is not a valid speeds" unless valid_speeds.include?(speeds)
      end
    end
    
    it 'should have valid drives' do
      valid_drives = ["FWD", "RWD", "4WD", "AWD", "PWD"] # PWD = part-time 4-wheel drive
      AutomobileMakeModelYearVariant.connection.select_values("SELECT DISTINCT drive FROM #{AutomobileMakeModelYearVariant.quoted_table_name}").each do |drive|
        fail "#{drive} is not a valid drive" unless valid_drives.include?(drive)
      end
    end
    
    it 'should have valid fuel codes' do
      AutomobileMakeModelYearVariant.connection.select_values("SELECT DISTINCT fuel_code FROM #{AutomobileMakeModelYearVariant.quoted_table_name}").each do |code|
        fail "#{code} is not a valid code" unless AutomobileMakeModelYearVariant::Parser::FUEL_CODES.values.include?(code)
      end
    end
    
    # confirm fuel efficiencies are valid and proper units
    it { AutomobileMakeModelYearVariant.where("fuel_efficiency > 0").count.should == AutomobileMakeModelYearVariant.count }
    it { AutomobileMakeModelYearVariant.where("fuel_efficiency_city > 0").count.should == AutomobileMakeModelYearVariant.count }
    it { AutomobileMakeModelYearVariant.where("fuel_efficiency_highway > 0").count.should == AutomobileMakeModelYearVariant.count }
    it { AutomobileMakeModelYearVariant.where("fuel_efficiency_units = 'kilometres_per_litre'").count.should == AutomobileMakeModelYearVariant.count }
    it { AutomobileMakeModelYearVariant.where("fuel_efficiency_city_units = 'kilometres_per_litre'").count.should == AutomobileMakeModelYearVariant.count }
    it { AutomobileMakeModelYearVariant.where("fuel_efficiency_highway_units = 'kilometres_per_litre'").count.should == AutomobileMakeModelYearVariant.count }
    it { AutomobileMakeModelYearVariant.where("alt_fuel_efficiency <= 0").count.should == 0 }
    it { AutomobileMakeModelYearVariant.where("alt_fuel_efficiency_city <= 0").count.should == 0 }
    it { AutomobileMakeModelYearVariant.where("alt_fuel_efficiency_highway <= 0").count.should == 0 }
    it { AutomobileMakeModelYearVariant.where("alt_fuel_efficiency_units != 'kilometres_per_litre'").count.should == 0 }
    it { AutomobileMakeModelYearVariant.where("alt_fuel_efficiency_city_units != 'kilometres_per_litre'").count.should == 0 }
    it { AutomobileMakeModelYearVariant.where("alt_fuel_efficiency_highway_units != 'kilometres_per_litre'").count.should == 0 }
    
    # confirm carline class is present for recent years
    it { AutomobileMakeModelYearVariant.where("year > 1997 AND carline_class IS NULL").count.should == 0 }
    
    # spot check fuel efficiency calcs
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).raw_fuel_efficiency_city.should    be_within(0.0001).of(20.1943) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).raw_fuel_efficiency_highway.should be_within(0.0001).of(22.7877) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_city.should        be_within(0.0001).of(15.1234) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_highway.should     be_within(0.0001).of(16.0437) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency.should             be_within(0.0001).of(15.6346) }
    
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_raw_fuel_efficiency_city.should    be_within(0.0001).of(57.3944) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_raw_fuel_efficiency_highway.should be_within(0.0001).of(56.4166) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_city.should        be_within(0.0001).of(35.4185) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_highway.should     be_within(0.0001).of(36.8930) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency.should             be_within(0.0001).of(36.2442) }
    
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).raw_fuel_efficiency_city.should    be_within(0.0001).of(19.3067) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).raw_fuel_efficiency_highway.should be_within(0.0001).of(22.4262) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_city.should        be_within(0.0001).of(14.5327) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_highway.should     be_within(0.0001).of(15.8022) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency.should             be_within(0.0001).of(15.2301) }
    
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_raw_fuel_efficiency_city.should    be_within(0.0001).of(57.4369) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_raw_fuel_efficiency_highway.should be_within(0.0001).of(56.4166) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_city.should        be_within(0.0001).of(35.4376) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_highway.should     be_within(0.0001).of(36.8930) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency.should             be_within(0.0001).of(36.2528) }
    
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER', :alt_fuel_code => 'E'}).raw_fuel_efficiency_city.should    be_within(0.0001).of(10.2885) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER', :alt_fuel_code => 'E'}).raw_fuel_efficiency_highway.should be_within(0.0001).of(16.2830) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER', :alt_fuel_code => 'E'}).fuel_efficiency_city.should        be_within(0.0001).of( 8.1696) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER', :alt_fuel_code => 'E'}).fuel_efficiency_highway.should     be_within(0.0001).of(11.6365) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER', :alt_fuel_code => 'E'}).fuel_efficiency.should             be_within(0.0001).of(9.8408) }
    
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER', :alt_fuel_code => 'E'}).alt_raw_fuel_efficiency_city.should    be_within(0.0001).of( 7.1849) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER', :alt_fuel_code => 'E'}).alt_raw_fuel_efficiency_highway.should be_within(0.0001).of(11.8190) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER', :alt_fuel_code => 'E'}).alt_fuel_efficiency_city.should        be_within(0.0001).of( 5.8150) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER', :alt_fuel_code => 'E'}).alt_fuel_efficiency_highway.should     be_within(0.0001).of( 8.5345) }
    it { AutomobileMakeModelYearVariant.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER', :alt_fuel_code => 'E'}).alt_fuel_efficiency.should             be_within(0.0001).of( 7.1056) }
  end
end
