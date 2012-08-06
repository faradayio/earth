require 'spec_helper'
require "#{Earth::FACTORY_DIR}/food_group"

describe FoodGroup do
  describe '.names' do
    it "returns a list of food group names" do
      FoodGroup.delete_all
      FactoryGirl.create :food_group, :meat
      FactoryGirl.create :food_group, :veg
      FoodGroup.names.should == ['meat', 'veg']
    end
  end
  
  describe '.[](name)' do
    it "finds by name" do
      meat = FactoryGirl.create :food_group, :meat
      FoodGroup['meat'].should == meat
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it { FoodGroup.count.should == 10 }
    
    # FIXME TODO more sanity checks
  end
end
