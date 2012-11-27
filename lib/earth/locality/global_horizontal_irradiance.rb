require 'earth/model'

class GlobalHorizontalIrradiance < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE global_horizontal_irradiances
  (
     id         INTEGER NOT NULL PRIMARY KEY,
     jan_avg    FLOAT,
     feb_avg    FLOAT,
     mar_avg    FLOAT,
     apr_avg    FLOAT,
     may_avg    FLOAT,
     jun_avg    FLOAT,
     jul_avg    FLOAT,
     aug_avg    FLOAT,
     sep_avg    FLOAT,
     oct_avg    FLOAT,
     nov_avg    FLOAT,
     dec_avg    FLOAT,
     annual_avg FLOAT,
     units      CHARACTER VARYING(255),
     geometry   GEOMETRY
  );
EOS

  self.primary_key = 'id'

  warn_unless_size 138970
  warn_if_any_nulls
end
