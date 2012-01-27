require 'spec_helper'
require 'earth/hospitality'
require 'earth/hospitality/data_miner'
require 'charisma'

describe LodgingFuelUseEquation do
  describe 'import', :slow => true do
    it 'should import data without problems' do
      LodgingFuelUseEquation.run_data_miner!
      LodgingFuelUseEquation.all.count.should == 48
    end
  end
  
  describe 'climate zone numbers' do
    it 'should be nil or 1 through 5' do
      LodgingFuelUseEquation.select('DISTINCT climate_zone_number').map(&:climate_zone_number).should == [nil, 1, 2, 3, 4, 5]
    end
  end
  
  describe 'electricity factors' do
    it 'should produce reasonable electricity use estimates' do
      LodgingFuelUseEquation.where(:fuel => 'Electricity').each do |equation|
        if equation.property_rooms == true and equation.construction_year == true
          estimate = equation.rooms_factor * equation.year_factor * equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
          
          estimate = equation.rooms_factor**1000 * equation.year_factor * equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
          
          estimate = equation.rooms_factor * equation.year_factor**2020 * equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
          
          estimate = equation.rooms_factor**1000 * equation.year_factor**2020 * equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
        elsif equation.property_rooms == true
          estimate = equation.rooms_factor * equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
          
          estimate = equation.rooms_factor**1000 * equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
        elsif equation.construction_year == true
          estimate = equation.year_factor * equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
          
          estimate = equation.year_factor**2020 * equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
        else
          equation.constant.should > 0.0
        end
      end
    end
  end
    
  describe 'fuels factors' do
    it 'should produce reasonable fuels use estimates' do
      LodgingFuelUseEquation.where(:fuel => 'Fuels').each do |equation|
        if equation.property_rooms == true and equation.construction_year == true
          estimate = equation.rooms_factor + equation.year_factor + equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
          
          estimate = equation.rooms_factor * 1000 + equation.year_factor + equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
          
          estimate = equation.rooms_factor + equation.year_factor * 2020 + equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
          
          estimate = equation.rooms_factor * 1000 + equation.year_factor * 2020 + equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
        elsif equation.property_rooms == true
          estimate = equation.rooms_factor + equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
          
          estimate = equation.rooms_factor * 1000 + equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
        elsif equation.construction_year == true
          estimate = equation.year_factor + equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
          
          estimate = equation.year_factor * 2020 + equation.constant
          estimate.should > 0.0 and estimate.should < 1000.0
        else
          equation.constant.should > 0.0
        end
      end
    end
  end
  
  describe 'find_by_criteria' do
    it 'should return the proper equation' do
      LodgingFuelUseEquation.find_by_criteria('Fuels', {}).name.should == 'Fuels'
      LodgingFuelUseEquation.find_by_criteria('Fuels', {:climate_zone_number => ::Charisma::Curator::Curation.new(2) }).name.should == 'Fuels zone 2'
      LodgingFuelUseEquation.find_by_criteria('Fuels', {:climate_zone_number => ::Charisma::Curator::Curation.new(2), :property_rooms => 25}).name.should == 'Fuels zone 2 rooms'
      LodgingFuelUseEquation.find_by_criteria('Fuels', {:climate_zone_number => ::Charisma::Curator::Curation.new(2), :property_rooms => 25, :property_construction_year => 1998}).name.should == 'Fuels zone 2 rooms year'
    end
  end
end
