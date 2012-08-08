require 'earth/model'

require 'earth/industry/industry'
require 'earth/industry/merchant_category_industry'

class MerchantCategory < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE merchant_categories
  (
     mcc         CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     description CHARACTER VARYING(255)
  );

EOS

  self.primary_key = "mcc"

  has_many :merchant_category_industries, :foreign_key => 'mcc'
  has_many :industries, :through => :merchant_category_industries

  def name
    description
  end

  warn_unless_size 285
end
