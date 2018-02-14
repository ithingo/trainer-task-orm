Dir[File.dirname(__FILE__) + '/src/modules/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/src/*.rb'].each { |file| require file }

test_1 = BasicORM.new do |app|
  app.create_table do |table|
    table.add_column :name, table.string, 'primary key'
    table.add_column :age, table.integer, 'not null'
    table.add_column :address, table.text
  end
end