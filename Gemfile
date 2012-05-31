source :rubygems

gemspec

gem 'alchemist', :git => 'git://github.com/dkastner/alchemist.git', :branch => 'helpers'
gem 'charisma', :git => 'git://github.com/brighterplanet/charisma', :branch => 'alchemist'
gem 'data_miner', :git => 'git://github.com/seamusabshere/data_miner.git'

group :development do
  gem 'guard'
end

unless RUBY_VERSION >= '1.9'
  gem 'fastercsv'
end
