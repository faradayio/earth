require 'earth/model'
require 'earth/insolation_scopes'

class GlobalHorizontalInsolation < ActiveRecord::Base
  extend Earth::Model
  include Earth::InsolationScopes

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE global_horizontal_insolations
  (
     id     INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
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
     annual_average FLOAT
  );
EOS
  
  warn_if_any_nulls
end
