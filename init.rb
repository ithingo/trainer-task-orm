require 'pg'

# Dir[File.dirname(__FILE__) + '/src/modules/*.rb'].each { |file| require file }
# Dir[File.dirname(__FILE__) + '/src/*.rb'].each { |file| require file }

require_relative 'src/modules/db_connection'
require_relative 'src/modules/own_exceptions'
require_relative 'src/modules/type_operations'
require_relative 'src/modules/work_with_table'
require_relative 'src/basic_orm'

test_1 = BasicORM.new do |app|
  app.create_table do |table|
    table.add_column :name, table.string, 'not null primary key'
    table.add_column :age, table.integer, 'not null'
    table.add_column :address, table.text
  end
end

test_1.create(name: "Vladimir Putin", age: 64, address: "Moscow")
test_1.create(name: "Donald J. Trump", age: 71, address: "Washington D.C.")

test_1.save

test_1.delete(where: 'name like Donald%')
test_1.delete(where: 'age > 34')

test_1.update(where: 'age = 64', change: 'age = 65')

test_1.clear_all!