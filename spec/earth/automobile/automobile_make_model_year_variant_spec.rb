require 'spec_helper'
require 'earth/automobile/automobile_make_model_year_variant'

describe AutomobileMakeModelYearVariant do
  describe 'import', :data_miner => true do
    before do
      Earth.init :automobile, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'should import data' do
      AutomobileMakeModelYearVariant.run_data_miner!
      AutomobileMakeModelYearVariant.all.count.should == 28769
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it 'should have variants from multiple years' do
      AutomobileMakeModelYearVariant.where(:year => 1985).count.should == 1152
      AutomobileMakeModelYearVariant.where(:year => 1986).count.should == 1183
      AutomobileMakeModelYearVariant.where(:year => 1987).count.should == 1206
      AutomobileMakeModelYearVariant.where(:year => 1988).count.should == 1104
      AutomobileMakeModelYearVariant.where(:year => 1989).count.should == 1137
      AutomobileMakeModelYearVariant.where(:year => 1990).count.should == 1049
      AutomobileMakeModelYearVariant.where(:year => 1991).count.should == 1062
      AutomobileMakeModelYearVariant.where(:year => 1992).count.should == 1055
      AutomobileMakeModelYearVariant.where(:year => 1993).count.should == 986
      AutomobileMakeModelYearVariant.where(:year => 1994).count.should == 963
      AutomobileMakeModelYearVariant.where(:year => 1995).count.should == 917
      AutomobileMakeModelYearVariant.where(:year => 1996).count.should == 750
      AutomobileMakeModelYearVariant.where(:year => 1997).count.should == 727
      AutomobileMakeModelYearVariant.where(:year => 1998).count.should == 790
      AutomobileMakeModelYearVariant.where(:year => 1999).count.should == 795
      AutomobileMakeModelYearVariant.where(:year => 2000).count.should == 841
      AutomobileMakeModelYearVariant.where(:year => 2001).count.should == 849
      AutomobileMakeModelYearVariant.where(:year => 2002).count.should == 936
      AutomobileMakeModelYearVariant.where(:year => 2003).count.should == 1027
      AutomobileMakeModelYearVariant.where(:year => 2004).count.should == 1131
      AutomobileMakeModelYearVariant.where(:year => 2005).count.should == 1105
      AutomobileMakeModelYearVariant.where(:year => 2006).count.should == 1076
      AutomobileMakeModelYearVariant.where(:year => 2007).count.should == 1176
      AutomobileMakeModelYearVariant.where(:year => 2008).count.should == 1239
      AutomobileMakeModelYearVariant.where(:year => 2009).count.should == 1180
      AutomobileMakeModelYearVariant.where(:year => 2010).count.should == 1107
      AutomobileMakeModelYearVariant.where(:year => 2011).count.should == 1097
      AutomobileMakeModelYearVariant.where(:year => 2012).count.should == 1129
    end
    
    it 'should have correct 2010 data' do
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Acura').count.should == 11
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Aston Martin').count.should == 7
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Audi').count.should == 35
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Bentley').count.should == 6
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'BMW').count.should == 83
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Bugatti').count.should == 1
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Buick').count.should == 9
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Cadillac').count.should == 27
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Chevrolet').count.should == 88
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Chrysler').count.should == 16
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Dodge').count.should == 39
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Ferrari').count.should == 6
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Ford').count.should == 56
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'GMC').count.should == 50
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Honda').count.should == 31
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Hummer').count.should == 6
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Hyundai').count.should == 31
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Infiniti').count.should == 19
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Jaguar').count.should == 9
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Jeep').count.should == 27
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Kia').count.should == 26
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Lamborghini').count.should == 9
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Land Rover').count.should == 6
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Lexus').count.should == 23
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Lincoln').count.should == 12
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Lotus').count.should == 3
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Maserati').count.should == 5
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Maybach').count.should == 3
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Mazda').count.should == 27
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Mercedes-Benz').count.should == 47
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Mercury').count.should == 18
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Mini').count.should == 15
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Mitsubishi').count.should == 23
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Nissan').count.should == 51
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Pontiac').count.should == 24
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Porsche').count.should == 47
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Rolls-Royce').count.should == 5
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Roush Performance').count.should == 2
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Saab').count.should == 13
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Saturn').count.should == 16
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Scion').count.should == 6
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Smart').count.should == 2
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Spyker').count.should == 1
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Subaru').count.should == 20
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Suzuki').count.should == 26
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Toyota').count.should == 57
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Volkswagen').count.should == 34
      AutomobileMakeModelYearVariant.where(:year => 2010, :make_name => 'Volvo').count.should == 29
    end
    
    it 'should have correct 2011 data' do
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Acura').count.should == 8
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Aston Martin').count.should == 8
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Audi').count.should == 38
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Bentley').count.should == 5
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'BMW').count.should == 83
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Bugatti').count.should == 1
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Buick').count.should == 10
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Cadillac').count.should == 29
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Chevrolet').count.should == 90
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Chrysler').count.should == 10
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Dodge').count.should == 36
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Ferrari').count.should == 9
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Ford').count.should == 79
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'GMC').count.should == 62
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Honda').count.should == 31
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Hyundai').count.should == 34
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Infiniti').count.should == 18
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Jaguar').count.should == 8
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Jeep').count.should == 22
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Kia').count.should == 35
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Lamborghini').count.should == 4
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Land Rover').count.should == 6
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Lexus').count.should == 24
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Lincoln').count.should == 14
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Mahindra').count.should == 1
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Maserati').count.should == 5
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Mazda').count.should == 27
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Mercedes-Benz').count.should == 53
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Mercury').count.should == 13
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Mini').count.should == 21
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Mitsubishi').count.should == 27
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Nissan').count.should == 53
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Porsche').count.should == 54
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Rolls-Royce').count.should == 5
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Saab').count.should == 15
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Scion').count.should == 6
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Smart').count.should == 4
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Subaru').count.should == 19
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Suzuki').count.should == 23
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Toyota').count.should == 59
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Volkswagen').count.should == 28
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'Volvo').count.should == 18
      AutomobileMakeModelYearVariant.where(:year => 2011, :make_name => 'VPG').count.should == 2
    end
    
    it 'should have correct 2012 data' do
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Acura').count.should == 12
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Aston Martin').count.should == 11
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Audi').count.should == 39
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Azure Dynamics').count.should == 2
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Bentley').count.should == 6
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'BMW').count.should == 82
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Bugatti').count.should == 1
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Buick').count.should == 14
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Cadillac').count.should == 19
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Chevrolet').count.should == 95
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Chrysler').count.should == 12
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'CODA Automotive').count.should == 1
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Dodge').count.should == 31
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Fiat').count.should == 4
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Ford').count.should == 77
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'GMC').count.should == 65
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Honda').count.should == 28
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Hyundai').count.should == 35
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Infiniti').count.should == 22
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Jaguar').count.should == 10
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Jeep').count.should == 25
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Kia').count.should == 37
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Lamborghini').count.should == 5
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Land Rover').count.should == 7
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Lexus').count.should == 20
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Lincoln').count.should == 12
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Lotus').count.should == 4
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Maserati').count.should == 3
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Maybach').count.should == 5
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Mazda').count.should == 24
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Mercedes-Benz').count.should == 61
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Mini').count.should == 31
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Mitsubishi').count.should == 24
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Nissan').count.should == 53
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Porsche').count.should == 67
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Rolls-Royce').count.should == 6
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Roush Performance').count.should == 2
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Saab').count.should == 16
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Scion').count.should == 7
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Smart').count.should == 2
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Subaru').count.should == 19
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Suzuki').count.should == 21
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Toyota').count.should == 57
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Volkswagen').count.should == 39
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'Volvo').count.should == 15
      AutomobileMakeModelYearVariant.where(:year => 2012, :make_name => 'VPG').count.should == 1
    end
  end
end
