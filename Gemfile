source :rubygems

# Specify your gem's dependencies in earth.gemspec
gemspec

gem 'data_miner', :path => ENV['LOCAL_DATA_MINER'] if ENV['LOCAL_DATA_MINER']
gem 'sniff', :path => ENV['LOCAL_SNIFF'] if ENV['LOCAL_SNIFF']
gem 'roo', '1.9.3'

if RUBY_VERSION =~ /^1\.8/
  gem 'fastercsv'
end
