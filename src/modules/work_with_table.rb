module WorkWithTable
  private

  class Table
    include TypeOperations::TypeConverter

    Column = Struct.new(:col_name, :type, :options)

    attr_reader :columns, :user_primary_key

    def initialize
      @columns = Array.new
      @items = Array.new
      @allowed_types = [:text, :string, :float, :integer, :double, :boolean]
      create_methods_for_types @allowed_types
      yield(self)
      self.freeze
    end

    def add_column(col_name, col_type, *col_params)
      raise NoColumnParamsError, 'Base table columns are not specified' if col_name == '' || col_type == ''
      raise NoSuchColumnDataType, "No such column data type: #{col_type}" unless correct_data_type? @allowed_types, col_type

      if check_user_primary_key col_params
        @user_primary_key = true
      else
        @user_primary_key = false
      end
      @columns << Column.new(col_name, col_type, *col_params)
    end

    private

    def check_user_primary_key(col_param)
      unless col_param.first.nil?
        return true if col_param.first.scan(/primary key/)
      end
      return false
    end
  end
end