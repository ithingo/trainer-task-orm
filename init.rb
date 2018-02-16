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
# Wrong test_1.create(name: "Sean Connery", age: 72, address: "New York", year: 2018)