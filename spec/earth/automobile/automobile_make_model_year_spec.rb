require 'spec_helper'
require 'earth/automobile/automobile_make_model_year'

describe AutomobileMakeModelYear do
  before :all do
    require 'earth/acronyms'
  end
  
  describe 'verify imported data', :sanity => true do
    it 'has data from all years' do
      (1985..2012).each do |year|
        AMMY.where(:year => year).count.should == AMMY.connection.select_value("SELECT COUNT(DISTINCT make_name, model_name) FROM #{AutomobileMakeModelYearVariant.quoted_table_name} WHERE year = #{year}")
      end
    end
    
    # confirm make, model, year aren't missing
    it { AMMY.where(:make_name => nil).count.should == 0 }
    it { AMMY.where(:model_name => nil).count.should == 0 }
    it { AMMY.where(:year => nil).count.should == 0 }
    
    it 'should have valid fuel codes' do
      AMMY.connection.select_values("SELECT DISTINCT fuel_code FROM #{AMMY.quoted_table_name} WHERE fuel_code != 'G'").each do |code|
        fail "#{code} is not a valid code" unless AutomobileMakeModelYearVariant::Parser::FUEL_CODES.values.include?(code)
      end
    end
    
    it 'should have valid alt fuel codes' do
      AMMY.connection.select_values("SELECT DISTINCT alt_fuel_code FROM #{AMMY.quoted_table_name} WHERE alt_fuel_code IS NOT NULL").each do |code|
        fail "#{code} is not a valid code" unless AutomobileMakeModelYearVariant::Parser::FUEL_CODES.values.include?(code)
      end
    end
    
    it { AMMY.where(:hybridity => true).count.should == 170 }
    
    it 'should have proper weightings' do
      AutomobileMakeModelYear.connection.select_values("SELECT DISTINCT year FROM #{AutomobileMakeModelYear.quoted_table_name}").each do |year|
        AMMY.where(:year => year).first.weighting.should == AutomobileYear.weighting(year)
      end
    end
    
    # confirm fuel efficiencies are valid and proper units
    it { AMMY.where("fuel_efficiency_city > 0").count.should == AMMY.count }
    it { AMMY.where("fuel_efficiency_highway > 0").count.should == AMMY.count }
    it { AMMY.where(:fuel_efficiency_city_units => 'kilometres_per_litre').count.should == AMMY.count }
    it { AMMY.where(:fuel_efficiency_highway_units => 'kilometres_per_litre').count.should == AMMY.count }
    
    # confirm alt fuel efficiencies are valid and proper units
    it { AMMY.where("alt_fuel_efficiency_city > 0").count.should == AMMY.where("alt_fuel_code IS NOT NULL").count }
    it { AMMY.where("alt_fuel_efficiency_highway > 0").count.should == AMMY.where("alt_fuel_code IS NOT NULL").count }
    it { AMMY.where(:alt_fuel_efficiency_city_units => 'kilometres_per_litre').count.should == AMMY.where("alt_fuel_code IS NOT NULL").count }
    it { AMMY.where(:alt_fuel_efficiency_highway_units => 'kilometres_per_litre').count.should == AMMY.where("alt_fuel_code IS NOT NULL").count }
    
    # # spot check fuel efficiency calcs
    it { AMMY.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_city.should    be_within(0.0001).of(14.8800) }
    it { AMMY.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_highway.should be_within(0.0001).of(17.0057) }
    
    it { AMMY.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_city.should    be_within(0.0001).of(40.3887) }
    it { AMMY.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_highway.should be_within(0.0001).of(39.5384) }
    
    it { AMMY.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_city.should    be_within(0.0001).of(14.8800) }
    it { AMMY.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_highway.should be_within(0.0001).of(17.0057) }
    
    it { AMMY.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_city.should    be_within(0.0001).of(40.3887) }
    it { AMMY.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_highway.should be_within(0.0001).of(38.2629) }
    
    it { AMMY.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).fuel_efficiency_city.should    be_within(0.0001).of( 8.0777) }
    it { AMMY.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).fuel_efficiency_highway.should be_within(0.0001).of(11.4789) }
    
    it { AMMY.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).alt_fuel_efficiency_city.should    be_within(0.0001).of(5.9520) }
    it { AMMY.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).alt_fuel_efficiency_highway.should be_within(0.0001).of(8.5029) }
    
    it { AMMY.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER'}).fuel_efficiency_city.should    be_within(0.0001).of(7.86516) }
    it { AMMY.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER'}).fuel_efficiency_highway.should be_within(0.0001).of(12.11660) }
    
    it { AMMY.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER'}).alt_fuel_efficiency_city.should    == nil }
    it { AMMY.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER'}).alt_fuel_efficiency_highway.should == nil }
    
    it { AMMY.where(:type_name => nil).count.should == 0 }
    it { AMMY.find(:first, :conditions => {:make_name => 'Toyota', :model_name => 'Prius'}).type_name.should == 'Passenger cars' }
    it { AMMY.find(:first, :conditions => {:make_name => 'Toyota', :model_name => 'Highlander'}).type_name.should == 'Light-duty trucks' }
  end
end
