require 'spec_helper'
require 'fileutils'
require 'earth'

describe 'Data Mining' do
  it 'is successful for each individual model' do
    Earth.init :all
    #Earth.resource_models.each do |resource|
    [RailFuel].each do |resource|
      begin
        puts resource.to_s
        script_file = File.join(Dir.pwd, 'miner.rb')
        File.open script_file, 'w' do |f|
          f.puts <<-RUBY
require 'earth'
require 'conversions'
DataMiner.unit_converter = :conversions
Earth.init :skip_parent_associations => true, :mine_original_sources => true, :connect => true
require #{File.join(File.dirname(resource.source_file), File.basename(resource.source_file,'.rb')).inspect}
#{resource.to_s}.run_data_miner!
          RUBY
        end

        `bundle exec ruby #{script_file}`
        #$?.to_i.should == 0
      ensure
        FileUtils.rm_f script_file
      end
    end
  end
end

