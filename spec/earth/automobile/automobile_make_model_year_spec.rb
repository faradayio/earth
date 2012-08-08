require 'spec_helper'
require 'earth/automobile/automobile_make_model_year'

describe AutomobileMakeModelYear do
  let(:ammy) { AutomobileMakeModelYear }
  let(:ammyv) { AutomobileMakeModelYearVariant }
  
  describe 'Sanity check', :sanity => true do
    # confirm we have right data from all years
    it { ammy.where(:year => 1985).count.should == 360 }
    it { ammy.where(:year => 1986).count.should == 350 }
    it { ammy.where(:year => 1987).count.should == 385 }
    it { ammy.where(:year => 1988).count.should == 370 }
    it { ammy.where(:year => 1989).count.should == 373 }
    it { ammy.where(:year => 1990).count.should == 349 }
    it { ammy.where(:year => 1991).count.should == 363 }
    it { ammy.where(:year => 1992).count.should == 337 }
    it { ammy.where(:year => 1993).count.should == 322 }
    it { ammy.where(:year => 1994).count.should == 318 }
    it { ammy.where(:year => 1995).count.should == 320 }
    it { ammy.where(:year => 1996).count.should == 286 }
    it { ammy.where(:year => 1997).count.should == 277 }
    it { ammy.where(:year => 1998).count.should == 301 }
    it { ammy.where(:year => 1999).count.should == 308 }
    it { ammy.where(:year => 2000).count.should == 320 }
    it { ammy.where(:year => 2001).count.should == 341 }
    it { ammy.where(:year => 2002).count.should == 377 }
    it { ammy.where(:year => 2003).count.should == 410 }
    it { ammy.where(:year => 2004).count.should == 437 }
    it { ammy.where(:year => 2005).count.should == 445 }
    it { ammy.where(:year => 2006).count.should == 431 }
    it { ammy.where(:year => 2007).count.should == 499 }
    it { ammy.where(:year => 2008).count.should == 539 }
    it { ammy.where(:year => 2009).count.should == 496 }
    it { ammy.where(:year => 2010).count.should == 530 }
    it { ammy.where(:year => 2011).count.should == 562 }
    it { ammy.where(:year => 2012).count.should == 591 }
    
    # confirm make, model, year aren't missing
    it { ammy.where(:make_name => nil).count.should == 0 }
    it { ammy.where(:model_name => nil).count.should == 0 }
    it { ammy.where(:year => nil).count.should == 0 }
    
    it 'should have valid fuel codes' do
      ammy.connection.select_values("SELECT DISTINCT fuel_code FROM #{ammy.quoted_table_name} WHERE fuel_code != 'G'").each do |code|
        fail "#{code} is not a valid code" unless ammyv::Parser::FUEL_CODES.values.include?(code)
      end
    end
    
    it 'should have valid alt fuel codes' do
      ammy.connection.select_values("SELECT DISTINCT alt_fuel_code FROM #{ammy.quoted_table_name} WHERE alt_fuel_code IS NOT NULL").each do |code|
        fail "#{code} is not a valid code" unless ammyv::Parser::FUEL_CODES.values.include?(code)
      end
    end
    
    it { ammy.where(:hybridity => true).count.should == 170 }
    
    it 'should have proper weightings' do
      ammy.connection.select_values("SELECT DISTINCT year FROM #{ammy.quoted_table_name}").each do |year|
        ammy.where(:year => year).first.weighting.should == AutomobileYear.weighting(year)
      end
    end
    
    # confirm fuel efficiencies are valid and proper units
    it { ammy.where("fuel_efficiency_city > 0").count.should == ammy.count }
    it { ammy.where("fuel_efficiency_highway > 0").count.should == ammy.count }
    it { ammy.where(:fuel_efficiency_city_units => 'kilometres_per_litre').count.should == ammy.count }
    it { ammy.where(:fuel_efficiency_highway_units => 'kilometres_per_litre').count.should == ammy.count }
    
    # confirm alt fuel efficiencies are valid and proper units
    it { ammy.where("alt_fuel_efficiency_city > 0").count.should == ammy.where("alt_fuel_code IS NOT NULL").count }
    it { ammy.where("alt_fuel_efficiency_highway > 0").count.should == ammy.where("alt_fuel_code IS NOT NULL").count }
    it { ammy.where(:alt_fuel_efficiency_city_units => 'kilometres_per_litre').count.should == ammy.where("alt_fuel_code IS NOT NULL").count }
    it { ammy.where(:alt_fuel_efficiency_highway_units => 'kilometres_per_litre').count.should == ammy.where("alt_fuel_code IS NOT NULL").count }
    
    # # spot check fuel efficiency calcs
    it { ammy.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_city.should    be_within(0.0001).of(14.8800) }
    it { ammy.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_highway.should be_within(0.0001).of(17.0057) }
    
    it { ammy.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_city.should    be_within(0.0001).of(40.3887) }
    it { ammy.find(:first, :conditions => {:year => 2012, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_highway.should be_within(0.0001).of(39.5384) }
    
    it { ammy.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_city.should    be_within(0.0001).of(14.8800) }
    it { ammy.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).fuel_efficiency_highway.should be_within(0.0001).of(17.0057) }
    
    it { ammy.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_city.should    be_within(0.0001).of(40.3887) }
    it { ammy.find(:first, :conditions => {:year => 2011, :make_name => 'Chevrolet', :model_name => 'VOLT'}).alt_fuel_efficiency_highway.should be_within(0.0001).of(38.2629) }
    
    it { ammy.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).fuel_efficiency_city.should    be_within(0.0001).of( 8.0777) }
    it { ammy.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).fuel_efficiency_highway.should be_within(0.0001).of(11.4789) }
    
    it { ammy.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).alt_fuel_efficiency_city.should    be_within(0.0001).of(5.9520) }
    it { ammy.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER FFV'}).alt_fuel_efficiency_highway.should be_within(0.0001).of(8.5029) }
    
    it { ammy.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER'}).fuel_efficiency_city.should    be_within(0.0001).of(7.86516) }
    it { ammy.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER'}).fuel_efficiency_highway.should be_within(0.0001).of(12.11660) }
    
    it { ammy.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER'}).alt_fuel_efficiency_city.should    == nil }
    it { ammy.find(:first, :conditions => {:year => 2010, :make_name => 'Dodge', :model_name => 'AVENGER'}).alt_fuel_efficiency_highway.should == nil }
    
    it { ammy.where(:type_name => nil).count.should == 0 }
    it { ammy.find(:first, :conditions => {:make_name => 'Toyota', :model_name => 'Prius'}).type_name.should == 'Passenger cars' }
    it { ammy.find(:first, :conditions => {:make_name => 'Toyota', :model_name => 'Highlander'}).type_name.should == 'Light-duty trucks' }
  end
end
