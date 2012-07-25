module Earth
  module Warnings
    def Warnings.check_mysql_ansi_mode
      if ::ActiveRecord::Base.connection.adapter_name =~ /mysql/i
        sql_mode = ::ActiveRecord::Base.connection.select_value("SELECT @@GLOBAL.sql_mode") + ::ActiveRecord::Base.connection.select_value("SELECT @@SESSION.sql_mode")
        unless sql_mode.downcase.include? 'pipes_as_concat'
          ::Kernel.warn "[earth gem] Warning: MySQL detected, but PIPES_AS_CONCAT not set. Importing from scratch will fail. Consider setting sql-mode=ANSI in my.cnf."
        end
      end
    end
  end
end
