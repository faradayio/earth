require 'spec_helper'
Earth.init :industry, :apply_schemas => true

describe Sector do
  def stub_sector
    Sector.stub!(:all).
      and_return([
        mock(Sector, :io_code => '1', :description => 'Staples'),
        mock(Sector, :io_code => '2', :description => 'Example'),
        mock(Sector, :io_code => '3', :description => 'Pencils'),
        mock(Sector, :io_code => '4', :description => 'Pens'),
        mock(Sector, :io_code => '5', :description => 'Rulers'),
        mock(Sector, :io_code => '6', :description => 'Printers'),
        mock(Sector, :io_code => '7', :description => 'Computers'),
        mock(Sector, :io_code => '8', :description => 'Ink'),
        mock(Sector, :io_code => '9', :description => 'Paper'),
        mock(Sector, :io_code => '10', :description => 'Furniture'),
        mock(Sector, :io_code => '11', :description => 'Trucking'),
        mock(Sector, :io_code => '12', :description => 'Sales'),
        mock(Sector, :io_code => '13', :description => 'Strip Malls'),
        mock(Sector, :io_code => '14', :description => 'Displays'),
        mock(Sector, :io_code => '15', :description => 'Cameras'),
        mock(Sector, :io_code => '16', :description => 'Scanners'),
        mock(Sector, :io_code => '17', :description => 'Disks'),
        mock(Sector, :io_code => '18', :description => 'Media'),
        mock(Sector, :io_code => '19', :description => 'Hotel Industry'),
        mock(Sector, :io_code => '20', :description => 'Example'),
        mock(Sector, :io_code => 'A', :description => 'Young fantasy creature processing'),
        mock(Sector, :io_code => 'B', :description => 'Adult fantasy creature processing'),
        mock(Sector, :io_code => 'C', :description => 'Young fantasy creature freezing'),
        mock(Sector, :io_code => 'D', :description => 'Adult fantasy creature freezing')
    ])
  end

  describe 'key_map' do
    before do
      stub_sector
    end

    it 'should return a sorted list of keys' do
      Sector.key_map[0..1].should == ['1','10']
      Sector.key_map[21..22].should == ['C','D']
    end
  end

  describe 'sector_map' do
    before do
      stub_sector
    end

    it 'should generate a hash mapping sector names to io codes' do
      Sector.sector_map.should == {
         'Staples' => '1',
         'Example' => '2',
         'Pencils' => '3',
         'Pens' => '4',
         'Rulers' => '5',
         'Printers' => '6',
         'Computers' => '7',
         'Ink' => '8',
         'Paper' => '9',
         'Furniture' => '10',
         'Trucking' => '11',
         'Sales' => '12',
         'Strip Malls' => '13',
         'Displays' => '14',
         'Cameras' => '15',
         'Scanners' => '16',
         'Disks' => '17',
         'Media' => '18',
         'Hotel Industry' => '19',
         'Example' => '20',
         'Young fantasy creature processing' => 'A',
         'Adult fantasy creature processing' => 'B',
         'Young fantasy creature freezing' => 'C',
         'Adult fantasy creature freezing' => 'D'
      }
    end
  end
end

