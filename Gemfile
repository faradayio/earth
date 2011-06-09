gem 'sniff', :path => ENV['LOCAL_SNIFF'] if ENV['LOCAL_SNIFF']
gem 'data_miner', :path => ENV['LOCAL_DATA_MINER'] if ENV['LOCAL_DATA_MINER']

source :rubygems

gemspec :path => '.'

if RUBY_VERSION < "1.9"
  gem 'fastercsv'
end
