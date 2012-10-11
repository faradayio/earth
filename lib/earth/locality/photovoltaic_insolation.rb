require 'earth/model'
require 'earth/insolation_scopes'

class PhotovoltaicInsolation < ActiveRecord::Base
  extend Earth::Model
  include Earth::InsolationScopes

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE photovoltaic_insolations
  (
     row_hash       CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     nw_lat         FLOAT,
     nw_lon         FLOAT,
     se_lat         FLOAT,
     se_lon         FLOAT,
     jan_average    FLOAT,
     feb_average    FLOAT,
     mar_average    FLOAT,
     apr_average    FLOAT,
     may_average    FLOAT,
     jun_average    FLOAT,
     jul_average    FLOAT,
     aug_average    FLOAT,
     sep_average    FLOAT,
     oct_average    FLOAT,
     nov_average    FLOAT,
     dec_average    FLOAT,
     annual_average FLOAT,
     units          CHARACTER VARYING(255)
  );
EOS

  self.primary_key = 'row_hash'

  warn_unless_size 90469
  warn_if_any_nulls
end
