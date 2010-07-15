AutomobileMakeYear.class_eval do
  data_miner do
    process "Start from scratch" do
      connection.drop_table table_name
    end
    
    schema :options => 'ENGINE=InnoDB default charset=utf8' do
      string   'name'
      string   'make_name'
      integer  'year'
      float    'fuel_efficiency'
      string   'fuel_efficiency_units'
      integer  'volume'
    end

    process "Derive manufacturer names and years from automobile make fleet years" do
      AutomobileMakeFleetYear.run_data_miner!
      connection.execute %{
        INSERT IGNORE INTO automobile_make_years(name, make_name, year)
        SELECT
          automobile_make_fleet_years.make_year_name,
          automobile_make_fleet_years.make_name,
          automobile_make_fleet_years.year
        FROM automobile_make_fleet_years
      }
    end
    
    process "Derive annual corporate average fuel economy across all vehicles from automobile make fleet years" do
      AutomobileMakeFleetYear.run_data_miner!
      make_fleet_years = AutomobileMakeFleetYear.arel_table
      make_years = AutomobileMakeYear.arel_table
      conditional_relation = make_years[:name].eq(make_fleet_years[:make_year_name])
      relation = AutomobileMakeFleetYear.weighted_average_relation(:fuel_efficiency, :weighted_by => :volume).where(conditional_relation)
      update_all "fuel_efficiency = (#{relation.to_sql})"
      update_all "fuel_efficiency_units = 'kilometres_per_litre'"
    end
    
    process "Derive sales volume across all vehicles from automobile make fleet years" do
      connection.execute %{
        UPDATE automobile_make_years SET automobile_make_years.volume = (SELECT SUM(automobile_make_fleet_years.volume) FROM automobile_make_fleet_years WHERE automobile_make_fleet_years.make_year_name = automobile_make_years.name)
      }
    end
  end
end

