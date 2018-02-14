module WorkWithTable
  private

  class Table
    include GhostMethods
    include TypeOperations::TypeConverter

    Column = Struct.new(:col_name, :type, :options)

    def initialize
      @table_columns = Array.new
      @items = Array.new
      @allowed_types = [:text, :string, :float, :integer, :double, :boolean]
      create_methods_for_types @allowed_types

      yield(self)
    end

    def add_column(col_name, col_type, *col_params)
      raise NoColumnParamsError if col_name == '' || col_type == ''
      raise NoSuchColumnDataType unless correct_data_type? @allowed_types, col_type
      @table_columns << Column.new(col_name, col_type, *col_params)
    end

    private

    def create_methods_for_types(type_array)
      type_array.each do |type|
        self.class.send(:define_method, type)  { return type.to_s }
      end
    end

    def correct_data_type?(type_array, type)
        return type_array.include? type.to_sym
    end

  end
end