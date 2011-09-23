module Earth
  module Utils
    # MySQL's INSERT INTO is not standard SQL
    # ::Earth::Utils.insert_ignore(
    #   :src => AutomobileMakeModelYearVariant,
    #   :dest => AutomobileMakeModelYear,
    #   :cols => {
    #     :make_model_year_name => :name,
    #     :make_name => :make_name,
    #     :name => :model_name,
    #     :make_model_name => :make_model_name,
    #     :year => :year,
    #     :make_year_name => :make_year_name
    #   },
    #   :where => 'LENGTH(src.make_name) > 0 AND LENGTH(src.make_model_name) > 0'
    # )
    # ...executes...
    # INSERT INTO automobile_make_model_years(name,make_name,model_name,make_model_name,year,make_year_name)
    # SELECT MAX(src.make_model_year_name),MAX(src.make_name),MAX(src.name),MAX(src.make_model_name),MAX(src.year),MAX(src.make_year_name)
    # FROM automobile_make_model_year_variants AS src
    # WHERE
    #   src.make_model_year_name IS NOT NULL
    #   AND LENGTH(TRIM(CAST(src.make_model_year_name AS CHAR))) > 0
    #   AND src.make_model_year_name NOT IN (SELECT dest.name FROM automobile_make_model_years AS dest)
    #   AND (1=1)
    # GROUP BY src.make_model_year_name
    def self.insert_ignore(args = {})
      dest_cols = args[:cols].values
      dest_primary_key = args[:dest].primary_key.to_sym
      dest_primary_key_in_src = args[:cols].key(dest_primary_key)
      sql = %{
        INSERT INTO #{args[:dest].table_name}(#{dest_cols.join(',')})
        SELECT #{dest_cols.map { |dest_col| 'MAX(src.' + args[:cols].key(dest_col).to_s + ')' }.join(',')}
        FROM #{args[:src].table_name} AS src
        WHERE
          src.#{dest_primary_key_in_src} IS NOT NULL
          AND LENGTH(TRIM(CAST(src.#{dest_primary_key_in_src} AS CHAR))) > 0
          AND src.#{dest_primary_key_in_src} NOT IN (SELECT dest.#{dest_primary_key} FROM #{args[:dest].table_name} AS dest)
          AND (#{args[:where] || '1=1'})
        GROUP BY src.#{dest_primary_key_in_src}
      }
      ::ActiveRecord::Base.connection.execute sql
    end
  end
end
