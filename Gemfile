gem 'data_miner', :path => ENV['LOCAL_DATA_MINER'] if ENV['LOCAL_DATA_MINER']
gem 'create_table', :path => ENV['LOCAL_CREATE_TABLE'] if ENV['LOCAL_CREATE_TABLE']

source :rubygems

gemspec :path => '.'

if RUBY_VERSION < "1.9"
  gem 'fastercsv'
end
