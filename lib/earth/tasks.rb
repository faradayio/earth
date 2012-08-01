require 'earth'
require 'rake'

module Earth
  class Tasks
    include Rake::DSL

    def initialize(auto_configure = true)
      init_earth_tasks(auto_configure)
      init_bare unless Object.const_defined?('Rails')

      namespace :db do
        task :load_config => 'earth:db:load_config'
        task :migrate => 'earth:db:migrate'
        task :seed => 'earth:db:seed'
      end
    end

    def init_bare
      Object.const_set 'Rails', Earth

      require 'active_record'
      load 'active_record/railties/databases.rake'

      Rake::Task['db:load_config'].clear
      Rake::Task['db:migrate'].clear
      Rake::Task['db:seed'].clear
    end
        
    def init_earth_tasks(auto_configure = true)
      namespace :earth do
        namespace :db do
          task :load_config do
            ActiveRecord::Base.configurations = Earth.database_configurations if auto_configure
          end
          task :migrate => :load_config do
            Earth.reset_schemas!
          end
          task :seed => :load_config do
            Earth.run_data_miner!
          end
        end
      end
    end
  end
end
