PetroleumAdministrationForDefenseDistrict.class_eval do
  data_miner do
    import "a list of PADD districts and states derived from the EIA PADD definitions",
           :url => 'http://spreadsheets.google.com/pub?key=t5HM1KbaRngmTUbntg8JwPA&gid=0&output=csv' do
      key   'code',             :field_name => 'Code'
      store 'district_code',    :field_name => 'PAD district code'
      store 'subdistrict_code', :field_name => 'PAD subdistrict code'
      store 'district_name',    :field_name => 'PAD district name'
      store 'subdistrict_name', :field_name => 'PAD subdistrict name'
    end
  end
end

