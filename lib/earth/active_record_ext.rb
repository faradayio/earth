require 'active_record'
::ActiveRecord::Base.class_eval do
  def self.run_data_miner_on_belongs_to_associations
    reflect_on_all_associations(:belongs_to).each do |a|
      next if a.options[:polymorphic]
      a.klass.run_data_miner!
    end
  end
end
