require_relative 'modules/work_with_table'
require_relative 'modules/type_converter'

class BasicORM
  include WorkWithTypes::TypeConverter
  include WorkWithTable

  def initialize
    @table_name = "#{self.class.to_s.downcase}_table"
    @table = yield(self)
    p @table
  end

  def create_table(&closure)
    table = Table.new(&closure)
    table.freeze
  end
end
#
# test_1 = BasicORM.new do |app|
#   app.create_table do |table|
#     table.add_column :name, table.string, 'not null primary key'
#     table.add_column :age, table.integer, 'not null'
#     table.add_column :address, table.text
#     p app.inspect
#   end
# end