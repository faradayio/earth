class NationalTransitDatabaseCompany < ActiveRecord::Base
  set_primary_key :id
  set_table_name :ntd_companies
  
  has_many :ntd_records, :foreign_key => 'company_id', :primary_key => 'id', :class_name => 'NationalTransitDatabaseRecord'
  
  def rail_records
    ntd_records.where(:mode_code => NationalTransitDatabaseMode.rail_modes)
  end
  
  def rail_company?
    rail_records.present?
  end
  
  def method_missing(method_id, *args, &block)
    if method_id.to_s =~ /\Arail_([^\?]+_units)\Z/
      units = $1.to_sym
      units_found = rail_records.map(&units).uniq
      if units_found.count == 1
        if units_found[0].present?
          units_found[0]
        else
          raise "#{self.name}'s National Transit Database records are missing #{units.to_s}!"
        end
      else
        raise "#{self.name}'s National Transit Database records contain multiple #{units.to_s}: #{units_found}"
      end
    elsif method_id.to_s =~ /\Arail_(.+)/
      value = $1.to_sym
      rail_records.sum(value) > 0 ? rail_records.sum(value) : nil
    else
      super
    end
  end
  
  col :id
  col :name
  col :acronym
  col :zip_code_name
  col :duns_number
end
