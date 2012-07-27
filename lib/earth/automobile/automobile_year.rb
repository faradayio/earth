require 'earth/model'

class AutomobileYear < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "automobile_years"
  (
     "year" INTEGER NOT NULL PRIMARY KEY
  );
EOS

  self.primary_key = "year"
  
  # Estimate of % of vehicles currently in use that were manufactured in each year
  # Derived from 2012 EPA GHG inventory appendix tables A-91, A-92, and A-95
  # Used by AutomobileMakeModelYear and AutomobileMakeYear to get weighting so other classes can derive weighted fuel efficiency
  def self.weighting(year)
    {
      2012 => 0.0607,
      2011 => 0.0491,
      2010 => 0.0560,
      2009 => 0.0669,
      2008 => 0.0677,
      2007 => 0.0668,
      2006 => 0.0641,
      2005 => 0.0620,
      2004 => 0.0624,
      2003 => 0.0625,
      2002 => 0.0610,
      2001 => 0.0546,
      2000 => 0.0467,
      1999 => 0.0410,
      1998 => 0.0347,
      1997 => 0.0289,
      1996 => 0.0244,
      1995 => 0.0189,
      1994 => 0.0139,
      1993 => 0.0112,
      1992 => 0.0094,
      1991 => 0.0084,
      1990 => 0.0066,
      1989 => 0.0056,
      1988 => 0.0047,
      1987 => 0.0037,
      1986 => 0.0025,
      1985 => 0.0054
    }[year]
  end
  

  warn_unless_size 28
end
