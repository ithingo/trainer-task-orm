require_relative '../../specific/exceptions/no_column_params_error'

module WorkWithTable
  class Table
    Column = Struct.new(:column_name, :type, :options)

    def initialize
      @table_skeleton = Array.new
      yield(self)
    end

    def add_column(column_params = {})
      # raise NoColumn... name\no type name.. if they are nil or not compared to existed types
      # types should be invoked by table_in_iterator.types.string\integer
      # if all's ok, add new column to the array
      raise NoSuchColumnDataType unless correct_data_type? column_params
      raise NoColumnParamError unless column_params[:column_params] || column_params[:type] # check if key present
      @table_column << Column.new(column_params[:column_name], column_params[:type], column_params[:options])
    end

    # def types
    #   def string
    #
    #   end
    # end
    private

    def correct_data_type?(options = {})

    end
  end
end

=begin
how it should look

class Test < BasicOrm
end

test_1 = Test.new do |app|
  app.create_table do |table|
    table.add_column :name, table.types.string, 'not null primary key',
    table.add_column :age, table.types.integer, 'not null'
    table.add_column :address, table.types.text
  end
end
=end