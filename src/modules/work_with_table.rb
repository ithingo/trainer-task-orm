# require_relative '../exceptions/no_column_params_error'
# require_relative '../exceptions/no_such_column_data_type'
# require_relative '../exceptions/no_such_method_error'
require_relative 'own_exceptions'
include OwnExceptions

module WorkWithTable
  private

  class Table
    Column = Struct.new(:col_name, :type, :options)

    def initialize
      @table_columns = Array.new
      @allowed_types = [:text, :string, :float, :integer, :double, :boolean]
      create_methods_for_types @allowed_types
      yield(self)
    end

    def add_column(col_name, col_type, *col_params)
      # raise NoSuchMethodError
      raise NoColumnParamsError unless col_name || col_type
      raise NoSuchColumnDataType unless correct_data_type? col_type
      @table_columns << Column.new(col_name, col_type, *col_params)
    end

    private

    def create_methods_for_types(type_array)
      type_array.each do |type|
        self.class.send(:define_method, type)  { return type.to_s }
      end
    end

    def correct_data_type?(type)
        return @allowed_types.include? type.to_sym
    end

  end
end