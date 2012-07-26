class FlightSeatClass < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "flight_seat_classes"
  (
     "name" CHARACTER VARYING(255) NOT NULL
  );
ALTER TABLE "flight_seat_classes" ADD PRIMARY KEY ("name")
EOS

  self.primary_key = "name"
  

  warn_unless_size 4
end
