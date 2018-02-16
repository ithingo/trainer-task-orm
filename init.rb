require 'pg'

Dir[File.dirname(__FILE__) + '/src/modules/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/src/*.rb'].each { |file| require file }

test_1 = BasicORM.new do |app|
  app.create_table do |table|
    table.add_column :name, table.string, 'not null primary key'
    table.add_column :age, table.integer, 'not null'
    table.add_column :address, table.text
  end
end

test_1.create(name: "Vladimir Putin", age: 65, address: "Moscow")
test_1.create(name: "Donald J. Trump", age: 71, address: "Washington D.C.")
test_1.save

test_1.delete 'name like Donald%'
test_1.delete 'age > 34'
# test_1.delete 'age is 34'
# test_1.delete 'name is Donald%'

# test_1.update 'what_row', 'condition'

# test_1.clear_all