require 'earth/model'

class MerchantCategory < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "merchant_categories"
  (
     "mcc"         CHARACTER VARYING(255) NOT NULL,
     "description" CHARACTER VARYING(255)
  );
ALTER TABLE "merchant_categories" ADD PRIMARY KEY ("mcc")
EOS

  self.primary_key = "mcc"

  has_many :merchant_category_industries, :foreign_key => 'mcc'
  has_many :industries, :through => :merchant_category_industries

  def name
    description
  end

end
