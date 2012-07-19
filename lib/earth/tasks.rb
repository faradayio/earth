require 'earth'

Rails = Earth

require 'active_record'
load 'active_record/railties/databases.rake'

Rake::Task['db:load_config'].clear
Rake::Task['db:migrate'].clear
Rake::Task['db:seed'].clear
  
namespace :db do
  task :load_config do
    ActiveRecord::Base.configurations = Earth.database_configurations
  end
  task :migrate => :load_config do
    Earth.init :apply_schemas => true
  end
  task :seed => :load_config do
    Earth.init 
    Earth.run_data_miner!
  end
end
