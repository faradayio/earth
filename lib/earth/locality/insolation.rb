require 'earth/model'

class Insolation < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE insolations
  (
     id             INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
     zip_code_name  CHARACTER VARYING(255),
     nw_lat         FLOAT,
     nw_lon         FLOAT,
     se_lat         FLOAT,
     se_lon         FLOAT,
     jan_insolation FLOAT,
     feb_insolation FLOAT,
     mar_insolation FLOAT,
     apr_insolation FLOAT,
     may_insolation FLOAT,
     jun_insolation FLOAT,
     jul_insolation FLOAT,
     aug_insolation FLOAT,
     sep_insolation FLOAT,
     oct_insolation FLOAT,
     nov_insolation FLOAT,
     dec_insolation FLOAT,
     average_insolation FLOAT
  );
EOS
  
  warn_if_any_nulls
end
