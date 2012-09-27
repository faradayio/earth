require 'earth/model'

class PhotovoltaicInsolation < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE photovoltaic_insolations
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
