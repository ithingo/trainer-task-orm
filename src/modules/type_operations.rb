module TypeOperations
  module TypeConverter
    private

    def correct_data_type?(type_array, type)
      return type_array.include? type.to_sym
    end

    def struct_to_string(struct)
      result = ''
      struct.to_h.each do |key, value|
        if key == :col_name
          result += "#{value.to_s} "
        elsif key == :type
          result += "#{convert_to_sql_type(value)} "
        elsif !value.nil?
          result += "#{value.upcase}"
        end
      end
      result
    end

    def struct_arr_to_string_arr(struct_arr)
      struct_arr.map { |struct| struct_to_string(struct) }
    end

    def get_class_name_downcased
      "#{self.class.to_s.downcase}_table"
    end

    def create_methods_for_types(type_array)
      type_array.each do |type|
        self.class.send(:define_method, type)  { return type.to_s }
      end
    end

    def new_item_some_params_nil?(new_item_options = {}, table_structure_columns)
      table_structure_columns.each do |col_name|
        unless new_item_options[col_name]
          return false
        end
      end
      return true
    end

    def get_table_columns(table_structure)
      table_structure.columns.map {|key| key.to_h[:col_name] }
    end

    def table_columns_to_string(table_columns_array)
      table_columns_array.map{ |col| col.to_s}.join(", ")
    end

    def convert_to_sql_type(old_type)
      sql_type = ''
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
        sql_type = old_type
      end
      sql_type
    end


  end

  module AbstractDomainObject
    private

    class Item
      def initialize(new_param_options = {}, table_columns)
        # dynamically generation attr_accessors at first, then asserting new value to existed instance variables
        table_columns.each do |key|
          self.class.send(:define_method, "#{key}=".to_sym) do |value|
            instance_variable_set("@" + key.to_s, value)
          end
          self.class.send(:define_method, key.to_sym) do
            instance_variable_get("@" + key.to_s)
          end
          self.send("#{key}=".to_sym, new_param_options[key])
        end
      end

      def to_s
        attr = self.instance_variables
        values_for_attr = Array.new
        attr.each do |var|
          column_value = self.send(var.to_s.gsub('@', '').to_sym)
          if column_value.class.to_s.downcase.eql? 'string'
            values_for_attr << "'#{column_value}'"
          else
            values_for_attr << column_value
          end
        end
        values_for_attr.join(", ")
      end
    end
  end

  module SqlQueriesImitation
    include OwnExceptions::PseudoQuery

    private

    ALLOWED_OPERATIONS_FOR_STRING = ['=', '!=', 'like', 'not like']
    ALLOWED_OPERATIONS_FOR_NUMERIC = ['=', '<', '>', '<=', '>=', '!=']

    def check_column_name_in_pseudo_query(allowed_columns, pseudo_query_col_name)
      return true if allowed_columns.include? pseudo_query_col_name.to_sym
      return false
    end

    def check_relation_for_data(relation, data)
      if ALLOWED_OPERATIONS_FOR_NUMERIC.include? relation
        numeric_pattern = /[-+]?\d+(\.\d+)?/
        matches = numeric_pattern.match data
        return true if matches
      elsif ALLOWED_OPERATIONS_FOR_STRING.include? relation
        return true
      end
      return false
    end

    def pseudo_query_to_real(allowed_columns, pseudo_query)
      query_array = pseudo_query.split(" ")
      wrong_column_count = 1
      raise WrongPseudoQuery, 'Wrong parameters for pseudo query' if query_array.length <= wrong_column_count
      raise NoNameInQuery, 'No such column name' unless check_column_name_in_pseudo_query(allowed_columns, query_array[0])
      raise RelationForThisDataNotSupported, 'wrong relation for data' unless check_relation_for_data(query_array[1], query_array[2])

      query_array
    end
  end
end