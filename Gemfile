gem 'data_miner', :path => ENV['LOCAL_DATA_MINER'] if ENV['LOCAL_DATA_MINER']
gem 'sniff', :path => ENV['LOCAL_SNIFF'] if ENV['LOCAL_SNIFF']

source :rubygems

gemspec :path => '.'

if RUBY_VERSION =~ /^1\.8/
  gem 'fastercsv'
end
