module TypeOperations
  module TypeConverter
    private
    def correct_data_type?(type_array, type)
      return type_array.include? type.to_sym
    end

    def stringify_hash_keys(params={})
      result = Hash[params.map { |key, value| [key.to_s, convert_to_sql_type(value)] }]
    end

    def get_class_name_downcased(value)
      value.class.to_s.downcase
    end

    def convert_to_sql_type(old_type)
      case old_type
      when 'integer'
        sql_type = 'INTEGER'
      when 'float'
        sql_type = 'REAL'
      when 'double'
        sql_type = 'DOUBLE PRECISION'
      when 'string'
        sql_type = 'VARCHAR(255)'
      when 'text'
        sql_type = 'TEXT'
      when 'boolean'
        sql_type = 'BOOLEAN'
      else
        sql_type = 'TEXT'
      end
      sql_type
    end

#   convert operation for writing to and getting from db operations

  end

  module Overridden

  end
end