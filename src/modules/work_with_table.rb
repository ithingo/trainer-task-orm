module WorkWithTable
  private

  class Table
    include GhostMethods
    include TypeOperations::TypeConverter

    Column = Struct.new(:col_name, :type, :options)

    attr_reader :table_columns

    def initialize
      @table_columns = Array.new
      @items = Array.new
      @allowed_types = [:text, :string, :float, :integer, :double, :boolean]
      create_methods_for_types @allowed_types
      @user_primary_key = false
      yield(self)
      self.freeze
    end

    def add_column(col_name, col_type, *col_params)
      raise NoColumnParamsError if col_name == '' || col_type == ''
      raise NoSuchColumnDataType unless correct_data_type? @allowed_types, col_type

      @user_primary_key = true if check_user_primary_key col_params
      @table_columns << Column.new(col_name, col_type, *col_params)
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