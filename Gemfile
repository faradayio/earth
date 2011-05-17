source :rubygems

# Specify your gem's dependencies in earth.gemspec
gemspec

gem 'data_miner', :path => ENV['LOCAL_DATA_MINER'] if ENV['LOCAL_DATA_MINER']
gem 'sniff', :path => ENV['LOCAL_SNIFF'] if ENV['LOCAL_SNIFF']
gem 'loose_tight_dictionary', :git => 'https://github.com/seamusabshere/loose_tight_dictionary.git', :branch => 'sandbox'

if RUBY_VERSION < "1.9"
  gem 'fastercsv'
end
