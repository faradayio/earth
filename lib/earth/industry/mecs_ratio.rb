class MecsRatio < ActiveRecord::Base
  belongs_to :industry

  col :name
  col :census_region
  col :naics_code
  col :consumption_per_dollar_of_shipments, :type => :float

  CENSUS_REGIONS = {
    'Total US' =>  {
      :crop => (16..94),
      :code => nil
    },
    'Northeast' => {
      :crop => (100..178),
      :code => 1
    },
    'Midwest' => {
      :crop => (184..262),
      :code => 2
    },
    'South' =>  {
      :crop => (268..346),
      :code => 3
    },
    'West' => {
      :crop => (352..430),
      :code => 4
    }
  }

  def self.find_by_naics_code_and_census_region(code, census_region)
    if code.blank?
      record = nil 
    else
      code = Industry.format_naics_code code
      record = where('census_region = ? AND naics_code LIKE ?', census_region, "#{code}%").first
      record ||= find_by_naics_code_and_census_region(code[0..-2], census_region)
    end
    record
  end
end
