require 'earth/model'

class AutomobileMakeModelYearVariant < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE automobile_make_model_year_variants
  (
     row_hash                          CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     make_name                         CHARACTER VARYING(255),
     model_name                        CHARACTER VARYING(255),
     year                              INTEGER,
     transmission                      CHARACTER VARYING(255),
     speeds                            CHARACTER VARYING(255),
     drive                             CHARACTER VARYING(255),
     fuel_code                         CHARACTER VARYING(255),
     fuel_efficiency                   FLOAT,
     fuel_efficiency_units             CHARACTER VARYING(255),
     fuel_efficiency_city              FLOAT,
     fuel_efficiency_city_units        CHARACTER VARYING(255),
     fuel_efficiency_highway           FLOAT,
     fuel_efficiency_highway_units     CHARACTER VARYING(255),
     alt_fuel_code                     CHARACTER VARYING(255),
     alt_fuel_efficiency               FLOAT,
     alt_fuel_efficiency_units         CHARACTER VARYING(255),
     alt_fuel_efficiency_city          FLOAT,
     alt_fuel_efficiency_city_units    CHARACTER VARYING(255),
     alt_fuel_efficiency_highway       FLOAT,
     alt_fuel_efficiency_highway_units CHARACTER VARYING(255),
     cylinders                         INTEGER,
     displacement                      FLOAT,
     turbo                             BOOLEAN,
     supercharger                      BOOLEAN,
     injection                         BOOLEAN,
     size_class                        CHARACTER VARYING(255),
     type_name                         CHARACTER VARYING(255)
  );
CREATE INDEX index_automobile_make_model_year_variants_on_make_name ON automobile_make_model_year_variants (make_name);
CREATE INDEX index_automobile_make_model_year_variants_on_model_name ON automobile_make_model_year_variants (model_name);
CREATE INDEX index_automobile_make_model_year_variants_on_year ON automobile_make_model_year_variants (year)

EOS

  self.primary_key = "row_hash"
  
  # It looks like synthesizing a unique name would require including pretty much every column from the FEGs
  # (e.g. creeper gear, automatic vs automatic with lockup, feedback fuel system, etc.)
  # The advantages of not keying on row_hash is we could update variants to note whether they're hybrid or not and
  # it would let users specify variants. But my conclusion is that trying to do this won't be much of an improvement
  # because it will be a bunch of work to include all the columns and the names will be really long and obtuse
  # -Ian 10/18/2011
  
  
  warn_unless_size 28433
  warn_unless_size 1152, :conditions => { :year => 1985 }
  warn_unless_size 1183, :conditions => { :year => 1986 }
  warn_unless_size 1206, :conditions => { :year => 1987 }
  warn_unless_size 1104, :conditions => { :year => 1988 }
  warn_unless_size 1137, :conditions => { :year => 1989 }
  warn_unless_size 1049, :conditions => { :year => 1990 }
  warn_unless_size 1062, :conditions => { :year => 1991 }
  warn_unless_size 1055, :conditions => { :year => 1992 }
  warn_unless_size  986, :conditions => { :year => 1993 }
  warn_unless_size  963, :conditions => { :year => 1994 }
  warn_unless_size  917, :conditions => { :year => 1995 }
  warn_unless_size  750, :conditions => { :year => 1996 }
  warn_unless_size  727, :conditions => { :year => 1997 }
  warn_unless_size  794, :conditions => { :year => 1998 }
  warn_unless_size  800, :conditions => { :year => 1999 }
  warn_unless_size  834, :conditions => { :year => 2000 }
  warn_unless_size  846, :conditions => { :year => 2001 }
  warn_unless_size  933, :conditions => { :year => 2002 }
  warn_unless_size  995, :conditions => { :year => 2003 }
  warn_unless_size 1091, :conditions => { :year => 2004 }
  warn_unless_size 1069, :conditions => { :year => 2005 }
  warn_unless_size 1043, :conditions => { :year => 2006 }
  warn_unless_size 1126, :conditions => { :year => 2007 }
  warn_unless_size 1186, :conditions => { :year => 2008 }
  warn_unless_size 1092, :conditions => { :year => 2009 }
  warn_unless_size 1107, :conditions => { :year => 2010 }
  warn_unless_size 1097, :conditions => { :year => 2011 }
  warn_unless_size 1129, :conditions => { :year => 2012 }
  warn_if_nulls_except(
    :alt_fuel_code,
    :cylinders
  )
  warn_if_nulls /alt_fuel_efficiency/, :conditions => 'alt_fuel_code IS NOT NULL'
end
