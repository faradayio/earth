require 'spec_helper'
require 'earth/automobile/automobile_make_model_year_variant'

describe AutomobileMakeModelYearVariant do
  before :all do
    AutomobileMakeModelYearVariant.auto_upgrade!
  end
  
  describe 'import', :data_miner => true do
    before do
      require 'earth/automobile/automobile_make_model_year_variant/data_miner'
    end
    
    it 'should import data' do
      AutomobileMakeModelYearVariant.run_data_miner!
      AutomobileMakeModelYearVariant.all.count.should == 27638
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
      AutomobileMakeModelYearVariant.where(:year => 2010).count.should == 1105
      AutomobileMakeModelYearVariant.where(:year => 2011).count.should == 1097
    end
    
    # fuel type code should be in AutomobileFuel
    # fuel efficiencies should be > 0
    # fuel efficiencies should be km / l
  end
end
